output "vpc_id" {
  value = aws_vpc.tu-vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.tu-sn-public.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.tu-sn-private.id
  ]
}

output "eks_security_group_id" {
  description = "ID of the security group for EKS"
  value       = aws_security_group.eks_security_group.id
}