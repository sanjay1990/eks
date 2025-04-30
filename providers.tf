terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
  backend "s3" {
    bucket = "jlr-stage-tfstate" # bucket name
    key    = "jlr-stage-tfstate/terraform.tfstate" #path to your tfstate file
    region = "us-east-1" 
    dynamodb_table = "jlr-stage-state-lock" #dynamoDB table name
    encrypt = true
    profile = "dtsdevices-jlr-stage" 
  }
}
provider "aws" {
  region	= "us-east-1"
  profile	= "dtsdevices-jlr-stage"
}
