# Redis Helm Chart

This Helm chart deploys Redis in a master-replica configuration on a Kubernetes cluster.

## Features

- Configurable master-replica architecture
- Persistent storage for data
- Password authentication
- Resource limits and requests

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure

## Installation

### Basic Installation

```bash
helm install my-redis ./pm-cb-redis
```

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                  | Description                                      | Default     |
|---------------------------|--------------------------------------------------|-------------|
| `image.repository`        | Redis image repository                          | `redis`     |
| `image.tag`              | Redis image tag                                 | `""`        |
| `image.pullPolicy`       | Image pull policy                               | `IfNotPresent` |
| `replicas`               | Number of replica nodes                         | `2`         |
| `persistence.enabled`    | Enable persistence using PVC                    | `true`      |
| `persistence.storageClass` | PVC Storage Class                             | `""`        |
| `persistence.size`       | PVC Storage Request                            | `8Gi`       |
| `resources.master.requests.cpu` | CPU request for master                   | `200m`      |
| `resources.master.requests.memory` | Memory request for master             | `256Mi`     |
| `resources.master.limits.cpu` | CPU limit for master                       | `1000m`     |
| `resources.master.limits.memory` | Memory limit for master                 | `1Gi`       |
| `resources.replica.requests.cpu` | CPU request for replicas                | `100m`      |
| `resources.replica.requests.memory` | Memory request for replicas          | `128Mi`     |
| `resources.replica.limits.cpu` | CPU limit for replicas                    | `500m`      |
| `resources.replica.limits.memory` | Memory limit for replicas              | `512Mi`     |
| `security.password`      | Redis/Valkey password                          | `""`        |
| `security.useRandomPassword` | Generate random password if not set         | `true`      |

## Examples

### Setting Custom Resources

```bash
helm install my-redis ./pm-cb-redis \
  --set resources.master.requests.memory=512Mi \
  --set resources.master.limits.memory=2Gi
```

### Setting a Specific Password

```bash
helm install my-redis ./pm-cb-redis \
  --set security.password=my-password \
  --set security.useRandomPassword=false
```

### Customizing Replica Count

```bash
helm install my-redis ./pm-cb-redis \
  --set replicas=3
```

### Using Custom Storage Class

```bash
helm install my-redis ./pm-cb-redis \
  --set persistence.storageClass=my-storage-class
```

## Accessing the Redis Instance

After deployment, the following services will be created:

- `<release-name>-pm-cb-redis-master`: Points to the master instance
- `<release-name>-pm-cb-redis-replica`: Load balancer for the replica instances
- `<release-name>-pm-cb-redis-headless`: Headless service for StatefulSet

### Getting the Password

If using auto-generated password:
```bash
kubectl get secret my-redis-pm-cb-redis -o jsonpath="{.data.redis-password}" | base64 --decode
```

## Uninstallation

To uninstall/delete the deployment:

```bash
helm uninstall my-redis
```

## Notes

- The chart uses StatefulSets with persistent storage by default
- Password authentication is enabled by default
- Default port: 6379
- Service type is fixed as ClusterIP