output "public_subnets_ids" {

    value = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnets_ids" {

    value = [for s in aws_subnet.private_subnets : s.id]
  
}