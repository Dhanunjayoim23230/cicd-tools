resource "aws_instance" "Master" {
  ami                    = "ami-0055977a6e828a4f4"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  instance_type          = "t3.small"
  root_block_device {
    volume_size = 50 # Increase from 20 → 50
    volume_type = "gp3"
  }
  user_data = file("master.sh")

  tags = {
    Name = "Control Plane"
  }
}

resource "aws_instance" "Agent-1" {
  ami                    = "ami-0055977a6e828a4f4"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  instance_type          = "t3.small"
  root_block_device {
    volume_size = 50 # Increase from 20 → 50
    volume_type = "gp3"
  }
  user_data = file("agent.sh")

  tags = {
    Name = "Control Plane"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "SG_CP"
  description = " it allows all the traffic in and all teh traffic out"

  ingress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
  tags = {
    Name = "docker_vm_sg"
  }

}

output "MasterAgent_ec2_info" {
  value = aws_instance.ec2.public_ip
}
