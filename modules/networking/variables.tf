variable "vpc_cidr_block" {
  type    = string
}
variable "vpc_name" {
  type    = string
}

variable "tag" {
  description = "Tags value"
  type        = map(string)
   default     = {
    Costcenter = "devops2402"
  }
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