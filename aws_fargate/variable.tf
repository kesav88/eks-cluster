variable "cluster_name" {
  type        = string
  description = "defining cluster name"
  default     = "eks-cluster"


}

variable "subnet_ids" {
  type        = list
  description = "providing subnets"
  default     = ["subnet-0f8e449fcc1b5a384", "subnet-0b08f3466df9fd646"]
  sensitive = true

}
variable "iam_role_eks" {
  type = string
  description = "name of the iam role"
  default = "eks-cluster-example"
}
variable "namespace" {
  type        = string
  description = "providing kubernetes namespace"
  default     = "default"

}
variable "fargate_profile_name" {
  type        = string
  description = "defining fargate profile name"
  default     = "fargate"


}

variable "iam_role_fargate" {
  type = string
  description = "iam role name for fargate profile"
  default = "eks-fargate-profile-example"
  
}
