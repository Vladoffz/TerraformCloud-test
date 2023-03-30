provider "aws" {}


terraform {
  backend "s3" {
    bucket = "bucket-remote-test"
    key = "workspace/terraform.tfstate"
  }
}

resource "aws_eip" "for_workspace" {
  instance = aws_instance.workspace_test.id
}

resource "aws_instance" "workspace_test" {
  ami = var.ami
  instance_type = var.instance_size
  vpc_security_group_ids = [aws_security_group.workspace-sg2.id]
  tags = {
    env = "Prod",
    workspace = "${terraform.workspace}"
    owner = "Hundarcuk"
  }
  depends_on = [
    aws_security_group.workspace-sg2
  ]
}

resource "aws_security_group" "workspace-sg2" {
  name = "workspace-sg2"
  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}
