resource "aws_instance" "frontend" {
  # ubuntu 18.04
  ami = "ami-0c30afcb7ab02233d"
  instance_type = "t2.micro"
    tags = {
    Name = "frontend"
  }
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.frontend.id}"]
  associate_public_ip_address = true
  private_ip = "10.0.0.23"
  key_name = "default-key-pair"
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = [
      "echo ***** UPDATING *****",
      "sudo apt update",
      "echo ***** INSTALL GIT *****",
      "sudo apt install git -y",
      "echo ***** CLONING SCRIPTS *****",
      "git clone https://github.com/JPeckoverQA/scripts.git",
      "echo ***** INSTALL DOCKER *****",
      "./scripts/docker/install-docker.sh",
      "echo ***** INSTALL DOCKER-COMPOSE *****",
      "./scripts/docker-compose/install-docker-compose.sh",
      "echo ***** POOL APP SET UP *****",
      "sudo docker pull jpeckover/pool-frontend-aws-terraform:latest .",
      "sudo docker run -d --name frontend -p 80:80 jpeckover/pool-frontend-aws-terraform:latest"
    ]
  }
}

