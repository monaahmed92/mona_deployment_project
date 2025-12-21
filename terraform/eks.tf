module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

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
    Environment = var.environment
  }
}
