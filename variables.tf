# Stack Name
variable "cluster_name" {
  type = string
}

# Worker Node instance size
variable "instance_size" {
  type = string
}

# Region
variable "region" {}

variable "desired_size" {
  type = string
  
}
variable "min_size" {
  type = string
  
}
variable "max_size" {
  type = string
}

# AMI ID
variable "ami_id" {
  type = string
}

# Cluster Version
variable "cluster_version" {
  type = string
}

# VPC CNI Version
variable "vpc-cni-version" {
  type        = string
}

# Kube Proxy Version
variable "kube-proxy-version" {
  type        = string
}
variable "key_name" {
  type = string
  
}
