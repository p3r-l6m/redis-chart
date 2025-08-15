# Redis Testing

This directory contains test manifests and scripts for validating the Redis deployment.

## Automated Test Script

The `test-redis.sh` script automates the deployment of a test pod and performs basic read/write tests:

```bash
# Make the script executable
chmod +x test-redis.sh

# Run the test script (provide namespace as argument)
./test-redis.sh my-namespace
```

The script will:
1. Deploy the test pod
2. Write a test value to the master
3. Read the value from a replica
4. Clean up the test pod

## Manual Testing with Redis Test Pod

The `redis-test-pod.yaml` creates a pod that can be used to test Redis master-replica functionality:

```bash
# Create the test pod
kubectl apply -f redis-test-pod.yaml -n <namespace>

# Get Redis password
REDIS_PASS=$(kubectl get secret <release-name>-pm-cb-redis -n <namespace> -o jsonpath="{.data.redis-password}" | base64 --decode)

# Test master write
kubectl exec -it redis-test -n <namespace> -- redis-cli -h <release-name>-pm-cb-redis-master -a $REDIS_PASS set testkey "test value"

# Test replica read
kubectl exec -it redis-test -n <namespace> -- redis-cli -h <release-name>-pm-cb-redis-replica -a $REDIS_PASS get testkey

# Check replication status
kubectl exec -it redis-test -n <namespace> -- redis-cli -h <release-name>-pm-cb-redis-master -a $REDIS_PASS info replication
```

The test pod is configured with proper security contexts and resource limits to comply with cluster security policies.