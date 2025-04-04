provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus-sg"
  description = "Security group for Prometheus machine"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "infra_sg" {
  name        = "infra-sg"
  description = "Security group for Infra machine"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Security group for App machine"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prometheus" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]

  tags = {
    Name = "Prometheus"
  }
}

resource "aws_instance" "infra" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.infra_sg.id]

  tags = {
    Name = "Infra"
  }
}

resource "aws_instance" "app" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "App"
  }
}

output "public_ips" {
  value = {
    prometheus = aws_instance.prometheus.public_ip
    infra      = aws_instance.infra.public_ip
    app        = aws_instance.app.public_ip
  }
}
