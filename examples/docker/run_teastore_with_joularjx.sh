#!/bin/bash

# === CONFIG ===
JAR_PATH="$(pwd)/joularjx.jar"
LOG_DIR="$(pwd)/joularjx-logs"
NETWORK_NAME="teastore-net"

mkdir -p "$LOG_DIR"

# === CLEANUP ===
echo "Cleaning up previous containers..."
docker rm -f teastore-registry teastore-db \
  teastore-persistence teastore-auth \
  teastore-recommender teastore-image teastore-webui 2>/dev/null

docker network rm $NETWORK_NAME 2>/dev/null
docker network create $NETWORK_NAME

# === Start REGISTRY ===
docker run -d --rm \
  --name teastore-registry \
  --network $NETWORK_NAME \
  -e "HOST_NAME=teastore-registry" \
  -e "SERVICE_PORT=8080" \
  -p 10000:8080 \
  descartesresearch/teastore-registry

# === Start DATABASE ===
docker run -d --rm \
  --name teastore-db \
  --network $NETWORK_NAME \
  -p 3306:3306 \
  descartesresearch/teastore-db

# === JoularJX JVM Options ===
get_java_opts() {
  local name=$1
  echo "-javaagent:/agent/joularjx.jar -Djoularjx.dumpOnExit=true -Djoularjx.logger-level=INFO -Djoularjx.dumpFile=/agent/logs/${name}.txt"
}

# === Start TeaStore Service ===
run_service() {
  local name=$1
  local port=$2
  local extra_env=$3
  local java_opts
  java_opts=$(get_java_opts "$name")

  docker run -d --rm \
    --name "teastore-${name}" \
    --network $NETWORK_NAME \
    -e "REGISTRY_HOST=teastore-registry" \
    -e "REGISTRY_PORT=8080" \
    -e "HOST_NAME=teastore-${name}" \
    -e "SERVICE_PORT=${port}" \
    -e "JAVA_OPTS=${java_opts}" \
    ${extra_env} \
    -v "$JAR_PATH:/agent/joularjx.jar" \
    -v "$LOG_DIR:/agent/logs" \
    -p "$port:8080" \
    descartesresearch/teastore-${name}
}

# === Launch Backend Services ===
run_service persistence 1111 "-e DB_HOST=teastore-db -e DB_PORT=3306"
sleep 3

run_service auth        2222
sleep 3

run_service recommender 3333
sleep 3

run_service image       4444
sleep 3

echo "⏳ Waiting for services to register before starting WebUI..."
sleep 10

run_service webui       8080

# === Final Output ===
echo
echo "✅ TeaStore with JoularJX started successfully."
echo "→ WebUI: http://localhost:8080/tools.descartes.teastore.webui/"
