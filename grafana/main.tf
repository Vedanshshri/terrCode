resource "aws_grafana_workspace" "grafana_workspace" {
    name = var.grafana_name
    account_access_type      = "CURRENT_ACCOUNT"
    authentication_providers = ["SAML"]
    permission_type          = "SERVICE_MANAGED"
    role_arn                 = aws_iam_role.grafana_role.arn
    data_sources = var.data_sources
}

resource "aws_grafana_role_association" "grafana_role_admin" {
    role="ADMIN"
    user_ids=[var.admin_user_ids]
    workspace_id = aws_grafana_workspace.grafana_workspace.id  
}

resource "aws_grafana_role_association" "grafana_role_editor" {
    role="EDITOR"
    user_ids=[var.editor_user_ids]
    workspace_id = aws_grafana_workspace.grafana_workspace.id  
}
resource "aws_grafana_role_association" "grafana_role_viewer" {
    role="VIEWER"
    user_ids=[var.viewer_user_ids]
    workspace_id = aws_grafana_workspace.grafana_workspace.id  
}

resource "aws_iam_role" "grafana_role" {
  name = "grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "grafana_policy" {
    name= "grafana_policy"
    path="/"
    description = "Allow Grafana to Access CloudWatch Logs and Metrices"
    policy = jsondecode({
        "Version": "2012-10-17"
        "Statement": [
            {
                "Sid": "AllowReadingMetricesFromCloudWatch",
                "Effect": "Allow",
                "Action":[
                    "CloudWatch:DescribeAlarmsForMetric",
                    "CloudWatch:DescribeAlarmsHistory",
                    "CloudWatch:DescribeAlarms",
                    "CloudWatch:ListMetrics",
                    "CloudWatch:GetMetricStatistics",
                    "CloudWatch:GetMetricData",
                    "CloudWatch:GetInsightRuleReport",
                ],
                "Resource": "*"
            },
            {
                "Sid": "AllowReadingLogsFromCloudWatch",
                "Effect": "Allow",
                "Action":[
                    "logs:DescribeLogGroups",
                    "logs:GetLogGroupFields",
                    "logs:StartQuery",
                    "logs:StopQuery",
                    "logs:GetQueryResults",
                    "logs:GetLogEvents",
                ],
                "Resource": "*" 
            }
        ]
    })
  
}

resource "aws_iam_policy_attachment" "grafana_policy_attachment" {
  name= "cloudwatch_policy_attachment"
  roles = [aws_iam_role.grafana_role.name]
  policy_arn = aws_iam_policy.grafana_policy.arn
}