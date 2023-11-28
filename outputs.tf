output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}

output "subnet_id" {
  value = aws_subnet.dev_subnet.id
}

output "security_group_id" {
  value = aws_security_group.dev_secgrp.id
}

output "ec2_instance_id" {
  value = aws_instance.dev_instance.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.latest_amazon_linux_ami.value
  sensitive = true
}

output "public_ip" {
  value = aws_instance.dev_instance.public_ip
}

output "private_ip" {
  value = aws_instance.dev_instance.private_ip
}

output "ssh_command" {
  value = "ssh -i ${var.public_key_path} ec2-user@${aws_instance.dev_instance.public_ip}"
}