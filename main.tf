# Створення S3 бакета
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "mate-grafana-backups-760583" # Замініть цифри, якщо ім'я зайняте

  tags = {
    Name = "GrafanaBackupsBucket"
  }
}

# Генерація документа політики доступу згідно з вимогами
data "aws_iam_policy_document" "bucket_policy" {
  # Дозвіл на перегляд вмісту бакета
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]
  }

  # Дозвіл на читання та запис об'єктів у бакеті
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
    actions   = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]
  }
}

# Прикріплення створеної політики до бакета
resource "aws_s3_bucket_policy" "grafana_bucket_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}