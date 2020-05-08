
//connections.tf
variable "access_key" {}
variable "secret_key" {}
variable "ami_name" {}

provider "aws" {
  region = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.ami_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvZq7Y2gWeXuD/xxzlo5lYXw5ZMhlusqg/5F3K1KvW7cHi9sXOf76QI0jAKijaFqMcMyNpjaMuEOMSgA+MoxPh9CSkfVgGt3toBvwVEs/7fFif7dL6LuWi+52Pmizh7nUg3dRbuWPjmT9jlnnmV4A4A8K/FN/Zjb5lQofsM/fRY+nGq/UFU+bJu/ti5V15ExJoB9cK3cvDComD0W+MIWBWttrCF2DsEF2TB2Ymex4c2iF/ebVTgoxpFyCkjVPEc58/q8lvoLyiN7CovKf7ThjOMrDVxTl+6cCWfP2WHP8634wvQ6ChWFHOtvl7EduPOrU121fhRqyUvNnJxcRAKt/"
}

data "aws_ami" "latest-ami" {
most_recent = true
owners = ["406461302707"] 
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "aws_instance" "test-ec2-instance" {
  ami = "${data.aws_ami.latest-ami.id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_name}"
}


