variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ip_range" {
  description = "The IP range for the VPC"
  type        = string
  default     = "10.0.0.0/16" 
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t4g.2xlarge" 
}

variable "public_key_path" {
  description = "Path to the public key to be used for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub" 
}

variable ami_parameter_name {
  default  = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
  type     = string
}