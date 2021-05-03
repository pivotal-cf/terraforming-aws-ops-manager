variable "rds_db_username" {
  default = "admin"
}

variable "rds_instance_class" {
  default = "db.m5.large"
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "db_port" {
}

variable "rds_instance_count" {
  type    = string
  default = 0
}

variable "env_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

locals {
  rds_cidr = cidrsubnet(var.vpc_cidr, 6, 3)
}

