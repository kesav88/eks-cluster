# terraform {
#   required_version = "> 1.2"
# }
#provider "aws" {
#  access_key = "AKIARGHMKS4X5J27I6EI"
#  secret_key = "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"
#  region     = "ap-south-1"
#
#}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
    #aws_iam_role_policy_attachment.alb_policy
  ]
}
# resource "aws_iam_openid_connect_provider" "oidc_provider" {
#   url            = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
#   client_id_list = ["sts.amazonaws.com"]
# }
# resource "aws_iam_policy" "alb_role_policy" {
#   name = "dev-kk-efs-alb-policy"
#   policy = file()
  
# }

# data "aws_iam_policy_document" "alb_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect = "Allow"

#     condition {
#      test    = "StringEquals"
#     variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
#      values  = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
#     }

#    principals {
#       identifiers = [aws_iam_openid_connect_provider.eks_cluster.arn]
#       type = "Federated"
#     }
#   }
# }
# resource "aws_iam_role" "alb_role" {
#   assume_role_policy = data.aws_iam_policy_document.alb_assume_role_policy.json
#   name  = "dev-kk-efs-alb-role"
# }
# resource "aws_iam_role_policy_attachment" "alb_policy" {
#   policy_arn = aws_iam_policy.alb_role_policy.arn
#   role = aws_iam_role.alb_role.name
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# resource "aws_iam_role" "example2" {
#   name               = "eks-alb"
#   assume_role_policy = data.aws_iam_policy_document.alb_role.json
# }

resource "aws_iam_role" "example" {
  name               = var.iam_role_eks
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# resource "aws_iam_role_policy_attachment" "example2-AWSLoadBalancerControllerIAMPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
#   role       = aws_iam_role.example2.name
# }

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}


resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = aws_eks_cluster.eks-cluster.name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.example1.arn
  subnet_ids             = var.subnet_ids
  selector {
    namespace = var.namespace
  }
}
resource "aws_iam_role" "example1" {
  name = var.iam_role_fargate

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example1-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.example1.name
}
