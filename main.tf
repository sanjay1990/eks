module "EKS_NEW" {
  source                = "./Module/EKS_NEW"
  cluster_name          = var.cluster_name
  region                = var.region
  node_group_name       = var.node_group_name
  eks_version           = var.eks_version
  desired_node_capacity = var.desired_node_capacity
  min_node_capacity     = var.min_node_capacity
  max_node_capacity     = var.max_node_capacity
  node_instance_type    = var.node_instance_type
  vpc_id                = var.vpc_id
  ext_subnet_cidrs-a_id = var.ext_subnet_cidrs-a_id
  ext_subnet_cidrs-b_id = var.ext_subnet_cidrs-b_id
  ext_subnet_cidrs-c_id = var.ext_subnet_cidrs-c_id
  app_subnet_cidrs-a_id = var.app_subnet_cidrs-a_id
  app_subnet_cidrs-b_id = var.app_subnet_cidrs-b_id
  app_subnet_cidrs-c_id = var.app_subnet_cidrs-c_id
  elb_subnet_cidrs-a_id = var.elb_subnet_cidrs-a_id
  elb_subnet_cidrs-b_id = var.elb_subnet_cidrs-b_id
  elb_subnet_cidrs-c_id = var.elb_subnet_cidrs-c_id
  rt_id                 = var.rt_id
  ig_id                 = var.ig_id
  natgateway_id         = var.natgateway_id
  dhcp_id               = var.dhcp_id
  tags                  = var.tags
}

