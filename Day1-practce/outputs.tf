output "ec2_instance_type" {
  description = "Instance type of the EC2 instance"
  value       = aws_instance.myec2.instance_type
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.myec2.public_ip
}