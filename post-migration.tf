# # Create an AMI that will start a machine whose root device is backed by
# # an EBS volume populated from a snapshot. We assume that such a snapshot
# # already exists with the id "snap-xxxxxxxx".
# resource "aws_ami" "terraform_ami_migration" {
#   name                = "terraform-ami-migration"
#   virtualization_type = "hvm"
#   root_device_name    = "/dev/sda1"
#   ena_support = true
#   imds_support        = "v2.0" # Enforce usage of IMDSv2. You can safely remove this line if your application explicitly doesn't support it.
#   ebs_block_device {
#     device_name = "/dev/sda1"
#     snapshot_id = "snap-0976ff387433a8fd6" //TODO changeme with snapshot id
#     volume_size = 8
#   }
# }

# resource "aws_instance" "migration_web" {
#   ami                    = aws_ami.terraform_ami_migration.id
#   instance_type          = "t3.micro"
#   subnet_id              = aws_subnet.subnet_ap_southeast_1_private.id
#   vpc_security_group_ids = ["${aws_security_group.private_primary_sg.id}"]
#   key_name               = aws_key_pair.deployer.id

#   # user_data                   = file("script.sh")
#   # user_data_replace_on_change = true

#   depends_on = [aws_nat_gateway.nat_ap_southeast_1]

#   tags = {
#     Name = "Migration Web"
#   }
# }

# resource "aws_lb_target_group_attachment" "tga_primary" {
#   target_group_arn = aws_lb_target_group.tg_primary.arn
#   target_id        = aws_instance.migration_web.id
#   port             = 80
# }