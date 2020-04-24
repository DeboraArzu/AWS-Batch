# Stack settings
environment = "dev"
stack_name  = "debora-demo-batch"


# Networks settings
cidr               = "10.1.0.0/16"
public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets    = ["10.1.101.0/24", "10.1.102.0/24"]
availability_zones = ["us-east-1a"]

key_name               = "deborakey"
ecs_ami                = "ami-035ad8e6117e5fde5"
instance-type          = "optimal" 

# Batch configuracion
container_image      = "695292474035.dkr.ecr.us-east-1.amazonaws.com/demo-image-debora:latest"