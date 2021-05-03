variable "region" {
  type = string
}

variable "optional_count" {
}

variable "vm_count" {
}

variable "private" {
}

variable "env_name" {
}

variable "ami" {
}

variable "optional_ami" {
}

variable "instance_type" {
}

variable "subnet_id" {
}

variable "vpc_id" {
}

variable "vpc_cidr" {
}

variable "additional_iam_roles_arn" {
  type    = list(string)
  default = []
}

variable "dns_suffix" {
}

variable "zone_id" {
}

variable "bucket_suffix" {
}

variable "tags" {
  type = map(string)
}

