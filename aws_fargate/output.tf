output "cluster_name" {
  description = "the name of the cluster"
  value       = aws_eks_cluster.eks-cluster.name

}
output "eks_fargate" {
  description = "the name of the fargate"
  value       = aws_eks_fargate_profile.example.cluster_name

}
output "cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.eks-cluster.endpoint
}