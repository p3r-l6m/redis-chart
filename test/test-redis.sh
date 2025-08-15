#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if namespace is provided
if [ -z "$1" ]; then
    error "Please provide namespace as first argument"
fi

NAMESPACE=$1
TEST_POD_NAME="redis-test"
SERVICE_NAME="redis-cb-pm-cb-redis"

log "Creating test pod in namespace ${NAMESPACE}..."
kubectl apply -f redis-test-pod.yaml -n ${NAMESPACE} || error "Failed to create test pod"

log "Waiting for test pod to be ready..."
kubectl wait --for=condition=ready pod/${TEST_POD_NAME} -n ${NAMESPACE} --timeout=60s || error "Test pod failed to become ready"

# Get the Redis password from the secret
REDIS_PASSWORD=$(kubectl get secret redis-cb-pm-cb-redis -n ${NAMESPACE} -o jsonpath="{.data.redis-password}" | base64 --decode)

log "Testing write to master..."
kubectl exec -n ${NAMESPACE} ${TEST_POD_NAME} -- /bin/sh -c \
    "redis-cli -h ${SERVICE_NAME}-master -a ${REDIS_PASSWORD} SET test_key 'Hello from test script'" || error "Failed to write to master"

log "Waiting for replication (5s)..."
sleep 5

log "Testing read from replica..."
kubectl exec -n ${NAMESPACE} ${TEST_POD_NAME} -- /bin/sh -c \
    "redis-cli -h ${SERVICE_NAME}-replica -a ${REDIS_PASSWORD} GET test_key" || error "Failed to read from replica"

log "Cleaning up..."
kubectl delete pod ${TEST_POD_NAME} -n ${NAMESPACE}

log "All tests completed successfully! 🎉"