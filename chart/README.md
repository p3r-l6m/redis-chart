# A Helm chart for Redis with master-replica configuration

A Helm chart for deploying Redis in a master-replica configuration. This chart sets up a Redis cluster with one master and configurable number of replicas, supporting persistence, password authentication, and resource management. Perfect for production deployments requiring high availability and data replication.

## Chart Installation

### Basic Installation
```bash
# Install from the chart directory
helm install my-redis ./chart --namespace <namespace> --create-namespace
```

### Installation with Custom Values
```bash
# Install with a custom password
helm install my-redis ./chart --namespace <namespace> --set security.password=mypassword

# Install with persistence enabled
helm install my-redis ./chart --namespace <namespace> --set persistence.enabled=true

# Install with custom resource limits
helm install my-redis ./chart --namespace <namespace> \
  --set resources.master.memory=2Gi \
  --set resources.master.cpu=2000m
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `redis` |
| `image.tag` | Image tag (automatically set) | `""` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicas` | Number of replica pods | `2` |
| `resources.master.requests.cpu` | Master pod CPU request | `200m` |
| `resources.master.requests.memory` | Master pod memory request | `256Mi` |
| `resources.master.limits.cpu` | Master pod CPU limit | `1000m` |
| `resources.master.limits.memory` | Master pod memory limit | `1Gi` |
| `resources.replica.requests.cpu` | Replica pod CPU request | `100m` |
| `resources.replica.requests.memory` | Replica pod memory request | `128Mi` |
| `resources.replica.limits.cpu` | Replica pod CPU limit | `500m` |
| `resources.replica.limits.memory` | Replica pod memory limit | `512Mi` |
| `persistence.enabled` | Enable persistent storage | `false` |
| `persistence.storageClass` | Storage class for PVCs | `""` |
| `persistence.size` | Size of persistent volume | `8Gi` |
| `security.password` | Redis password (if empty, random password is used) | `""` |
| `security.useRandomPassword` | Generate random Redis password | `true` |