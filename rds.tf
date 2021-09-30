
resource "aws_db_instance" "wp_db_rds" {

    depends_on = [
        aws_instance.ec2
    ]

    identifier           = "wordpressdb"
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    vpc_security_group_ids = [aws_security_group.wp-rds.id]
    name                 = "db_for_wp"
    username             = var.db_username
    password             = var.db_pass
    skip_final_snapshot  = true

} 


output "Endpoint_string" {
  value = aws_db_instance.wp_db_rds.endpoint
}