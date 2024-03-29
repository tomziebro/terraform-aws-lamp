variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "ami" {
  description = "Amazon Linux 2 AMI - HVM"
  default     = "ami-033b95fb8079dc481"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet1_cidr" {
  description = "CIDR for the Private Subnet1"
  default     = "10.0.2.0/24"
}

variable "zero_addr_cidr" {
  description = "Internet IPv4 Quad Zero Route"
  default     = "0.0.0.0/0"
}
