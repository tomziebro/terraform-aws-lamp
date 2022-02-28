#Create SSH Keys
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "ec2-key-pair"      
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/ec2-key-pair.pem; chmod 400 ~/ec2-key-pair.pem"
  }
}

#Create cloud-init for LAMP EC2 Instance
data "template_file" "user_data" {
  template = file("./scripts/cloudinit-setup.yml")
}

#Create the LAMP EC2 instance
resource "aws_instance" "lamp_webserver_instance" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = "ec2-key-pair"
  vpc_security_group_ids      = ["${aws_security_group.webserver_security_group.id}"]
  subnet_id                   = aws_subnet.lampvpc_public_subnet.id
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = "lamp_webserver_instance"
  }

  volume_tags = {
    Name = "lamp_webserver_instance_volume"
  }
}

#Create the AWS RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = ["${aws_subnet.lampvpc_private_subnet.id}", "${aws_subnet.lampvpc_private_subnet1.id}"]

  tags = {
    Name = "db_subnet_group"
  }
}

#Create the AWS Mysql RDS Instance
resource "aws_db_instance" "db_instance" {
  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  port                   = 3306
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  db_name                = "mydb"
  identifier             = "mysqldb"
  username               = "badcodepractice"
  password               = "reallybadcodepractice"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true

  tags = {
    Name = "db_instance"
  }
}

#Output the Webserver IP Address
output "webserver_server_address" {
  value = aws_instance.lamp_webserver_instance.public_dns
}
