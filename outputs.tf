output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value = aws_instance.our_vm.public_ip
}

output "route53_ns" {
  value = aws_route53_zone.ricardotrevizo.name_servers
}