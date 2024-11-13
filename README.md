# Terraform ECS Fargate Deployment on AWS

This repository contains the Terraform configuration files used to deploy a containerized web application on AWS using ECS Fargate. The setup includes the creation of necessary AWS resources such as a Virtual Private Cloud (VPC), subnets, security groups, an Elastic Load Balancer (ALB), and an Elastic Container Registry (ECR) to store Docker images. The ECS Fargate service is configured to run the application, and Terraform is used for automating the infrastructure deployment.

## Key Features:

- **VPC Setup**: Creation of a custom VPC with public and private subnets, routing, and NAT Gateway for secure internet access.
- **ECR Configuration**: Storing and managing the Docker image in Amazon Elastic Container Registry (ECR).
- **ECS Fargate Service**: Defining an ECS service running containerized applications on Fargate.
- **Application Load Balancer (ALB)**: Configuring an ALB to distribute traffic across ECS tasks, ensuring high availability.
- **Terraform Automation**: All infrastructure components are deployed using Terraform for repeatability and version control.

The repository includes detailed Terraform configuration files, along with instructions for deploying the infrastructure. The application is designed to be scalable, secure, and highly available, making it suitable for production environments.
