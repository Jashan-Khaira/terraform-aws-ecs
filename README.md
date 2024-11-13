# Terraform ECS Fargate Setup for Containerized Web Application on AWS 

This repository contains the Terraform configuration files used to deploy a containerized web application on AWS using ECS Fargate. The setup includes the creation of necessary AWS resources such as a Virtual Private Cloud (VPC), subnets, security groups, an Elastic Load Balancer (ALB), and an Elastic Container Registry (ECR) to store Docker images. The ECS Fargate service is configured to run the application, and Terraform is used for automating the infrastructure deployment.

## Key Features

- **VPC Setup**: Creation of a custom VPC with public and private subnets, routing, and NAT Gateway for secure internet access.
- **ECR Configuration**: Storing and managing the Docker image in Amazon Elastic Container Registry (ECR).
- **ECS Fargate Service**: Defining an ECS service running containerized applications on Fargate.
- **Application Load Balancer (ALB)**: Configuring an ALB to distribute traffic across ECS tasks, ensuring high availability.
- **Terraform Automation**: All infrastructure components are deployed using Terraform for repeatability and version control.

The repository includes detailed Terraform configuration files, along with instructions for deploying the infrastructure. The application is designed to be scalable, secure, and highly available, making it suitable for production environments.

## Technologies Used

- **AWS Console**: To create and manage AWS resources like VPC, ECS, ALB, ECR, etc.
- **Ubuntu WSL (Windows Subsystem for Linux)**: Used for building Docker images and pushing them to AWS Elastic Container Registry (ECR).
- **Visual Studio Code**: IDE used for writing and editing Terraform configuration files with Terraform extension installed.

## Prerequisites

Before you begin, ensure you have the following:

- An AWS account.
- AWS CLI installed and configured with appropriate permissions.
- Terraform installed (version 1.9.8 or higher).
- Docker installed and configured.
- Visual Studio Code installed with the Terraform extension.

## Step-by-Step Setup

### 1. Clone the Repository
Clone this repository to your local machine using Git:
```bash
git clone https://github.com/Jashan-Khaira/terraform-aws-ecs.git
cd terraform-aws-ecs
```

### 2. Configure AWS CLI
If you haven't already configured AWS CLI, run the following command and provide your AWS credentials:
```bash
aws configure
```
You will need your AWS Access Key ID, Secret Access Key, region, and output format.

### 3. Build the Docker Image
Ensure you are inside the project directory where the Dockerfile is located.
Build the Docker image using the following command:
```bash
docker build -t my-app .
```

### 4. Login to AWS ECR
Use the AWS CLI to authenticate Docker to your AWS ECR repository:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com
```

### 5. Push the Docker Image to ECR
Tag the image to match the ECR repository:
```bash
docker tag my-app:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/my-app-repo:latest
```
Push the image to AWS ECR:
```bash
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/my-app-repo:latest
```

### 6. Initialize Terraform
Before you deploy the infrastructure, initialize Terraform:
```bash
terraform init
```

### 7. Plan the Infrastructure
Terraform will generate an execution plan. Run the following command:
```bash
terraform plan
```

### 8. Apply the Configuration
To create the resources defined in your Terraform configuration, apply the plan:
```bash
terraform apply
```
Type `yes` when prompted to confirm the creation of resources.

### 9. Verify Deployment
Once the Terraform apply is complete, verify the deployment by visiting the DNS name of your Application Load Balancer (ALB). You can find this in the AWS Console under the EC2 -> Load Balancers section or by using the following output:
```bash
terraform output alb_dns_name
```
Access the ALB's DNS in your browser to verify that your containerized application is running correctly.

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

## Troubleshooting

- If you face any issues pushing the Docker image to ECR, ensure your AWS CLI is properly configured and you have the correct permissions set for pushing to the repository.
- If the ECS service is not running as expected, check the ECS logs and CloudWatch logs for more details.
- Ensure that all necessary security group rules and VPC routing configurations are in place.


## Support

If you have any questions or need help with setup, please open an issue in the GitHub repository.
