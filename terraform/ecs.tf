# ECS

resource "aws_ecs_cluster" "app_cluster" {
  name = "APP_ECS_CLUSTER"
}

resource "aws_ecs_task_definition" "app_def" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = <<DEF
[
  {
    "cpu": 256,
    "image": "${var.image_name}",
    "memory": 512,
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEF
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ECS_SERVICE"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_def.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_task_sg.id]
    subnets         = [aws_subnet.ecs_vpc_public-1.id, aws_subnet.ecs_vpc_public-2.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "app"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.front_end]
}