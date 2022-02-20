#
#
#
#
#
#

provider "aws" {
    region = "us-east-2"
}
/**/

variable "key_name" {}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "server" {
    ami = "ami-049c42843f058aebb"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver.id]
    key_name = aws_key_pair.kp.key_name
    provisioner "local-exec" {
    command = "echo ${aws_instance.server.public_ip} >> ip.txt"
    }
}

#resource "aws_instance" "front-ub" {
#    ami = "ami-0fb653ca2d3203ac1"
#    instance_type = "t2.micro"
#    vpc_security_group_ids = [aws_security_group.webserver.id]
#    key_name = aws_key_pair.kp.key_name
#    provisioner "local-exec" {
#    command = "echo ${aws_instance.front-ub.public_ip} >> ip.txt"
#    }
#}

resource "aws_instance" "monitoring" {
    ami = "ami-049c42843f058aebb"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver.id]
    key_name = aws_key_pair.kp.key_name
    provisioner "local-exec" {
    command = "echo ${aws_instance.monitoring.public_ip} >> ip.txt"
    }
}

resource "aws_security_group" "webserver" {
  name        = "webserver-security-group"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
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
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
