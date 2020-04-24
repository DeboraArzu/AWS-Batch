# Base VPC Creation
#
module "vpc" {
  source = "./modules/vpc"

  name                 = "${var.stack_name}-vpc-${var.environment}"
  cidr                 = var.cidr
  azs                  = var.availability_zones
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

# BATCH cluster for frontend services
module "demo-batch" {
  source = "./modules/batch"

  ami_id                   = var.ecs_ami
  cluster_name             = var.stack_name
  environment              = var.environment
  instance_type            = var.instance-type
  key_name                 = var.key_name
  private_sn               = module.vpc.private_subnets
  container_image          = var.container_image
  vpc_id                   = module.vpc.vpc_id
  subnets                  = module.vpc.private_subnets
}