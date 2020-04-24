data "aws_region" "current" {}

variable "ami_id" {
  description = "Ami Id for instances in the cluster , as per region (The below mentioned is for us-east-2)"
  default     = "ami-4b7daa32" # "ami-0aa9ee1fc70e57450"
}
variable "cluster_name" {
  description = "name of cluster"
  default     = "demo-ECS-cluster"
}

variable "environment" {
  description = "name of environment"
}
variable "instance_type" {
  description = "Type of instances in the cluster"
  default     = "t2.micro"
}
variable "key_name" {
  description = "Desired number of instances in the cluster"
}
variable "container_image" {
  description = "ECR nextflow container image uri"
}
variable "private_sn" {
  description = "private subnet 1"
}
variable "subnets" {
  description = "subnets id for batch compute environment"
}
variable "vpc_id" {
  description = "vpc id for security group"
}