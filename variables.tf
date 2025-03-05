variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "vpc_cidr_block" {
  type    = string
}
variable "vpc_name" {
  type    = string
}

variable "sn_public_cidr_block" {
  type    = string
}

variable "sn_private_cidr_block" {
  type    = string
}
variable "az_public" {
  type    = string
}

variable "az_private" {
  type    = string
}

variable "public_ip_on_launch" {
  type    = bool
  default = true
}