variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

}

variable "private_subnets" {
  type        = list(string)
  description = "Subnets CIDR"
}

variable "public_subnets" {
  type        = list(string)
  description = "Subnets CIDR"
}