resource "aws_db_instance" "mysql" {
  identifier        = "${var.app_name}-${var.environment}-mysql"
  allocated_storage = var.allocated_storage
  engine            = "mysql"
  instance_class    = var.instance_class
  db_name           = "hospitaldb"
  username          = "admin"
  password          = random_password.db_password.result

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  multi_az                  = false
  storage_encrypted         = true
  skip_final_snapshot       = var.environment == "dev" ? true : false
  final_snapshot_identifier = var.environment == "prod" ? "${var.app_name}-${var.environment}-final-snapshot" : null

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name = "${var.app_name}-mysql"
  }
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%^&*()-_=+[]{}:;,.?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.app_name}/${var.environment}/db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}
