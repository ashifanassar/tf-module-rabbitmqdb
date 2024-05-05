# Request a spot instance at $0.03
resource "aws_spot_instance_request" "rabbitmqdb" {
  ami                       = data.aws_ami.ami.id
  instance_type             = var.RABBITMQ_INSTANCE_TYPE
  subnet_id                 = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]
  vpc_security_group_ids    = [aws_security_group.allow_rabbitmqdb.id]
  wait_for_fulfillment      = true 

  tags = {
    Name = "roboshop-${var.ENV}-rabbitmqdb"
  }
}

resource "null_resource" "install" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = aws_spot_instance_request.rabbitmqdb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/b57-clouddevops/ansible.git -e ENV=dev -e COMPONENT=rabbitmqdb roboshop-pull.yml"
    ]
  }
}















# Provisions MySQL RDS Instance 
# resource "aws_db_instance" "mysql" {
#   allocated_storage        = 10
#   identifier               = "roboshop-${var.ENV}-mysql"
#   engine                   = "mysql"
#   engine_version           = "5.7"
#   instance_class           = "db.t3.micro"
#   username                 = "admin1"
#   password                 = "RoboShop1"
#   parameter_group_name     = aws_db_parameter_group.mysql.name 
#   skip_final_snapshot      = true 
#   db_subnet_group_name     = aws_db_subnet_group.mysql.name 
#   vpc_security_group_ids   = [aws_security_group.allow_mysql.id]
# }

# # Provisons Parameter Groups for RDS
# resource "aws_db_parameter_group" "mysql" {
#   name                = "rds-pg"
#   family              = "mysql5.7"
# }

# # Provisions Subnet Group
# resource "aws_db_subnet_group" "mysql" {
#   name                = "roboshop-${var.ENV}-mysql"
#   subnet_ids          = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

#   tags = {
#     Name = "roboshop-${var.ENV}-mysql"
#   }
# }