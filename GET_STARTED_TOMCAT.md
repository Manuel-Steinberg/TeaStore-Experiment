# TeaStore Local Tomcat Deployment with JoularJX

This guide documents how to start TeaStore using Docker Compose, extract the configured Tomcat instances, and run each service locally with JoularJX instrumentation.

## 🚀 Step 1: Start all services via `docker compose` (since everything is already configured properly)

From the **root of the TeaStore repository**, run:

```bash
docker compose -p teastore-tomcat -f ./examples/docker/docker-compose_default.yaml up -d
```

## 📦 Step 2: Extract pre-configured Tomcat directories

Run the following commands to copy the internal `/usr/local/tomcat` folder to your local machine.

> [!IMPORTANT]  
> These commands need to be executed with a privileged user to work!

```bash
docker cp teastore-tomcat-registry-1:/usr/local/tomcat ./tomcat-registry
docker cp teastore-tomcat-persistence-1:/usr/local/tomcat ./tomcat-persistence
docker cp teastore-tomcat-auth-1:/usr/local/tomcat ./tomcat-auth
docker cp teastore-tomcat-recommender-1:/usr/local/tomcat ./tomcat-recommender
docker cp teastore-tomcat-image-1:/usr/local/tomcat ./tomcat-image
docker cp teastore-tomcat-webui-1:/usr/local/tomcat ./tomcat-webui
```

> [!NOTE]  
> The container `teastore-tomcat-db-1` is skipped on purpose since it is only the database service. Default user and password for the DB: **teauser:teapassword**

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

## 🛠️ Step 4: Configure local Tomcats

All configurations are placed inside each `conf/server.xml` and `conf/context.xml`.

Example/Excerpt:

```xml
<Environment name="useHostIP" value="true"
  		type="java.lang.String" override="false"/>
```

### 🔌 Port Configuration Overview

| Service       | HTTP Port | AJP Port | Shutdown Port |
|---------------|-----------|----------|----------------|
| Registry      | 8080      | 8100     | 8000           |
| Persistence   | 8081      | 8101     | 8001           |
| Auth          | 8082      | 8102     | 8002           |
| Recommender   | 8083      | 8103     | 8003           |
| Image         | 8084      | 8104     | 8004           |
| WebUI         | 8085      | 8105     | 8005           |


## Step 5: Start all tomcats (in order)

1. `./tomcat-registry/bin/startup`
2. `./tomcat-persistence/bin/startup`
3. `./tomcat-auth/bin/startup`
4. `./tomcat-recommender/bin/startup`
5. `./tomcat-image/bin/startup`
6. `./tomcat-webui/bin/startup`

## Step 6: Open TeaStore

- Visit http://localhost:8085/tools.descartes.teastore.webui/

- Check status page on http://localhost:8085/tools.descartes.teastore.webui/status 



