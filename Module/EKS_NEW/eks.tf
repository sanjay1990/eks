# Retrieve the existing EKS cluster details
data "aws_eks_cluster" "eks" {
  name = "jlr-stage-eks-cluster"  
}

# Retrieve the EKS Cluster Security Group created by AWS
data "aws_security_group" "eks_cluster_sg" {
  id = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
#provider "aws" {
#  region = var.region
#}

resource "aws_eks_cluster" "jlr_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.jlr_eks_cluster_role12.arn
  version  = var.eks_version
  tags     = {
     Name = "eks-node-stage"
  }
 
  vpc_config {
#    vpc_id             = var.vpc_id
    subnet_ids         = [var.app_subnet_cidrs-a_id,var.app_subnet_cidrs-b_id]
#    security_group_ids = [aws_security_group.jlr_test_eks_sg.id]
    endpoint_public_access = true
    endpoint_private_access = false 
  }
}

resource "aws_security_group" "jlr_eks_node_sg" {
  name        = "jlr_eks_node_sg"
  description = "Security group for the EKS cluster"

  vpc_id = var.vpc_id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
     }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
     }
 
}
resource "aws_launch_template" "eks_launch_template" {
  instance_type = var.node_instance_type
  key_name      = "jlr-stage-useast1"
  #image_id  = "ami-0b94752294befca8a"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = "stage"
      name     = "jlr-eks-node"
    }
  }
  vpc_security_group_ids = [aws_security_group.jlr_eks_node_sg.id,data.aws_security_group.eks_cluster_sg.id]
  user_data = filebase64("Module/EKS_NEW/userdata.sh")


  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 40
      volume_type = "gp3"
      throughput  = "125"
      encrypted   = false
      iops        = 3000
    }
  }
}

# IAM roles to the nodes to use EFS.
resource "aws_iam_policy" "node_efs_policy12" {
  name = "eks_node_efs_policy"
  path = "/"
  description = "Policy for nodes to use EFS"

  policy = jsonencode ({
    "Statement": [
        {
            "Action": [
                "elasticfilesystem:DescribeMountTargets",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:CreateAccessPoint",
                "elasticfilesystem:DeleteAccessPoint",
                "ec2:DescribeAvailabilityZones"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        }
    ],
    "Version": "2012-10-17"
}
  )
}
resource "aws_eks_node_group" "jlr_node_group" {
  cluster_name    = aws_eks_cluster.jlr_eks_cluster.name
  node_group_name = var.node_group_name
  #ami_type  = "CUSTOM"
  node_role_arn   = aws_iam_role.jlr_node_group_role12.arn
  subnet_ids      = [var.app_subnet_cidrs-a_id,var.app_subnet_cidrs-b_id]
  #instance_types  = [var.node_instance_type]
  #remote_access {
  #   ec2_ssh_key = "jlr-stage-useast1"
  #}
 # security_group  = [aws_security_group.jlr_security_group]

  scaling_config {
    desired_size = var.desired_node_capacity
    min_size     = var.min_node_capacity
    max_size     = var.max_node_capacity

  }
# Tags for the node group
  tags = {
    Environment = "Stage"
    Team        = "jlr-eks-node"
  }
  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version # Optionally specify the version of the launch template
  }
}

resource "aws_iam_role" "jlr_eks_cluster_role12" {
  name = "jlr-eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "jlr-AmazonEKSClusterPolicy12" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.jlr_eks_cluster_role12.name
}
resource "aws_iam_role_policy_attachment" "jlr-AmazonEKSServicePolicy12" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.jlr_eks_cluster_role12.name
}

resource "aws_iam_role" "jlr_node_group_role12" {
  name = "jlr-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "jlr-AmazonEKSVPCResourceController12" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.jlr_node_group_role12.name
}
resource "aws_iam_role_policy_attachment" "jlr-AmazonEKSVPCResourceController_212" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.jlr_node_group_role12.name
}
resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy12" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.jlr_node_group_role12.name
}
