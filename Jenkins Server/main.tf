#Create VPC

module "vpc" { #you can get this module related link https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source = "terraform-aws-modules/vpc/aws"

  name = "oi-jenkins-vpc"
  cidr = var.vpc_cidr # this section writed seperate 2 files in that project one of them variables.tf one of them terraform.tfvars

  azs = data.aws_availability_zones.azs.names # this section is defined data.tf
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] // we are not using the private subnet this project
  public_subnets = var.public_subnets # this section defined variables.tf and terraform.tfvars

  #enable_nat_gateway = true / we are not going to use
  #enable_vpn_gateway = true / we are not going to use

  enable_dns_hostnames = true # we are add to thise which we want to use

  tags = {
    Name        = "Jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }


  public_subnet_tags = {
    Name = "Jenkins-subnet"
  }
}

#Create SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security Group for Jenkins Server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Jenkins-sg"
  }
}

#Create EC2

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins-Server"

  instance_type               = var.instance_type
  key_name                    = "oi-ansible-KP"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("Jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}
