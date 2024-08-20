## AWS ElastiCache for Redis

Amazon ElastiCache for Redis is a managed in-memory caching service that supports scalable, highly available deployments of the Redis data store. It provides a seamless, secure, and cost-effective caching solution to help speed up application performance.

### Design Decisions

1. **Replication and High Availability**: 
   This setup includes automatic failover and multi-AZ enabled, ensuring that your application remains highly available and data is replicated for redundancy.

2. **Security**:
   - Uses at-rest encryption and supports transit encryption when `secure` is set to true.
   - A security group is created to manage inbound traffic, restricted based on VPC CIDR blocks.

3. **Snapshots**:
   Regular snapshots are configured with a retention limit of 7 days, ensuring that you can restore your data to any point within the past week.

4. **Parameter Group**:
   The correct parameter group is assigned based on the Redis version chosen. For clustered instances, appropriate parameter settings are applied.

5. **Alarms and Monitoring**:
   CloudWatch alarms are set up for monitoring CPU utilization, engine CPU utilization, and memory usage, sending notifications for high utilization thresholds, thus ensuring timely intervention.

### Runbook

#### Connectivity Issues

If you have trouble connecting to your Redis cluster, validate connectivity and security settings.

Check the security group settings to ensure the port `6379` is open:

```sh
aws ec2 describe-security-groups --group-ids <security-group-id>
```

Ensure the VPC subnet configuration:

```sh
aws ec2 describe-subnets --subnet-ids <subnet-id>
```

Attempt to connect to the Redis instance with `redis-cli`:

```sh
redis-cli -h <redis-endpoint> -p 6379
```

Expected output should be a successful connection message. If not, investigate network, VPC, and endpoint configurations.

#### High CPU Utilization

If your Redis cluster shows high CPU utilization, check the CloudWatch metrics and logs:

View CPU utilization metrics:

```sh
aws cloudwatch get-metric-statistics --namespace AWS/ElastiCache --metric-name CPUUtilization --dimensions Name=CacheClusterId,Value=<cluster-id> --start-time <start-time> --end-time <end-time> --period 300 --statistics Average
```

Examine Redis performance using the `INFO` command:

```sh
redis-cli -h <redis-endpoint> -p 6379 INFO CPU
```

Identify high `user` or `system` CPU times. Additionally, review the overall performance and memory allocation using:

```sh
redis-cli -h <redis-endpoint> -p 6379 INFO MEMORY
```

#### Memory Usage Issues

For issues related to high memory usage, the following commands can help diagnose and understand memory allocations and possible evictions.

Check memory usage metrics:

```sh
aws cloudwatch get-metric-statistics --namespace AWS/ElastiCache --metric-name DatabaseMemoryUsagePercentage --dimensions Name=CacheClusterId,Value=<cluster-id> --start-time <start-time> --end-time <end-time> --period 300 --statistics Average
```

Investigate Redis memory statistics:

```sh
redis-cli -h <redis-endpoint> -p 6379 INFO MEMORY
```

Look for high `used_memory` and review memory fragmentation. Additionally, check keyspace information to identify large or abundant keys:

```sh
redis-cli -h <redis-endpoint> -p 6379 INFO keyspace
```

#### Authentication Issues

If authentication issues occur, especially when `secure` is enabled with a password, verify the correct token is being used.

Test connection with the authentication token:

```sh
redis-cli -h <redis-endpoint> -p 6379 -a <auth-token>
```

Ensure the Redis instance has the correct `requirepass` configuration set by viewing the current configuration:

```sh
redis-cli -h <redis-endpoint> -p 6379 config get requirepass
```

Confirm the password matches your setup and is being used consistently across your application and instances.

