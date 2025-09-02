module "vpc" {
  source       = "./modules/vpc"
  infra_region = var.infra_region
  vpc_name     = var.vpc_name
}

module "eks" {
  source       = "./modules/eks"
  pub_subnet01 = module.vpc.pub_subnet01
  pub_subnet02 = module.vpc.pub_subnet02
  pvt_subnet01 = module.vpc.pvt_subnet01
  pvt_subnet02 = module.vpc.pvt_subnet02
}