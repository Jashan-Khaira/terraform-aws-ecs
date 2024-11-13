# Terraform ECS Fargate Deployment on AWS

This repository contains the Terraform configuration files used to deploy a containerized web application on AWS using ECS Fargate. The setup includes the creation of necessary AWS resources such as a Virtual Private Cloud (VPC), subnets, security groups, an Elastic Load Balancer (ALB), and an Elastic Container Registry (ECR) to store Docker images. The ECS Fargate service is configured to run the application, and Terraform is used for automating the infrastructure deployment.

## Key Features:

- **VPC Setup**: Creation of a custom VPC with public and private subnets, routing, and NAT Gateway for secure internet access.
- **ECR Configuration**: Storing and managing the Docker image in Amazon Elastic Container Registry (ECR).
- **ECS Fargate Service**: Defining an ECS service running containerized applications on Fargate.
- **Application Load Balancer (ALB)**: Configuring an ALB to distribute traffic across ECS tasks, ensuring high availability.
- **Terraform Automation**: All infrastructure components are deployed using Terraform for repeatability and version control.

The repository includes detailed Terraform configuration files, along with instructions for deploying the infrastructure. The application is designed to be scalable, secure, and highly available, making it suitable for production environments.

## Important Terraform Commands

- **`terraform init`**: Initializes a working directory containing Terraform configuration files. This command downloads the necessary provider plugins and prepares the directory for use with Terraform.
  
- **`terraform plan`**: Creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in your configuration files. It helps verify the changes before applying them.
  
- **`terraform apply`**: Applies the changes required to reach the desired state of the configuration. This command will prompt for confirmation before making changes unless the `-auto-approve` flag is used.
  
- **`terraform destroy`**: Destroys the infrastructure defined in the configuration files, removing all the resources created by Terraform. This is useful for cleaning up the environment.
  
- **`terraform validate`**: Validates the syntax and configuration of the Terraform files without actually applying or planning any changes.
  
- **`terraform show`**: Displays the current state of the infrastructure managed by Terraform. It can show the resources that are being managed and their current configuration.
  
- **`terraform output`**: Displays the output values defined in the Terraform configuration, such as the DNS name of the Application Load Balancer or the URL of the ECR repository.
  
- **`terraform refresh`**: Updates the Terraform state with the latest information from the infrastructure, ensuring that the state file reflects the current real-world state of resources.
  
- **`terraform taint`**: Marks a resource for recreation on the next `terraform apply` run. This is useful for forcing the destruction and recreation of a resource that has been modified outside of Terraform.
  
- **`terraform fmt`**: Automatically formats Terraform configuration files according to standard style conventions, making them easier to read and maintain.
