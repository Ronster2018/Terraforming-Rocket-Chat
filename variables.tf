variable "region" {
  type        = string
  description = "Your desired AWS region"
  default     = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "Your desired Availability Zone"
  default     = "us-east-1a"
}

variable "instance_ami" {
  type        = string
  description = "The Ubuntu based AMI instance ID"
  default     = "ami-053b0d53c279acc90" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-05-16
}

variable "instance_type" {
  type        = string
  description = "The AWS instance type"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "The existing AWS key pair"
  default     = "default-key-pair"
}
