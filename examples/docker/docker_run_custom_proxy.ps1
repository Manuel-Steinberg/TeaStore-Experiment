# Step 1: Create network if not exists
docker network ls | Select-String "teastore-net" > $null
if ($LASTEXITCODE -ne 0) {
    docker network create teastore-net
}

# Step 2: Stop and remove any old containers
$containers = @(
    "teastore-webui", "teastore-image", "teastore-recommender",
    "teastore-auth", "teastore-persistence", "teastore-db", "teastore-registry"
)
foreach ($c in $containers) {
    docker stop $c -ErrorAction SilentlyContinue
    docker rm $c -ErrorAction SilentlyContinue
}

# Step 3: Start containers

docker run -d --name teastore-registry `
  --network teastore-net `
  -e HOST_NAME=teastore-registry `
  -e SERVICE_PORT=8080 `
  -p 10000:8080 `
  descartesresearch/teastore-registry

docker run -d --name teastore-db `
  --network teastore-net `
  -p 3306:3306 `
  descartesresearch/teastore-db

docker run -d --name teastore-persistence `
  --network teastore-net `
  -e REGISTRY_HOST=teastore-registry `
  -e REGISTRY_PORT=8080 `
  -e HOST_NAME=teastore-persistence `
  -e SERVICE_PORT=8080 `
  -e DB_HOST=teastore-db `
  -e DB_PORT=3306 `
  -p 1111:8080 `
  descartesresearch/teastore-persistence

docker run -d --name teastore-auth `
  --network teastore-net `
  -e REGISTRY_HOST=teastore-registry `
  -e REGISTRY_PORT=8080 `
  -e HOST_NAME=teastore-auth `
  -e SERVICE_PORT=8080 `
  -p 2222:8080 `
  descartesresearch/teastore-auth

docker run -d --name teastore-recommender `
  --network teastore-net `
  -e REGISTRY_HOST=teastore-registry `
  -e REGISTRY_PORT=8080 `
  -e HOST_NAME=teastore-recommender `
  -e SERVICE_PORT=8080 `
  -p 3333:8080 `
  descartesresearch/teastore-recommender

docker run -d --name teastore-image `
  --network teastore-net `
  -e REGISTRY_HOST=teastore-registry `
  -e REGISTRY_PORT=8080 `
  -e HOST_NAME=teastore-image `
  -e SERVICE_PORT=8080 `
  -p 4444:8080 `
  descartesresearch/teastore-image

docker run -d --name teastore-webui `
  --network teastore-net `
  -e REGISTRY_HOST=teastore-registry `
  -e REGISTRY_PORT=8080 `
  -e HOST_NAME=teastore-webui `
  -e SERVICE_PORT=8080 `
  -e PROXY_NAME=teastore-webui `
  -e PROXY_PORT=8080 `
  -p 8080:8080 `
  descartesresearch/teastore-webui
