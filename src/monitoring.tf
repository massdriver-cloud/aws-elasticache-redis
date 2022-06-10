# Useful guide: https://aws.amazon.com/blogs/database/monitoring-best-practices-with-amazon-elasticache-for-redis-using-amazon-cloudwatch/

locals {
  member_clusters_count = var.cluster_mode_enabled ? (var.node_groups * (var.replicas + 1)) : var.replicas + 1
  member_clusters_list  = tolist(aws_elasticache_replication_group.main.member_clusters)

  cpu_utilization_threshold        = "90"
  engine_cpu_utilization_threshold = "90"
  memory_usage_threshold           = "90"
}

module "engine_cpu_utilization_alarm" {
  source = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=b91993f"
  count  = local.member_clusters_count

  depends_on = [
    aws_elasticache_replication_group.main
  ]

  md_metadata         = var.md_metadata
  message             = "Elasticache Redis ${element(local.member_clusters_list, count.index)}: Redis Engine CPU Utilization > ${local.engine_cpu_utilization_threshold}"
  alarm_name          = "${element(local.member_clusters_list, count.index)}-highEngineCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = local.engine_cpu_utilization_threshold

  dimensions = {
    CacheClusterId = element(local.member_clusters_list, count.index)
  }
}

module "cpu_utilization_alarm" {
  source = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=3ec7921"
  count  = local.member_clusters_count

  depends_on = [
    aws_elasticache_replication_group.main
  ]

  md_metadata         = var.md_metadata
  message             = "Elasticache Redis ${element(local.member_clusters_list, count.index)}: Instance CPU Utilization > ${local.cpu_utilization_threshold}"
  alarm_name          = "${element(local.member_clusters_list, count.index)}-highCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = local.cpu_utilization_threshold

  dimensions = {
    CacheClusterId = element(local.member_clusters_list, count.index)
  }
}

module "memory_usage_alarm" {
  source = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=3ec7921"
  count  = local.member_clusters_count

  depends_on = [
    aws_elasticache_replication_group.main
  ]

  md_metadata         = var.md_metadata
  message             = "Elasticache Redis ${element(local.member_clusters_list, count.index)}: Memory Usage > ${local.memory_usage_threshold}"
  alarm_name          = "${element(local.member_clusters_list, count.index)}-highMemoryUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = local.memory_usage_threshold

  dimensions = {
    CacheClusterId = element(local.member_clusters_list, count.index)
  }
}
