resource "aws_eks_cluster" "eks_cluster" {
  name = "eks_cluster"


  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = concat(var.public_subnets_ids, var.private_subnets_ids)
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_attach,
  ]
}

resource "aws_eks_node_group" "gatus_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "gatus_node_group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnets_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

 depends_on = [
  aws_iam_role_policy_attachment.node-attachment
]
}