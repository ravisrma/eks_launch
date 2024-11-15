# Creating EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.master_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  }
  

  tags = {
    Name = var.cluster_name
  }
}

#Creating Launch Template for Worker Nodes
resource "aws_launch_template" "worker-node-launch-template" {
  name = "worker-node-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
    }
  }

  image_id      = var.image_id
  instance_type = var.instance_size
  user_data = base64encode(file("${path.module}/bootstrap.sh"))
  key_name = var.key_name
  vpc_security_group_ids = [var.eks_security_group_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Worker-Nodes"
    }
  }
}


# Creating Worker Node Group
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Worker-Node-Group"
  node_role_arn   = var.worker_arn
  subnet_ids      = [var.public_subnet_az1_id, var.public_subnet_az2_id]

  launch_template {
    id      = aws_launch_template.worker-node-launch-template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }
  tags = {
    "Name" = "eks-worker-node"
  }
}

locals {
  eks_addons = {
    "vpc-cni" = {
      version           = var.vpc-cni-version
      resolve_conflicts = "OVERWRITE"
    },
    "kube-proxy" = {
      version           = var.kube-proxy-version
      resolve_conflicts = "OVERWRITE"
    },
    "coredns" = {
      version           = "v1.11.3-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
    }
  }
}

resource "aws_eks_addon" "example" {
  for_each = local.eks_addons

  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = each.key
  addon_version               = each.value.version
  resolve_conflicts_on_update = each.value.resolve_conflicts

}