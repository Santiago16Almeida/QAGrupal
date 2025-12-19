provider "aws" {
  region = "us-east-1"
}

# 1. Seguridad
resource "aws_security_group" "web_sg" {
  name        = "sg_final_distribuida"
  description = "Permitir HTTP"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Plantilla de servidores
resource "aws_launch_template" "app_lt" {
  name_prefix   = "template-web-"
  image_id      = "ami-0eb26c4832560b45d" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
}

# 3. Auto Scaling (Lo que te pidieron: 3 a 4 instancias)
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 4
  max_size            = 4
  min_size            = 3
  availability_zones  = ["us-east-1a", "us-east-1b"]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}
