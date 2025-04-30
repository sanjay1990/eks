variable "region" {
  description = "AWS region for the EKS cluster."
  type        = string
#  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
#  default     = "jlr-test-eks-cluster"
}

variable "node_group_name" {
  description = "Name of the EKS node group."
  type        = string
#  default     = "jlr-test-node-group"
}

variable "eks_version" {
  description = "Version of EKS to use for the cluster."
  type        = string
#  default     = "1.27"
}

variable "desired_node_capacity" {
  description = "Desired capacity of the EKS node group."
  type        = number
#  default     = 3
}

variable "min_node_capacity" {
  description = "Minimum capacity of the EKS node group."
  type        = number
#  default     = 1
}

variable "max_node_capacity" {
  description = "Maximum capacity of the EKS node group."
  type        = number
#  default     = 5
}


variable "node_instance_type" {
  description = "size  of the EKS node "
  type        = string
# default  =   "c6a.4xlarge"
}

variable "vpc_id" {
  description = "vpc id number"
  type        =  string
}

variable "ext_subnet_cidrs-a_id" {
   description = "subnet id for ext"
   type        =  string
 }

variable "ext_subnet_cidrs-b_id" {
   description = "subnet id for ext"
   type        =  string
 }

variable "ext_subnet_cidrs-c_id" {
   description = "subnet id for ext"
   type        =  string
 }
 
variable "app_subnet_cidrs-a_id" {
  description = "subnet id for app"
  type        =  string
}

variable "app_subnet_cidrs-b_id" {
  description = "subnet id for app"
  type        =  string
}

variable "app_subnet_cidrs-c_id" {
  description = "subnet id for app"
  type        =  string
}

variable "elb_subnet_cidrs-a_id" {
  description = "subnet id for elb"
  type        =  string
}

variable "elb_subnet_cidrs-b_id" {
  description = "subnet id for elb"
  type        =  string
}

variable "elb_subnet_cidrs-c_id" {
  description = "subnet id for elb"
  type        =  string
}
variable "rt_id" {
  description = "Route table id "
  type        =  string
}
variable "ig_id" {
  description = "InternetGateway  id "
  type        =  string
}
variable "natgateway_id" {
  description = "NatGateway  id "
  type        =  string
}
variable "dhcp_id" {
  description = "dhcp  id"
  type        = string
}
variable "tags" {
  type        = map(string)
}