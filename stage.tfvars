
# VPC values
vpc_id                 = "vpc-4a42842f"
ext_subnet_cidrs-a_id  = "subnet-5db4dd71"
ext_subnet_cidrs-b_id  = "subnet-30ba9978"
ext_subnet_cidrs-c_id  = "subnet-318ff76b"
app_subnet_cidrs-a_id  = "subnet-619af34d"
app_subnet_cidrs-b_id  = "subnet-6486a52c"
app_subnet_cidrs-c_id  = "subnet-0a81f950"
elb_subnet_cidrs-a_id  = "subnet-5b86ef77"
elb_subnet_cidrs-b_id  = "subnet-a681a2ee"
elb_subnet_cidrs-c_id  = "subnet-7180f82b"
rt_id                  = "rtb-b801c5dd"
ig_id                  = "igw-b5a04bd0"
natgateway_id          = "nat-0f18c5993093d4b72"
dhcp_id                = "dopt-0874060768106c8a0"
node_instance_type     = "c6a.4xlarge"
region                 = "us-east-1"
cluster_name           = "jlr-stage-eks-cluster"
node_group_name        = "jlr-stage-node-group"
eks_version            = "1.31"
desired_node_capacity  = "5"
min_node_capacity      = "1"
max_node_capacity      = "20"
tags                   = {
    Name = "STAGE-EKS-Node"
    Env = "Stage"
}









