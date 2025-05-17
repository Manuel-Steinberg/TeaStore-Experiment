# TeaStore Local Tomcat Deployment with JoularJX

This guide documents how to start TeaStore using Docker Compose, extract the configured Tomcat instances, and run each service locally with JoularJX instrumentation.

## 🚀 Step 1: Start all services via `docker compose` (since everything is already configured properly)

From the **root of the TeaStore repository**, run:

```bash
docker compose -p teastore-tomcat -f ./examples/docker/docker-compose_default.yaml up -d
```

## 📦 Step 2: Extract pre-configured tomcat directories

Run the following commands to copy the internal `/usr/local/tomcat` folder to your local machine.

> [!IMPORTANT]  
> Those commands need to be execuited with a privileged user to work!

```bash
docker cp teastore-tomcat-registry-1:/usr/local/tomcat ./tomcat-registry
docker cp teastore-tomcat-persistence-1:/usr/local/tomcat ./tomcat-persistence
docker cp teastore-tomcat-auth-1:/usr/local/tomcat ./tomcat-auth
docker cp teastore-tomcat-recommender-1:/usr/local/tomcat ./tomcat-recommender
docker cp teastore-tomcat-image-1:/usr/local/tomcat ./tomcat-image
docker cp teastore-tomcat-webui-1:/usr/local/tomcat ./tomcat-webui
```

> [!NOTE]  
> The container `teastore-tomcat-db-1` is skipped on purpose since it is only database service.

## ⚰️ Step 3: Shut Down All Docker Services Except DB

Stop all running TeaStore containers except for the MySQL database container:

```bash
docker stop teastore-tomcat-registry-1
docker stop teastore-tomcat-persistence-1
docker stop teastore-tomcat-auth-1
docker stop teastore-tomcat-recommender-1
docker stop teastore-tomcat-image-1
docker stop teastore-tomcat-webui-1
```


