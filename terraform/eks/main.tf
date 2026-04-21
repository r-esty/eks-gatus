resource "aws_eks_cluster" "eks_cluster" {
  name = "eks_cluster"


  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = concat(var.public_subnets_ids, var.private_subnets_ids)
    security_group_ids = [ aws_security_group.eks_sg.id ]
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


resource "aws_security_group" "eks_sg" {
  name        = "eks_sg"
  description = "Security group the eks' vpc"
  vpc_id      = var.vpc_id

  tags = {
    Name = "gatus-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http-ingress" {
  security_group_id = aws_security_group.eks_sg.id
  from_port         = 80
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https-ingress" {
  security_group_id = aws_security_group.eks_sg.id
  from_port         = 443
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.eks_sg.id
  ip_protocol       = "-1" 
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "node_to_node" {
  security_group_id            = aws_security_group.eks_sg.id
  referenced_security_group_id = aws_security_group.eks_sg.id
  ip_protocol                  = "-1"
}