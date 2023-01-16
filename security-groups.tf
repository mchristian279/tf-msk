resource "aws_security_group" "sg_msk_cluster" {
  name   = "rules_sg_msk"
  vpc_id = aws_vpc.us_east_1.id

  ingress {
    description = "SSH to EC2"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}