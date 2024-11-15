# Creating VPC
module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
}

#Creating security group
module "security_groups" {
  source       = "./modules/security-group"
  vpc_id       = module.vpc.vpc_id
  cluster_name = var.cluster_name
  

}

# Creating IAM resources
module "iam" {
  source = "./modules/iam"
}


# Creating EKS Cluster
module "eks" {
  source = "./modules/eks"
  master_arn = module.iam.master_arn
  worker_arn = module.iam.worker_arn
  cluster_name = var.cluster_name
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  eks_security_group_id = module.security_groups.eks_security_group_id
  instance_size = var.instance_size
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
  image_id = var.ami_id
  cluster_version = var.cluster_version
  key_name = var.key_name
  kube-proxy-version = var.kube-proxy-version
  vpc-cni-version = var.vpc-cni-version
}