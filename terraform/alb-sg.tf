# Security Groups

# LB security group
resource "aws_security_group" "ecs_alb_sg" {
  name        = "ECS_ALB_sg"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Tasks SG
resource "aws_security_group" "ecs_task_sg" {
  name        = "ECS_Task_sg"
  description = "Controls access to ECS tasks"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.ecs_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer

resource "aws_alb" "ecs_alb" {
  name            = "ECS-ALB"
  subnets         = [aws_subnet.ecs_vpc_public-1.id, aws_subnet.ecs_vpc_public-2.id]
  security_groups = [aws_security_group.ecs_alb_sg.id]
}

resource "aws_alb_target_group" "app" {
  name        = "ECS-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.ecs_alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

