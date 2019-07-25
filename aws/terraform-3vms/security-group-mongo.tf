resource "aws_security_group" "mongo" {
  name = "mongo-security-group"
  description = "Mongo Security Group"
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port = 27017
    to_port = 27017
    protocol = "TCP"
    cidr_blocks = ["${aws_subnet.default.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}