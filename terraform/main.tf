
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

 # VPC old version = "4.0"

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
 
  version = "6.5.1"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    "kubernetes.io/cluster/mona-eks-cluster-v2" = "shared"
  }
}

 # VPC old version = "19.0.1"
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
   version = "20.0.1"

  cluster_name    = "mona-eks-cluster-v2"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # FREE-TIER SAFE NODE GROUP
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.micro"]

      min_size     = 3
      max_size     = 3
      desired_size = 3

      ami_type = "AL2_x86_64"

      tags = {
        Name = "mona-eks-node"
      }
    }
  }

  tags = {
    Environment = "dev"
  }
}
# ECR Repository for Backend
resource "aws_ecr_repository" "backend" {
  name                 = "backend"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "dev"
    Project     = "mona"
  }
}

# ECR Repository for Frontend
resource "aws_ecr_repository" "frontend" {
  name                 = "frontend"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "dev"
    Project     = "mona"
  }
}


data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

