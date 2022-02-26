#Create a Security Group for the Webserver
resource "aws_security_group" "webserver_security_group" {
  name        = "webserver_security_group"
  description = "Allow Incoming HTTP Connections"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  egress { #MySQLDB
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  vpc_id = aws_vpc.lampvpc.id

  tags = {
    Name = "webserver_security_group"
  }
}

#Create a Security Group for the RDS Instance
resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Allow Incoming MYSQLDB Connections"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.zero_addr_cidr}"]
  }

  vpc_id = aws_vpc.lampvpc.id

  tags = {
    Name = "db_security_group"
  }
}
