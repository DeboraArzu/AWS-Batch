# AWS Batch  
 [AWS Batch](https://docs.aws.amazon.com/batch/latest/userguide/what-is-batch.html) enables you to run batch computing workloads on the AWS Cloud.     As a fully managed service, AWS Batch enables you to run batch computing workloads of any scale. AWS Batch automatically provisions compute resources and optimizes the workload distribution based on the quantity and scale of the workloads. With AWS Batch, there is no need to install or manage batch computing software, which allows you to focus on analyzing results and solving problems.     

# Terraform
 [Terraform](https://www.terraform.io/downloads.html) is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language, or optionally JSON.
 
# Modules  
 The infrastructure is divided into two modules, `VPC` and `Batch`  

## VPC 
This module created a VPC with the necessary subnets (public and private), internet access, and route tables.    
 
## Batch  
This module creates a managed compute environment, a job definition, and a job queue. It also creates all the necessary roles for the proper execution of a job with batch.     

# Steps to follow     
1. Create a workspace `terraform workspace new dev`  
2. Run `terraform plan -out plan.out -var-file="parameters-$(terraform workspace show).tfvars" ` 
3. Run `terraform apply plan.out`     

To clean up the environment run `terraform destroy -var-file="parameters-$(terraform workspace show).tfvars"` 
