// Auto-generated variable declarations from massdriver.yaml
variable "aws_authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
variable "cluster_mode_enabled" {
  type = bool
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "node_groups" {
  type    = number
  default = 2
}
variable "node_type" {
  type = string
}
variable "redis_version" {
  type = string
}
variable "replicas" {
  type = number
}
variable "secure" {
  type    = bool
  default = true
}
variable "subnet_type" {
  type    = string
  default = "internal"
}
variable "vpc" {
  type = object({
    data = object({
      infrastructure = object({
        arn  = string
        cidr = string
        internal_subnets = list(object({
          arn = string
        }))
        private_subnets = list(object({
          arn = string
        }))
        public_subnets = list(object({
          arn = string
        }))
      })
    })
    specs = optional(object({
      aws = optional(object({
        region = optional(string)
      }))
    }))
  })
}
