terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}
resource "aws_eks_cluster" "danit" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids      = [aws_security_group.danit-cluster.id]
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

  }

  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSVPCResourceController,
  ]
  tags = merge(
    var.tags,
    { Name = "${var.name}" }
  )
}

data "aws_eks_cluster_auth" "danit" {
  name = aws_eks_cluster.danit.name
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.danit.name
  addon_name                  = "coredns"
  addon_version               = "v1.12.4-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.danit]
}

#Ці два блоки також дописані мною
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = var.name
  addon_name    = "vpc-cni"

  depends_on = [aws_eks_cluster.danit]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = var.name
  addon_name    = "kube-proxy"

  depends_on = [aws_eks_cluster.danit]
}