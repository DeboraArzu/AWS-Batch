######
# Batch
######
resource "aws_batch_compute_environment" "batch" {
  compute_environment_name = "${var.cluster_name}-${var.environment}"
  type                     = "MANAGED"
  compute_resources {
    instance_role = aws_iam_instance_profile.batch_instance_profile.arn

    instance_type = [
      var.instance_type,
    ]

    max_vcpus = 16
    min_vcpus = 0
    
    security_group_ids = [
      "${aws_security_group.demo-batch-sg.id}",
    ]

    subnets = var.subnets

    type = "EC2"
  }
  service_role             = aws_iam_role.ecs_role.arn
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}
resource "aws_batch_job_queue" "master_queue" {
  name                 = "${var.cluster_name}-${var.environment}-queue"
  state                = "ENABLED"
  priority             = 1
  compute_environments = ["${aws_batch_compute_environment.batch.arn}"]
}

resource "aws_batch_job_definition" "veracyte_job_definition" {
  name = "demo_batch_job"
  type = "container"

  container_properties = templatefile("${path.module}/templates/container_properties.json", {
    RoleArn              = aws_iam_role.batch_role.arn,
    container_image      = "${var.container_image}"
  })
}

######
# SERVICE ROLE FOR BATCH
######
resource "aws_iam_role" "ecs_role" {
  assume_role_policy = file("${path.module}/policies/batch-role.json")
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "${var.cluster_name}-${var.environment}-batch-policy"
  policy = templatefile("${path.module}/policies/batch-instance-role-policy.json" , {
    AccountId = "${data.aws_caller_identity.current.account_id}"
  })
  role   = aws_iam_role.ecs_role.id
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.cluster_name}-demo-profileecs-${var.environment}-${data.aws_region.current.name}"
  path = "/"
  role = aws_iam_role.ecs_role.name
}

######
# CONTAINER ROLE 
######
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "batch_role" {
  assume_role_policy = file("${path.module}/policies/batch-role.json")
}

resource "aws_iam_role_policy" "batch_service_policy" {
  name   = "${var.cluster_name}-${var.environment}-batch-policy"
  policy = templatefile("${path.module}/policies/batch-instance-role-policy.json" , {
    AccountId = "${data.aws_caller_identity.current.account_id}"
  })
  role   = aws_iam_role.batch_role.id
}

resource "aws_iam_instance_profile" "batch_instance_profile" {
  name = "${var.cluster_name}-demo-profilebatch-${var.environment}-${data.aws_region.current.name}"
  path = "/"
  role = aws_iam_role.batch_role.name
}

resource "aws_iam_role_policy_attachment" "batchs3_attachment" {
  role       = aws_iam_role.batch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "batch_attachment" {
  role       = aws_iam_role.batch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role_policy_attachment" "batchec2_attachment" {
  role       = aws_iam_role.batch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_security_group" "demo-batch-sg" {
  name = "aws_batch_compute_environment_security_group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}