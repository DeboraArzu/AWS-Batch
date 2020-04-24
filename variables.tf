variable "environment" {
  type = string
}

variable "stack_name" {
  type = string
}
variable "ecs_ami" {
  type = string
}
variable "key_name" {
  type        = string
  description = "pem key"
}
variable "public_subnets" {
  type        = list(string)
  description = "Private "
}
variable "private_subnets" {
  type        = list(string)
  description = "Private "
}
variable "availability_zones" {
  type        = list(string)
  description = "Private "
}
variable "cidr" {
  type        = string
  description = "Private "
}
variable "instance-type" {
  type        = string
  description = "ECS cluster EC2 instance type"
}
variable "container_image" {
  description = "ECR nextflow container image uri"
}