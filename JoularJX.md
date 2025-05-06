# 🧪 TeaStore + JoularJX Energy Profiling Experiment

This setup instruments the [TeaStore microservices](https://github.com/DescartesResearch/TeaStore) with the [JoularJX](https://github.com/joular/joularjx) Java agent to measure energy consumption of each service individually.

## 📁 Folder Structure (Linux Server)

```
TeaStore/
├── docker-compose_default.yaml
├── docker-compose_joularjx.yaml
├── shared-libs/
│   └── joularjx.jar
├── joularjx-logs/
│   └── config.properties
```

## 📝 Prerequisites

- 🐧 Linux system with RAPL support
- Docker and Docker Compose installed

## ⚙️ Setup Steps

1. **Place JoularJX JAR file** in the _shared-libs_ folder

2. **Place `config.properties`** in the _joularjx-logs_ folder

   > Ensure `config.properties` contains:
   >
   > ```properties
   > save-runtime-data=true
   > overwrite-runtime-data=true
   > logger-level=INFO
   > ```

3. **Start the experiment setup:**

   ```bash
   docker compose -f docker-compose_default.yaml -f docker-compose_joularjx.yaml up --build
   ```

4. **Stop the experiment:**

   ```bash
   docker compose -f docker-compose_default.yaml -f docker-compose_joularjx.yaml down
   ```

## 📊 Retrieve Measurement Data

Output will be located in the `joularjx-logs/` folder:

- `auth.txt`, `image.txt`, etc.
- Runtime CSV files per service (if enabled)

## 📌 Notes

- On Windows, results won't be collected due to missing kernel/hardware support.
- `docker compose down` ensures a clean shutdown and agent data dump.