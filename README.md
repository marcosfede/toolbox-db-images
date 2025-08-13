# MCP Database Server Docker Images

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Docker images that provide database connectivity through the **Model Context Protocol (MCP)**. These images enable AI agents and applications to connect to database systems with minimal configuration.

## ✨ Features

- 🚀 **Ready-to-Use**: Pre-built Docker images for each database type
- 🔗 **Universal Interface**: Consistent API across all database types
- 🔐 **Secure**: Environment-based credential management
- 📊 **Extensive Database Support**: 20+ database systems supported
- 🐳 **Container Native**: Optimized for containerized environments

## 🐳 About These Images

All database images use the official Google Database Toolbox as the base:

```bash
us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest
```

Each database configuration runs this image with the `--prebuilt` flag and the appropriate source type to automatically load the necessary tools. For MCP mode, the `--stdio` flag is also required.

## 📋 Supported Databases

| Database | Type | Description |
|----------|------|-------------|
| [AlloyDB for PostgreSQL](#alloydb-for-postgresql) | SQL | Fully-managed PostgreSQL-compatible database |
| [BigQuery](#bigquery) | Analytics | Petabyte-scale analytics data warehouse |
| [Bigtable](#bigtable) | NoSQL | Low-latency wide-column store |
| [Cloud SQL for MySQL](#cloud-sql-for-mysql) | SQL | Fully-managed MySQL database service |
| [Cloud SQL for PostgreSQL](#cloud-sql-for-postgresql) | SQL | Fully-managed PostgreSQL database service |
| [Cloud SQL for SQL Server](#cloud-sql-for-sql-server) | SQL | Fully-managed SQL Server database service |
| [Couchbase](#couchbase) | NoSQL | Distributed document database |
| [Dataplex](#dataplex) | Catalog | Unified data governance solution |
| [Dgraph](#dgraph) | Graph | Distributed graph database |
| [Firestore](#firestore) | NoSQL | Serverless document database |
| [Looker](#looker) | BI | Business intelligence platform |
| [MongoDB](#mongodb) | NoSQL | Document-oriented database |
| [MySQL](#mysql) | SQL | Open-source relational database |
| [Neo4j](#neo4j) | Graph | Graph database management system |
| [PostgreSQL](#postgresql) | SQL | Open-source object-relational database |
| [Redis](#redis) | Cache/NoSQL | In-memory data structure store |
| [Redshift](#redshift) | Analytics | Amazon's data warehouse service |
| [Spanner](#spanner) | SQL | Globally distributed relational database |
| [SQL Server](#sql-server) | SQL | Microsoft relational database |
| [SQLite](#sqlite) | SQL | Lightweight file-based database |
| [TiDB](#tidb) | SQL | Distributed SQL database |
| [Valkey](#valkey) | Cache/NoSQL | Open-source Redis fork |

## 🗄️ Database Configurations

---

## AlloyDB for PostgreSQL

AlloyDB for PostgreSQL is a fully-managed, PostgreSQL-compatible database for demanding transactional workloads.

### Docker Command

```bash
ALLOYDB_PROJECT=my-project \
ALLOYDB_REGION=us-central1 \
ALLOYDB_CLUSTER=my-cluster \
ALLOYDB_INSTANCE=my-instance \
ALLOYDB_DATABASE=mydb \
ALLOYDB_USER=postgres \
ALLOYDB_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-alloydb \
  -p 3000:3000 \
  -e ALLOYDB_PROJECT \
  -e ALLOYDB_REGION \
  -e ALLOYDB_CLUSTER \
  -e ALLOYDB_INSTANCE \
  -e ALLOYDB_DATABASE \
  -e ALLOYDB_USER \
  -e ALLOYDB_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt alloydb
```

### MCP Client Configuration

```json
"alloydb": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "ALLOYDB_PROJECT",
    "-e", "ALLOYDB_REGION", 
    "-e", "ALLOYDB_CLUSTER",
    "-e", "ALLOYDB_INSTANCE",
    "-e", "ALLOYDB_DATABASE",
    "-e", "ALLOYDB_USER",
    "-e", "ALLOYDB_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "alloydb",
    "--stdio"
  ],
  "env": {
    "ALLOYDB_PROJECT": "my-project",
    "ALLOYDB_REGION": "us-central1",
    "ALLOYDB_CLUSTER": "my-cluster",
    "ALLOYDB_INSTANCE": "my-instance",
    "ALLOYDB_DATABASE": "mydb",
    "ALLOYDB_USER": "postgres",
    "ALLOYDB_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `ALLOYDB_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `ALLOYDB_REGION` | Yes | GCP region | - | `us-central1` |
| `ALLOYDB_CLUSTER` | Yes | AlloyDB cluster ID | - | `my-cluster` |
| `ALLOYDB_INSTANCE` | Yes | AlloyDB instance ID | - | `my-instance` |
| `ALLOYDB_DATABASE` | Yes | Database name | - | `mydb` |
| `ALLOYDB_USER` | Yes | Database username | - | `postgres` |
| `ALLOYDB_PASSWORD` | Yes | Database password | - | `your-password` |

---

## BigQuery

BigQuery is Google Cloud's fully managed, petabyte-scale analytics data warehouse.

### Docker Command

```bash
BIGQUERY_PROJECT=my-project \
BIGQUERY_DATASET=my_dataset \
GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json \
docker run --rm -d \
  --name mcp-bigquery \
  -p 3000:3000 \
  -e BIGQUERY_PROJECT \
  -e BIGQUERY_DATASET \
  -e GOOGLE_APPLICATION_CREDENTIALS \
  -v /path/to/service-account.json:/creds/sa.json \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt bigquery
```

### MCP Client Configuration

```json
"bigquery": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "BIGQUERY_PROJECT",
    "-e", "BIGQUERY_DATASET",
    "-v", "${GOOGLE_APPLICATION_CREDENTIALS}:/creds/sa.json",
    "-e", "GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "bigquery",
    "--stdio"
  ],
  "env": {
    "BIGQUERY_PROJECT": "my-project",
    "BIGQUERY_DATASET": "my_dataset",
    "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `BIGQUERY_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `BIGQUERY_DATASET` | No | Default dataset | - | `my_dataset` |
| `BIGQUERY_LOCATION` | No | BigQuery location | `US` | `US`, `EU` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Yes* | Path to service account JSON | - | `/creds/sa.json` |

*Either provide `GOOGLE_APPLICATION_CREDENTIALS` or ensure the container has access to GCP credentials through other means.

---

## Bigtable

Bigtable is a low-latency NoSQL database service for machine learning and operational analytics.

### Docker Command

```bash
BIGTABLE_PROJECT=my-project \
BIGTABLE_INSTANCE=my-instance \
BIGTABLE_TABLE=my-table \
GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json \
docker run --rm -d \
  --name mcp-bigtable \
  -p 3000:3000 \
  -e BIGTABLE_PROJECT \
  -e BIGTABLE_INSTANCE \
  -e BIGTABLE_TABLE \
  -e GOOGLE_APPLICATION_CREDENTIALS \
  -v /path/to/service-account.json:/creds/sa.json \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt bigtable
```

### MCP Client Configuration

```json
"bigtable": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "BIGTABLE_PROJECT",
    "-e", "BIGTABLE_INSTANCE",
    "-e", "BIGTABLE_TABLE",
    "-v", "${GOOGLE_APPLICATION_CREDENTIALS}:/creds/sa.json",
    "-e", "GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "bigtable",
    "--stdio"
  ],
  "env": {
    "BIGTABLE_PROJECT": "my-project",
    "BIGTABLE_INSTANCE": "my-instance",
    "BIGTABLE_TABLE": "my-table",
    "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `BIGTABLE_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `BIGTABLE_INSTANCE` | Yes | Bigtable instance ID | - | `my-instance` |
| `BIGTABLE_TABLE` | Yes | Bigtable table name | - | `my-table` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Yes* | Path to service account JSON | - | `/creds/sa.json` |

---

## Cloud SQL for MySQL

Cloud SQL for MySQL is a fully-managed database service for MySQL.

### Docker Command

```bash
CLOUDSQL_MYSQL_PROJECT=my-project \
CLOUDSQL_MYSQL_REGION=us-central1 \
CLOUDSQL_MYSQL_INSTANCE=my-instance \
CLOUDSQL_MYSQL_DATABASE=mydb \
CLOUDSQL_MYSQL_USER=root \
CLOUDSQL_MYSQL_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-cloudsql-mysql \
  -p 3000:3000 \
  -e CLOUDSQL_MYSQL_PROJECT \
  -e CLOUDSQL_MYSQL_REGION \
  -e CLOUDSQL_MYSQL_INSTANCE \
  -e CLOUDSQL_MYSQL_DATABASE \
  -e CLOUDSQL_MYSQL_USER \
  -e CLOUDSQL_MYSQL_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt cloud-sql-mysql
```

### MCP Client Configuration

```json
"cloudsql-mysql": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "CLOUDSQL_MYSQL_PROJECT",
    "-e", "CLOUDSQL_MYSQL_REGION",
    "-e", "CLOUDSQL_MYSQL_INSTANCE",
    "-e", "CLOUDSQL_MYSQL_DATABASE",
    "-e", "CLOUDSQL_MYSQL_USER",
    "-e", "CLOUDSQL_MYSQL_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "cloud-sql-mysql",
    "--stdio"
  ],
  "env": {
    "CLOUDSQL_MYSQL_PROJECT": "my-project",
    "CLOUDSQL_MYSQL_REGION": "us-central1",
    "CLOUDSQL_MYSQL_INSTANCE": "my-instance",
    "CLOUDSQL_MYSQL_DATABASE": "mydb",
    "CLOUDSQL_MYSQL_USER": "root",
    "CLOUDSQL_MYSQL_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `CLOUDSQL_MYSQL_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `CLOUDSQL_MYSQL_REGION` | Yes | GCP region | - | `us-central1` |
| `CLOUDSQL_MYSQL_INSTANCE` | Yes | Cloud SQL instance name | - | `my-instance` |
| `CLOUDSQL_MYSQL_DATABASE` | Yes | Database name | - | `mydb` |
| `CLOUDSQL_MYSQL_USER` | Yes | Database username | - | `root` |
| `CLOUDSQL_MYSQL_PASSWORD` | Yes | Database password | - | `your-password` |

---

## Cloud SQL for PostgreSQL

Cloud SQL for PostgreSQL is a fully-managed database service for PostgreSQL.

### Docker Command

```bash
CLOUDSQL_POSTGRES_PROJECT=my-project \
CLOUDSQL_POSTGRES_REGION=us-central1 \
CLOUDSQL_POSTGRES_INSTANCE=my-instance \
CLOUDSQL_POSTGRES_DATABASE=mydb \
CLOUDSQL_POSTGRES_USER=postgres \
CLOUDSQL_POSTGRES_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-cloudsql-postgres \
  -p 3000:3000 \
  -e CLOUDSQL_POSTGRES_PROJECT \
  -e CLOUDSQL_POSTGRES_REGION \
  -e CLOUDSQL_POSTGRES_INSTANCE \
  -e CLOUDSQL_POSTGRES_DATABASE \
  -e CLOUDSQL_POSTGRES_USER \
  -e CLOUDSQL_POSTGRES_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt cloud-sql-postgres
```

### MCP Client Configuration

```json
"cloudsql-postgres": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "CLOUDSQL_POSTGRES_PROJECT",
    "-e", "CLOUDSQL_POSTGRES_REGION",
    "-e", "CLOUDSQL_POSTGRES_INSTANCE",
    "-e", "CLOUDSQL_POSTGRES_DATABASE",
    "-e", "CLOUDSQL_POSTGRES_USER",
    "-e", "CLOUDSQL_POSTGRES_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "cloud-sql-postgres",
    "--stdio"
  ],
  "env": {
    "CLOUDSQL_POSTGRES_PROJECT": "my-project",
    "CLOUDSQL_POSTGRES_REGION": "us-central1",
    "CLOUDSQL_POSTGRES_INSTANCE": "my-instance",
    "CLOUDSQL_POSTGRES_DATABASE": "mydb",
    "CLOUDSQL_POSTGRES_USER": "postgres",
    "CLOUDSQL_POSTGRES_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `CLOUDSQL_POSTGRES_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `CLOUDSQL_POSTGRES_REGION` | Yes | GCP region | - | `us-central1` |
| `CLOUDSQL_POSTGRES_INSTANCE` | Yes | Cloud SQL instance name | - | `my-instance` |
| `CLOUDSQL_POSTGRES_DATABASE` | Yes | Database name | - | `mydb` |
| `CLOUDSQL_POSTGRES_USER` | Yes | Database username | - | `postgres` |
| `CLOUDSQL_POSTGRES_PASSWORD` | Yes | Database password | - | `your-password` |

---

## Cloud SQL for SQL Server

Cloud SQL for SQL Server is a fully-managed database service for SQL Server.

### Docker Command

```bash
CLOUDSQL_SQLSERVER_PROJECT=my-project \
CLOUDSQL_SQLSERVER_REGION=us-central1 \
CLOUDSQL_SQLSERVER_INSTANCE=my-instance \
CLOUDSQL_SQLSERVER_DATABASE=mydb \
CLOUDSQL_SQLSERVER_USER=sqlserver \
CLOUDSQL_SQLSERVER_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-cloudsql-sqlserver \
  -p 3000:3000 \
  -e CLOUDSQL_SQLSERVER_PROJECT \
  -e CLOUDSQL_SQLSERVER_REGION \
  -e CLOUDSQL_SQLSERVER_INSTANCE \
  -e CLOUDSQL_SQLSERVER_DATABASE \
  -e CLOUDSQL_SQLSERVER_USER \
  -e CLOUDSQL_SQLSERVER_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt cloud-sql-mssql
```

### MCP Client Configuration

```json
"cloudsql-sqlserver": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "CLOUDSQL_SQLSERVER_PROJECT",
    "-e", "CLOUDSQL_SQLSERVER_REGION",
    "-e", "CLOUDSQL_SQLSERVER_INSTANCE",
    "-e", "CLOUDSQL_SQLSERVER_DATABASE",
    "-e", "CLOUDSQL_SQLSERVER_USER",
    "-e", "CLOUDSQL_SQLSERVER_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "cloud-sql-mssql",
    "--stdio"
  ],
  "env": {
    "CLOUDSQL_SQLSERVER_PROJECT": "my-project",
    "CLOUDSQL_SQLSERVER_REGION": "us-central1",
    "CLOUDSQL_SQLSERVER_INSTANCE": "my-instance",
    "CLOUDSQL_SQLSERVER_DATABASE": "mydb",
    "CLOUDSQL_SQLSERVER_USER": "sqlserver",
    "CLOUDSQL_SQLSERVER_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `CLOUDSQL_SQLSERVER_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `CLOUDSQL_SQLSERVER_REGION` | Yes | GCP region | - | `us-central1` |
| `CLOUDSQL_SQLSERVER_INSTANCE` | Yes | Cloud SQL instance name | - | `my-instance` |
| `CLOUDSQL_SQLSERVER_DATABASE` | Yes | Database name | - | `mydb` |
| `CLOUDSQL_SQLSERVER_USER` | Yes | Database username | - | `sqlserver` |
| `CLOUDSQL_SQLSERVER_PASSWORD` | Yes | Database password | - | `your-password` |

---

## Couchbase

Couchbase is a distributed NoSQL database.

### Docker Command

```bash
COUCHBASE_HOST=localhost \
COUCHBASE_BUCKET=my-bucket \
COUCHBASE_USERNAME=Administrator \
COUCHBASE_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-couchbase \
  -p 3000:3000 \
  -e COUCHBASE_HOST \
  -e COUCHBASE_BUCKET \
  -e COUCHBASE_USERNAME \
  -e COUCHBASE_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt couchbase
```

### MCP Client Configuration

```json
"couchbase": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "COUCHBASE_HOST",
    "-e", "COUCHBASE_BUCKET",
    "-e", "COUCHBASE_USERNAME",
    "-e", "COUCHBASE_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "couchbase",
    "--stdio"
  ],
  "env": {
    "COUCHBASE_HOST": "localhost",
    "COUCHBASE_BUCKET": "my-bucket",
    "COUCHBASE_USERNAME": "Administrator",
    "COUCHBASE_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `COUCHBASE_HOST` | Yes | Couchbase host | - | `localhost` |
| `COUCHBASE_PORT` | No | Couchbase port | `8091` | `8091` |
| `COUCHBASE_BUCKET` | Yes | Bucket name | - | `my-bucket` |
| `COUCHBASE_USERNAME` | Yes | Username | - | `Administrator` |
| `COUCHBASE_PASSWORD` | Yes | Password | - | `your-password` |

---

## Dataplex

Dataplex Universal Catalog is a unified governance solution for data and AI assets in Google Cloud.

### Docker Command

```bash
DATAPLEX_PROJECT=my-project \
DATAPLEX_LOCATION=us-central1 \
GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json \
docker run --rm -d \
  --name mcp-dataplex \
  -p 3000:3000 \
  -e DATAPLEX_PROJECT \
  -e DATAPLEX_LOCATION \
  -e GOOGLE_APPLICATION_CREDENTIALS \
  -v /path/to/service-account.json:/creds/sa.json \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt dataplex
```

### MCP Client Configuration

```json
"dataplex": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "DATAPLEX_PROJECT",
    "-e", "DATAPLEX_LOCATION",
    "-v", "${GOOGLE_APPLICATION_CREDENTIALS}:/creds/sa.json",
    "-e", "GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "dataplex",
    "--stdio"
  ],
  "env": {
    "DATAPLEX_PROJECT": "my-project",
    "DATAPLEX_LOCATION": "us-central1",
    "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `DATAPLEX_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `DATAPLEX_LOCATION` | Yes | Dataplex location | - | `us-central1` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Yes* | Path to service account JSON | - | `/creds/sa.json` |

---

## Dgraph

Dgraph is a distributed graph database built for production.

### Docker Command

```bash
DGRAPH_HOST=localhost \
DGRAPH_PORT=9080 \
docker run --rm -d \
  --name mcp-dgraph \
  -p 3000:3000 \
  -e DGRAPH_HOST \
  -e DGRAPH_PORT \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt dgraph
```

### MCP Client Configuration

```json
"dgraph": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "DGRAPH_HOST",
    "-e", "DGRAPH_PORT",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "dgraph",
    "--stdio"
  ],
  "env": {
    "DGRAPH_HOST": "localhost",
    "DGRAPH_PORT": "9080"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `DGRAPH_HOST` | Yes | Dgraph host | - | `localhost` |
| `DGRAPH_PORT` | No | Dgraph gRPC port | `9080` | `9080` |
| `DGRAPH_API_KEY` | No | API key if using Dgraph Cloud | - | `your-api-key` |

---

## Firestore

Firestore is a NoSQL document database built for automatic scaling and ease of development.

### Docker Command

```bash
FIRESTORE_PROJECT=my-project \
FIRESTORE_DATABASE=(default) \
GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json \
docker run --rm -d \
  --name mcp-firestore \
  -p 3000:3000 \
  -e FIRESTORE_PROJECT \
  -e FIRESTORE_DATABASE \
  -e GOOGLE_APPLICATION_CREDENTIALS \
  -v /path/to/service-account.json:/creds/sa.json \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt firestore
```

### MCP Client Configuration

```json
"firestore": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "FIRESTORE_PROJECT",
    "-e", "FIRESTORE_DATABASE",
    "-v", "${GOOGLE_APPLICATION_CREDENTIALS}:/creds/sa.json",
    "-e", "GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "firestore",
    "--stdio"
  ],
  "env": {
    "FIRESTORE_PROJECT": "my-project",
    "FIRESTORE_DATABASE": "(default)",
    "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `FIRESTORE_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `FIRESTORE_DATABASE` | No | Database ID | `(default)` | `(default)` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Yes* | Path to service account JSON | - | `/creds/sa.json` |

---

## Looker

Looker is a business intelligence and data platform.

### Docker Command

```bash
LOOKER_BASE_URL=https://mycompany.looker.com \
LOOKER_CLIENT_ID=your-client-id \
LOOKER_CLIENT_SECRET=your-client-secret \
docker run --rm -d \
  --name mcp-looker \
  -p 3000:3000 \
  -e LOOKER_BASE_URL \
  -e LOOKER_CLIENT_ID \
  -e LOOKER_CLIENT_SECRET \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt looker
```

### MCP Client Configuration

```json
"looker": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "LOOKER_BASE_URL",
    "-e", "LOOKER_CLIENT_ID",
    "-e", "LOOKER_CLIENT_SECRET",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "looker",
    "--stdio"
  ],
  "env": {
    "LOOKER_BASE_URL": "https://mycompany.looker.com",
    "LOOKER_CLIENT_ID": "your-client-id",
    "LOOKER_CLIENT_SECRET": "your-client-secret"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `LOOKER_BASE_URL` | Yes | Looker instance URL | - | `https://mycompany.looker.com` |
| `LOOKER_CLIENT_ID` | Yes | API client ID | - | `your-client-id` |
| `LOOKER_CLIENT_SECRET` | Yes | API client secret | - | `your-client-secret` |

---

## MongoDB

MongoDB is a document-oriented NoSQL database.

### Docker Command

```bash
MONGODB_URI=mongodb://localhost:27017 \
MONGODB_DATABASE=mydb \
MONGODB_USERNAME=admin \
MONGODB_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-mongodb \
  -p 3000:3000 \
  -e MONGODB_URI \
  -e MONGODB_DATABASE \
  -e MONGODB_USERNAME \
  -e MONGODB_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt mongodb
```

### MCP Client Configuration

```json
"mongodb": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "MONGODB_URI",
    "-e", "MONGODB_DATABASE",
    "-e", "MONGODB_USERNAME",
    "-e", "MONGODB_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "mongodb",
    "--stdio"
  ],
  "env": {
    "MONGODB_URI": "mongodb://localhost:27017",
    "MONGODB_DATABASE": "mydb",
    "MONGODB_USERNAME": "admin",
    "MONGODB_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `MONGODB_URI` | Yes | MongoDB connection URI | - | `mongodb://localhost:27017` |
| `MONGODB_DATABASE` | Yes | Database name | - | `mydb` |
| `MONGODB_USERNAME` | No | Username | - | `admin` |
| `MONGODB_PASSWORD` | No | Password | - | `your-password` |

---

## MySQL

MySQL is an open-source relational database management system.

### Docker Command

```bash
MYSQL_HOST=localhost \
MYSQL_DATABASE=mydb \
MYSQL_USER=root \
MYSQL_PASSWORD=your-password \
MYSQL_PORT=3306 \
docker run --rm -d \
  --name mcp-mysql \
  -p 3000:3000 \
  -e MYSQL_HOST \
  -e MYSQL_DATABASE \
  -e MYSQL_USER \
  -e MYSQL_PASSWORD \
  -e MYSQL_PORT \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt mysql
```

### MCP Client Configuration

```json
"mysql": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "MYSQL_HOST",
    "-e", "MYSQL_DATABASE",
    "-e", "MYSQL_USER",
    "-e", "MYSQL_PASSWORD",
    "-e", "MYSQL_PORT",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "mysql",
    "--stdio"
  ],
  "env": {
    "MYSQL_HOST": "localhost",
    "MYSQL_DATABASE": "mydb",
    "MYSQL_USER": "root",
    "MYSQL_PASSWORD": "your-password",
    "MYSQL_PORT": "3306"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `MYSQL_HOST` | Yes | MySQL host | - | `localhost` |
| `MYSQL_PORT` | No | MySQL port | `3306` | `3306` |
| `MYSQL_DATABASE` | Yes | Database name | - | `mydb` |
| `MYSQL_USER` | Yes | Username | - | `root` |
| `MYSQL_PASSWORD` | Yes | Password | - | `your-password` |

---

## Neo4j

Neo4j is a graph database management system.

### Docker Command

```bash
NEO4J_URI=bolt://localhost:7687 \
NEO4J_USERNAME=neo4j \
NEO4J_PASSWORD=your-password \
NEO4J_DATABASE=neo4j \
docker run --rm -d \
  --name mcp-neo4j \
  -p 3000:3000 \
  -e NEO4J_URI \
  -e NEO4J_USERNAME \
  -e NEO4J_PASSWORD \
  -e NEO4J_DATABASE \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt neo4j
```

### MCP Client Configuration

```json
"neo4j": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "NEO4J_URI",
    "-e", "NEO4J_USERNAME",
    "-e", "NEO4J_PASSWORD",
    "-e", "NEO4J_DATABASE",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "neo4j",
    "--stdio"
  ],
  "env": {
    "NEO4J_URI": "bolt://localhost:7687",
    "NEO4J_USERNAME": "neo4j",
    "NEO4J_PASSWORD": "your-password",
    "NEO4J_DATABASE": "neo4j"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `NEO4J_URI` | Yes | Neo4j connection URI | - | `bolt://localhost:7687` |
| `NEO4J_USERNAME` | Yes | Username | - | `neo4j` |
| `NEO4J_PASSWORD` | Yes | Password | - | `your-password` |
| `NEO4J_DATABASE` | No | Database name | `neo4j` | `neo4j` |

---

## PostgreSQL

PostgreSQL is a powerful, open-source object-relational database system.

### Docker Command

```bash
POSTGRES_HOST=localhost \
POSTGRES_DATABASE=mydb \
POSTGRES_USER=postgres \
POSTGRES_PASSWORD=your-password \
POSTGRES_PORT=5432 \
docker run --rm -d \
  --name mcp-postgres \
  -p 3000:3000 \
  -e POSTGRES_HOST \
  -e POSTGRES_DATABASE \
  -e POSTGRES_USER \
  -e POSTGRES_PASSWORD \
  -e POSTGRES_PORT \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt postgres
```

### MCP Client Configuration

```json
"postgres": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "POSTGRES_HOST",
    "-e", "POSTGRES_DATABASE",
    "-e", "POSTGRES_USER",
    "-e", "POSTGRES_PASSWORD",
    "-e", "POSTGRES_PORT",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "postgres",
    "--stdio"
  ],
  "env": {
    "POSTGRES_HOST": "localhost",
    "POSTGRES_DATABASE": "mydb",
    "POSTGRES_USER": "postgres",
    "POSTGRES_PASSWORD": "your-password",
    "POSTGRES_PORT": "5432"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `POSTGRES_HOST` | Yes | PostgreSQL host | - | `localhost` |
| `POSTGRES_PORT` | No | PostgreSQL port | `5432` | `5432` |
| `POSTGRES_DATABASE` | Yes | Database name | - | `mydb` |
| `POSTGRES_USER` | Yes | Username | - | `postgres` |
| `POSTGRES_PASSWORD` | Yes | Password | - | `your-password` |
| `POSTGRES_SSL_MODE` | No | SSL mode | `prefer` | `disable`, `require` |

---

## Redis

Redis is an in-memory data structure store.

### Docker Command

```bash
REDIS_HOST=localhost \
REDIS_PORT=6379 \
REDIS_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-redis \
  -p 3000:3000 \
  -e REDIS_HOST \
  -e REDIS_PORT \
  -e REDIS_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt redis
```

### MCP Client Configuration

```json
"redis": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "REDIS_HOST",
    "-e", "REDIS_PORT",
    "-e", "REDIS_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "redis",
    "--stdio"
  ],
  "env": {
    "REDIS_HOST": "localhost",
    "REDIS_PORT": "6379",
    "REDIS_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `REDIS_HOST` | Yes | Redis host | - | `localhost` |
| `REDIS_PORT` | No | Redis port | `6379` | `6379` |
| `REDIS_PASSWORD` | No | Password | - | `your-password` |
| `REDIS_DB` | No | Database number | `0` | `0` |
| `REDIS_USERNAME` | No | Username (Redis 6+) | - | `default` |

---

## Redshift

Amazon Redshift is a fast, scalable data warehouse that makes it simple and cost-effective to analyze all your data using standard SQL and your existing business intelligence tools.

> **Note**: Redshift requires a custom tools configuration file because it doesn't support all PostgreSQL features used in the prebuilt tools (e.g., `array_agg` with `ORDER BY`).

### Creating the Redshift Configuration

First, create a file named `redshift.yaml` with the following content:

```yaml
tools:
  - name: list_tables
    description: Lists detailed schema information for tables. If table_names are provided, shows details for those specific tables; otherwise shows all tables in user schemas.
    parameters:
      type: object
      properties:
        table_names:
          type: string
          description: Optional comma-separated list of table names. If empty, details for all tables in user-accessible schemas will be listed.
      required:
        - table_names
    steps:
      - type: sql
        query: |
          SELECT 
            c.table_schema AS schema_name,
            c.table_name,
            c.column_name,
            c.ordinal_position AS column_position,
            c.data_type,
            c.is_nullable,
            c.column_default
          FROM 
            information_schema.columns c
          WHERE 
            c.table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_temp_1', 'pg_toast', 'pg_internal')
            AND (
              :table_names IS NULL 
              OR :table_names = ''
              OR (',' || :table_names || ',') LIKE ('%,' || c.table_name || ',%')
            )
          ORDER BY 
            c.table_schema,
            c.table_name,
            c.ordinal_position;
        params:
          - name: table_names
            type: string
            description: Optional comma-separated list of table names

  - name: execute_sql
    description: Execute arbitrary SQL queries against the Redshift database.
    parameters:
      type: object
      properties:
        sql:
          type: string
          description: The SQL query to execute.
      required:
        - sql
    steps:
      - type: sql
        query: "{{sql}}"
```

### Docker Command

```bash
REDSHIFT_HOST=your-cluster.redshift.amazonaws.com \
REDSHIFT_DATABASE=mydb \
REDSHIFT_USER=awsuser \
REDSHIFT_PASSWORD=your-password \
REDSHIFT_PORT=5439 \
docker run --rm -d \
  --name mcp-redshift \
  -p 3000:3000 \
  -e POSTGRES_HOST=$REDSHIFT_HOST \
  -e POSTGRES_DATABASE=$REDSHIFT_DATABASE \
  -e POSTGRES_USER=$REDSHIFT_USER \
  -e POSTGRES_PASSWORD=$REDSHIFT_PASSWORD \
  -e POSTGRES_PORT=$REDSHIFT_PORT \
  -v /path/to/redshift.yaml:/config/redshift.yaml \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --tools-file /config/redshift.yaml
```

### MCP Client Configuration

```json
"redshift": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "POSTGRES_HOST",
    "-e", "POSTGRES_DATABASE",
    "-e", "POSTGRES_USER",
    "-e", "POSTGRES_PASSWORD",
    "-e", "POSTGRES_PORT",
    "-v", "/path/to/redshift.yaml:/config/redshift.yaml",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--tools-file", "/config/redshift.yaml",
    "--stdio"
  ],
  "env": {
    "POSTGRES_HOST": "your-cluster.redshift.amazonaws.com",
    "POSTGRES_DATABASE": "mydb",
    "POSTGRES_USER": "awsuser",
    "POSTGRES_PASSWORD": "your-password",
    "POSTGRES_PORT": "5439"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|
| `POSTGRES_HOST` | Yes | Redshift cluster endpoint | - | `your-cluster.redshift.amazonaws.com` |
| `POSTGRES_PORT` | No | Redshift port | `5439` | `5439` |
| `POSTGRES_DATABASE` | Yes | Database name | - | `mydb` |
| `POSTGRES_USER` | Yes | Username | - | `awsuser` |
| `POSTGRES_PASSWORD` | Yes | Password | - | `your-password` |

---

## Spanner

Spanner is Google's globally distributed relational database service.

### Docker Command

```bash
SPANNER_PROJECT=my-project \
SPANNER_INSTANCE=my-instance \
SPANNER_DATABASE=mydb \
GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json \
docker run --rm -d \
  --name mcp-spanner \
  -p 3000:3000 \
  -e SPANNER_PROJECT \
  -e SPANNER_INSTANCE \
  -e SPANNER_DATABASE \
  -e GOOGLE_APPLICATION_CREDENTIALS \
  -v /path/to/service-account.json:/creds/sa.json \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt spanner
```

### MCP Client Configuration

```json
"spanner": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "SPANNER_PROJECT",
    "-e", "SPANNER_INSTANCE",
    "-e", "SPANNER_DATABASE",
    "-v", "${GOOGLE_APPLICATION_CREDENTIALS}:/creds/sa.json",
    "-e", "GOOGLE_APPLICATION_CREDENTIALS=/creds/sa.json",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "spanner",
    "--stdio"
  ],
  "env": {
    "SPANNER_PROJECT": "my-project",
    "SPANNER_INSTANCE": "my-instance",
    "SPANNER_DATABASE": "mydb",
    "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `SPANNER_PROJECT` | Yes | GCP project ID | - | `my-project` |
| `SPANNER_INSTANCE` | Yes | Spanner instance ID | - | `my-instance` |
| `SPANNER_DATABASE` | Yes | Database name | - | `mydb` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Yes* | Path to service account JSON | - | `/creds/sa.json` |

---

## SQL Server

Microsoft SQL Server is a relational database management system.

### Docker Command

```bash
SQLSERVER_HOST=localhost \
SQLSERVER_DATABASE=mydb \
SQLSERVER_USER=sa \
SQLSERVER_PASSWORD=your-password \
SQLSERVER_PORT=1433 \
docker run --rm -d \
  --name mcp-sqlserver \
  -p 3000:3000 \
  -e SQLSERVER_HOST \
  -e SQLSERVER_DATABASE \
  -e SQLSERVER_USER \
  -e SQLSERVER_PASSWORD \
  -e SQLSERVER_PORT \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt mssql
```

### MCP Client Configuration

```json
"sqlserver": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "SQLSERVER_HOST",
    "-e", "SQLSERVER_DATABASE",
    "-e", "SQLSERVER_USER",
    "-e", "SQLSERVER_PASSWORD",
    "-e", "SQLSERVER_PORT",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "mssql",
    "--stdio"
  ],
  "env": {
    "SQLSERVER_HOST": "localhost",
    "SQLSERVER_DATABASE": "mydb",
    "SQLSERVER_USER": "sa",
    "SQLSERVER_PASSWORD": "your-password",
    "SQLSERVER_PORT": "1433"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `SQLSERVER_HOST` | Yes | SQL Server host | - | `localhost` |
| `SQLSERVER_PORT` | No | SQL Server port | `1433` | `1433` |
| `SQLSERVER_DATABASE` | Yes | Database name | - | `mydb` |
| `SQLSERVER_USER` | Yes | Username | - | `sa` |
| `SQLSERVER_PASSWORD` | Yes | Password | - | `your-password` |
| `SQLSERVER_TRUST_CERT` | No | Trust server certificate | `false` | `true`, `false` |

---

## SQLite

SQLite is a lightweight, file-based relational database.

### Docker Command

```bash
SQLITE_FILE=/data/mydb.sqlite \
docker run --rm -d \
  --name mcp-sqlite \
  -p 3000:3000 \
  -v /path/to/mydb.sqlite:/data/mydb.sqlite \
  -e SQLITE_FILE \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt sqlite
```

### MCP Client Configuration

```json
"sqlite": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-v", "/path/to/mydb.sqlite:/data/mydb.sqlite",
    "-e", "SQLITE_FILE",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "sqlite",
    "--stdio"
  ],
  "env": {
    "SQLITE_FILE": "/data/mydb.sqlite"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `SQLITE_FILE` | Yes | Path to SQLite file | - | `/data/mydb.sqlite` |
| `SQLITE_READONLY` | No | Open in read-only mode | `false` | `true`, `false` |

---

## TiDB

TiDB is a distributed SQL database.

### Docker Command

```bash
TIDB_HOST=localhost \
TIDB_DATABASE=mydb \
TIDB_USER=root \
TIDB_PASSWORD=your-password \
TIDB_PORT=4000 \
docker run --rm -d \
  --name mcp-tidb \
  -p 3000:3000 \
  -e TIDB_HOST \
  -e TIDB_DATABASE \
  -e TIDB_USER \
  -e TIDB_PASSWORD \
  -e TIDB_PORT \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt tidb
```

### MCP Client Configuration

```json
"tidb": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "TIDB_HOST",
    "-e", "TIDB_DATABASE",
    "-e", "TIDB_USER",
    "-e", "TIDB_PASSWORD",
    "-e", "TIDB_PORT",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "tidb",
    "--stdio"
  ],
  "env": {
    "TIDB_HOST": "localhost",
    "TIDB_DATABASE": "mydb",
    "TIDB_USER": "root",
    "TIDB_PASSWORD": "your-password",
    "TIDB_PORT": "4000"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `TIDB_HOST` | Yes | TiDB host | - | `localhost` |
| `TIDB_PORT` | No | TiDB port | `4000` | `4000` |
| `TIDB_DATABASE` | Yes | Database name | - | `mydb` |
| `TIDB_USER` | Yes | Username | - | `root` |
| `TIDB_PASSWORD` | No | Password | - | `your-password` |

---

## Valkey

Valkey is an open-source in-memory data store, forked from Redis.

### Docker Command

```bash
VALKEY_HOST=localhost \
VALKEY_PORT=6379 \
VALKEY_PASSWORD=your-password \
docker run --rm -d \
  --name mcp-valkey \
  -p 3000:3000 \
  -e VALKEY_HOST \
  -e VALKEY_PORT \
  -e VALKEY_PASSWORD \
  us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest \
  --prebuilt valkey
```

### MCP Client Configuration

```json
"valkey": {
  "command": "docker",
  "args": [
    "run", "--rm", "-i",
    "-e", "VALKEY_HOST",
    "-e", "VALKEY_PORT",
    "-e", "VALKEY_PASSWORD",
    "us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:latest",
    "--prebuilt", "valkey",
    "--stdio"
  ],
  "env": {
    "VALKEY_HOST": "localhost",
    "VALKEY_PORT": "6379",
    "VALKEY_PASSWORD": "your-password"
  }
}
```

### Environment Variables

| Variable | Required | Description | Default | Example |
|----------|----------|-------------|---------|---------|  
| `VALKEY_HOST` | Yes | Valkey host | - | `localhost` |
| `VALKEY_PORT` | No | Valkey port | `6379` | `6379` |
| `VALKEY_PASSWORD` | No | Password | - | `your-password` |
| `VALKEY_DB` | No | Database number | `0` | `0` |
| `VALKEY_USERNAME` | No | Username | - | `default` |

---

## 📚 Additional Resources

- [Google Database Toolbox Documentation](https://googleapis.github.io/genai-toolbox/)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
