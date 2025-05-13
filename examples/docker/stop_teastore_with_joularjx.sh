#!/bin/bash

# Stop and remove all teastore containers
containers=(
  teastore-auth
  teastore-image
  teastore-persistence
  teastore-recommender
  teastore-webui
  teastore-db
  teastore-registry
)

for container in "${containers[@]}"; do
  echo "Stopping and removing $container..."
  docker stop "$container" >/dev/null 2>&1 && echo "$container stopped." || echo "$container was not running."
  docker rm "$container" >/dev/null 2>&1 && echo "$container removed." || echo "$container was already removed or not found."
done
