resource "aws_kms_key" "cmk" {
  description = "KMS Customer Master Key"
}

resource "aws_kms_alias" "alias" {
  name          = "alias/key_kafka"
  target_key_id = aws_kms_key.cmk.key_id
}

resource "aws_msk_scram_secret_association" "scram" {
  cluster_arn     = aws_msk_cluster.kafka.arn
  secret_arn_list = [aws_secretsmanager_secret.secret_manager.arn]

  depends_on = [aws_secretsmanager_secret_version.secret_version]

}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = "kafka"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2
  
  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    ebs_volume_size = 5
    client_subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
    ]
    security_groups = [aws_security_group.sg_msk_cluster.id]
   
  #  configuration_info {
  #     public_access {
  #       type = SERVICE_PROVIDED_EIPS
  #   }
  # }

  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.cmk.arn
  }

  client_authentication {
    sasl {
      scram = true
    }
  }

}

resource "aws_secretsmanager_secret" "secret_manager" {
  name       = "AmazonMSK_kafka"
  kms_key_id = aws_kms_key.cmk.key_id
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret_manager.id
  secret_string = jsonencode({ username = "user", password = "pass" })
}

resource "aws_secretsmanager_secret_policy" "secret_policy" {
  secret_arn = aws_secretsmanager_secret.secret_manager.arn
  policy     = <<POLICY
  {
    "Version" : "2012-10-17",
    "Statement" : [ {
      "Sid": "AWSKafkaResourcePolicy",
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "kafka.amazonaws.com"
      },
      "Action" : "secretsmanager:getSecretValue",
      "Resource" : "${aws_secretsmanager_secret.secret_manager.arn}"
    } ]
  }
  POLICY
}







