variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

}

variable "public_subnets" {
  type        = list(string)
  description = "Subnets CIDR"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}