resource "aws_security_group" "wp-rds" {
  name   = "wp_sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    from_port  = 22
    to_port     = 22
    protocol = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    from_port  = 3306
    to_port     = 3306
    protocol = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_for_wordpress"
  }
}


resource "aws_instance" "ec2" {
    ami = "ami-04db49c0fb2215364"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.wp-rds.id]
    key_name = "awsclass"
    tags = {
        Name = "wordpress"
    }



    connection {
            type     = "ssh"
            user     = "ec2-user"
            private_key = file("C:/Users/ANUJA KUMARI/Downloads/awsclass.pem")
            host     = aws_instance.ec2.public_ip
  }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install mysql -y",
            "sudo amazon-linux-extras install php7.2 -y",
            "sudo yum install httpd -y",
            "sudo wget https://wordpress.org/latest.tar.gz",
            "sudo tar -xvzf latest.tar.gz",
            "sudo cp -r wordpress/*  /var/www/html",
            "sudo chown -R apache:apache /var/www/html",
            "sudo systemctl enable httpd --now"
        ]
  }
}


output "wp_public_ip" {
    value = aws_instance.ec2.public_ip
}

