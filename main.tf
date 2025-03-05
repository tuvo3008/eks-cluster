module "networking" {
  source         = "./modules/networking"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
  sn_public_cidr_block = var.sn_public_cidr_block
  sn_private_cidr_block = var.sn_private_cidr_block
  az_public = var.az_public
  az_private = var.az_private
  tag = {
    Environment = "dev"
  }
}


module "eks" {
  source = "./modules/eks"

  cluster_name       = "tuvo-eks-cluster"
  subnet_ids         = concat(module.networking.private_subnet_ids, module.networking.public_subnet_ids)
  security_group_id  = module.networking.eks_security_group_id
  kubernetes_version = "1.27"
  tags = {
    Environment = "development"
    Project     = "eks-mockproject"
  }
}

module "node_group" {
  source       = "./modules/node_group"
  cluster_name = module.eks.cluster_name
  subnet_ids   = concat(module.networking.private_subnet_ids, module.networking.public_subnet_ids)
  tags = {
    Environment = "Dev"
  }
}
