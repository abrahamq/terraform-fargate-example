### ECS
resource "aws_ecs_cluster" "this" {
  name = "tf-broward-production"
}

### one service for web, one for the data server
resource "aws_ecs_task_definition" "web" {
  family                   = "web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
	execution_role_arn       = "arn:aws:iam::151035343788:role/ecsTaskExecutionRole"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.web_app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.slr-server.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "pre"
      }
    }
	}
]
DEFINITION
}

resource "aws_ecs_service" "web" {
  name            = "tf-ecs-web-service"
  cluster         = "${aws_ecs_cluster.this.id}"
  task_definition = "${aws_ecs_task_definition.web.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = "${aws_subnet.private.*.id}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "app"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}


### data service
resource "aws_cloudwatch_log_group" "slr-server" {
  name = "slr-server-group"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}

resource "aws_ecs_task_definition" "data" {
  family                   = "slr-server"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
	execution_role_arn       = "arn:aws:iam::151035343788:role/ecsTaskExecutionRole"



  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.data_app_image}",
    "memory": ${var.fargate_memory},
    "name": "slr-server",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.data_app_port},
        "hostPort": ${var.data_app_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.slr-server.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "pre"
      }
    }
	}
]
DEFINITION
}

resource "aws_ecs_service" "data" {
  name            = "tf-ecs-data-service"
  cluster         = "${aws_ecs_cluster.this.id}"
  task_definition = "${aws_ecs_task_definition.data.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  // we ignore changes to the container definition in order to
  // manually place secret environment variables through the
  // aws console.
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = "${aws_subnet.private.*.id}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.data.id}"
    container_name   = "slr-server"
    container_port   = "${var.data_app_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}