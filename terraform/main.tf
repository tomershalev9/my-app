resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "webservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 512
  memory                   = 2048
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "web",
      "image"     : "tomershalev9/myapp:web",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort"      : 3000
        }
      ]
    }
  ]
  DEFINITION

  depends_on = [
    aws_ecs_task_definition.mongo
  ]
}

resource "aws_ecs_task_definition" "mongo" {
  family                   = "mongoservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 512
  memory                   = 2048
  container_definitions    = jsonencode([
    {
      "name"      : "mongo",
      "image"     : "mongo",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 27017
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "webservice" {
  name             = "webservice"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.web.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


# module "mongo-task-definition" {
#   source = "github.com/mongodb/terraform-aws-ecs-task-definition"

#   family = "mongo"
#   network_mode = "awsvpc"
#   image  = "tomershalev9/myapp:mongo"
#   memory = 2048
#   name   = "mongo"
##   count  = 1

#   portMappings = [
#     {
#       containerPort = 27017
#     },
#   ]
# }

resource "aws_ecs_service" "mongoservice" {
  name             = "mongoservice"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.mongo.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


# resource "aws_lb" "web" {
#   name               = "web-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups   = [aws_security_group.sg.id]
#   subnets            = [aws_subnet.subnet.id]

#   enable_deletion_protection = false 
# }


# resource "aws_lb_target_group" "web" {
#   name     = "web-target-group"
#   port     = 3000             
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200-399" 
#     interval            = 30
#     timeout             = 10
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#   }
# }


# resource "aws_lb_listener" "web" {
#   load_balancer_arn = aws_lb.web.arn
#   port              = 80

#   default_action {
#     target_group_arn = aws_lb_target_group.web.arn
#     type             = "forward"
#   }
# }