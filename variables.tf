variable "key_name" {
  default = "Cool_Key_Name"
}

variable "public_key" {
  default = "your_public_key"
}

#default security group within the aws ec2 instance
variable "security_group" {
  default = "sg-security_group"
}

variable "private_key" {
  default = "../.ssh/location_to_secret_key.pem"
}
