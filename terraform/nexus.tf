resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg"
  description = "Security group for Nexus Repository"
  vpc_id      = module.vpc.vpc_id   # use your existing VPC reference

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]
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
  subnet_id              = aws_subnet.public[0].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  tags = {
    Name = "nexus-server"
  }
}
