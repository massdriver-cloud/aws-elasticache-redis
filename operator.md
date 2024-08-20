## AWS ElastiCache Redis

Amazon ElastiCache for Redis is a fast, in-memory caching service that provides a high-performance storage layer for your applications. This service seamlessly integrates with various AWS services, offering the speed of advanced in-memory caching, and providing features such as replication, clustering, and failover to ensure high availability and data protection.

### Design Decisions

1. **Subnet Configuration**: The ElastiCache instance can be deployed in either internal or private subnets for enhanced security.
2. **Security**: 
    - **At-Rest and In-Transit Encryption**: Options to enable at-rest and in-transit encryption to ensure data security.
    - **Security Group Rules**: Ingress rules to allow connections from specified CIDR blocks.
3. **Automatic Failover and Multi-AZ**: 
    - Enabled to ensure high availability and resilience.
    - Configurable based on cluster mode and the number of replicas.
4. **Snapshot Configuration**:
    - Configured to retain snapshots for 7 days.
    - Automatic snapshots are scheduled between 07:00-08:00.
5. **Parameter Groups**: Use of parameter groups mapped to Redis version for customized configuration.
6. **CloudWatch Alarms**: Set up for monitoring CPU Utilization, Engine CPU Utilization, and Memory Usage.

### Runbook

#### Checking Cluster Status

If your ElastiCache cluster is not responding, you might want to check its status:

```sh
aws elasticache describe-replication-groups --replication-group-id <your_cluster_id>
```

Look for the status in the output — it should be `available` when the cluster is properly running.

#### High CPU Usage

High CPU usage could indicate that your Redis instance needs scaling or optimization.

Check current CPU utilization metrics via CloudWatch:

```sh
aws cloudwatch get-metric-statistics \
    --namespace AWS/ElastiCache \
    --metric-name CPUUtilization \
    --dimensions Name=CacheClusterId,Value=<your_cache_cluster_id> \
    --start-time 2023-01-10T00:00:00Z \
    --end-time 2023-01-10T23:59:59Z \
    --period 300 \
    --statistics Average
```

#### High Memory Usage

High memory usage might require a cluster size increase or eviction policy adjustment.

Check memory usage metrics via CloudWatch:

```sh
aws cloudwatch get-metric-statistics \
    --namespace AWS/ElastiCache \
    --metric-name DatabaseMemoryUsagePercentage \
    --dimensions Name=CacheClusterId,Value=<your_cache_cluster_id> \
    --start-time 2023-01-10T00:00:00Z \
    --end-time 2023-01-10T23:59:59Z \
    --period 300 \
    --statistics Average
```

#### Redis Command Latency

Latency in command processing might indicate network issues or require scaling.

Use the `redis-cli` to check for latency issues:

```sh
redis-cli -h <your_redis_endpoint> -a <your_auth_token> --latency
```

#### Connectivity Issues

If clients cannot connect to the Redis instance, check the following:

1. **Security Group Rules**: Ensure that the security group assigned to the ElastiCache instance allows inbound traffic from clients.
2. **Subnet Configuration**: Confirm that the instance is in the proper subnet with routing configurations.

Check security group rules:

```sh
aws ec2 describe-security-groups --group-ids <your_security_group_id>
```

Verify the rules to ensure they match the source and destination CIDRs properly.

These tools and commands should help keep your AWS ElastiCache Redis instances running smoothly and assist in troubleshooting common problems.

