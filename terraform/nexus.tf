
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg"
  description = "Security group for Nexus Repository"
  vpc_id      = module.vpc.vpc_id   # use your existing VPC reference

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["197.38.244.181/32"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nexus-sg"
  }
}


resource "aws_instance" "nexus" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  tags = {
    Name = "nexus-server"
  }
}
