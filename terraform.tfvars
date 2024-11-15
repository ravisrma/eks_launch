cluster_name       = "eks-cluster"
instance_size      = "t2.medium"
desired_size       = 2
max_size           = 5
min_size           = 2
region             = "ap-south-1"
cluster_version    = "1.31"
vpc-cni-version    = "v1.18.6-eksbuild.1"
kube-proxy-version = "v1.31.1-eksbuild.2"
key_name           = "test"
ami_id             = "ami-049d1c90f4603d6db"