# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.3.0/24"
}

# ECR Repository
resource "aws_ecr_repository" "my_app_repository" {
  name = "my-app-repo"
  tags = {
    Name = "MyAppRepo"
  }
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MyVPC"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet2"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "PrivateSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "MyNATGateway"
  }
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Group
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EcsServiceSecurityGroup"
  }
}

# Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_service_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "MyALB"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "MyTargetGroup"
  }
}

# ALB Listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach ECS Task Execution Managed Policy to IAM Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "my-app-container"
    image     = "${aws_ecr_repository.my_app_repository.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}

# ECS Cluster
resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"
  tags = {
    Name = "MyECSCluster"
  }
}

# ECS Service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet.id]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-app-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.my_listener]
}

# Outputs
output "ecr_repository_url" {
  value = aws_ecr_repository.my_app_repository.repository_url
}

output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}
