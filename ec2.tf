resource "aws_instance" "public_primary_web" {
  ami                    = var.image_ap_southeast_1
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_ap_southeast_1_public.id
  vpc_security_group_ids = ["${aws_security_group.public_primary_sg.id}"]

  tags = {
    Name = "Public Primary Web"
  }
}

resource "aws_eip" "public_primary_ip" {
  instance = aws_instance.public_primary_web.id
  domain   = "vpc"
}

resource "aws_instance" "private_primary_web" {
  ami                    = var.image_ap_southeast_1
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_ap_southeast_1_private.id
  vpc_security_group_ids = ["${aws_security_group.private_primary_sg.id}"]
  key_name               = aws_key_pair.deployer.id

  # user_data                   = file("script.sh")
  # user_data_replace_on_change = true

  depends_on = [aws_nat_gateway.nat_ap_southeast_1]

  tags = {
    Name = "Private Primary Web"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("deployer-key.pub")
}


# Divider Region


resource "aws_instance" "public_secondary_web" {
  provider               = aws.ap_southeast_3
  ami                    = var.image_ap_southeast_3
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_ap_southeast_3_public.id
  vpc_security_group_ids = ["${aws_security_group.public_secondary_sg.id}"]

  tags = {
    Name = "Public Secondary Web"
  }
}

resource "aws_eip" "public_secondary_ip" {
  provider = aws.ap_southeast_3
  instance = aws_instance.public_secondary_web.id
  domain   = "vpc"
}

resource "aws_instance" "private_secondary_web" {
  provider               = aws.ap_southeast_3
  ami                    = var.image_ap_southeast_3
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_ap_southeast_3_private.id
  vpc_security_group_ids = ["${aws_security_group.private_secondary_sg.id}"]
  key_name               = aws_key_pair.deployer_secondary.id

  user_data                   = file("script.sh")
  user_data_replace_on_change = true

  depends_on = [aws_nat_gateway.nat_ap_southeast_3]

  tags = {
    Name = "Private Secondary Web"
  }
}

resource "aws_key_pair" "deployer_secondary" {
  provider   = aws.ap_southeast_3
  key_name   = "deployer-key"
  public_key = file("deployer-key.pub")
}