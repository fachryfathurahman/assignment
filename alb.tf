resource "aws_lb" "alb_primary" {
  name               = "alb-primary"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_primary_sg.id]
  subnets            = [aws_subnet.subnet_ap_southeast_1_public.id, aws_subnet.subnet_ap_southeast_1_private.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg_primary" {
  name     = "tg-primary"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_ap_southeast_1.id
}

# uncomment when migrate
resource "aws_lb_target_group_attachment" "tga_primary" {
  target_group_arn = aws_lb_target_group.tg_primary.arn
  target_id        = aws_instance.private_primary_web.id
  port             = 80
}

resource "aws_lb_listener" "listener_primary" {
  load_balancer_arn = aws_lb.alb_primary.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_primary.arn
  }
}


# Divider Region


resource "aws_lb" "alb_secondary" {
  provider           = aws.ap_southeast_3
  name               = "alb-secondary"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_secondary_sg.id]
  subnets            = [aws_subnet.subnet_ap_southeast_3_public.id, aws_subnet.subnet_ap_southeast_3_private.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg_secondary" {
  provider = aws.ap_southeast_3
  name     = "tg-secondary"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_ap_southeast_3.id
}

resource "aws_lb_target_group_attachment" "tga_secondary" {
  provider         = aws.ap_southeast_3
  target_group_arn = aws_lb_target_group.tg_secondary.arn
  target_id        = aws_instance.private_secondary_web.id
  port             = 80
}

resource "aws_lb_listener" "listener_secondary" {
  provider          = aws.ap_southeast_3
  load_balancer_arn = aws_lb.alb_secondary.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_secondary.arn
  }
}