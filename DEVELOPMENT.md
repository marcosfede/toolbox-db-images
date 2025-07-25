# Development Guide

This guide explains how to set up a development environment, run tests, and contribute to the MCP Database Servers project.

## 🚀 Quick Start for Developers

### Prerequisites

- Docker and Docker Compose
- Git
- Bash shell (Linux/macOS/WSL)

### Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/marcosfede/toolbox-db-images.git
   cd toolbox-db-images
   ```

2. **Set up development environment:**
   ```bash
   # Start PostgreSQL environment
   cd databases/postgres
   docker-compose up -d
   
   # Start MySQL environment  
   cd ../mysql
   docker-compose up -d
   
   # Or use the build script for specific databases
   ./build.sh build-db -d postgres --test
   ```

3. **Access development services:**
   - **PostgreSQL MCP Server**: http://localhost:5001/mcp
   - **MySQL MCP Server**: http://localhost:5002/mcp  
   - **PostgreSQL Database**: localhost:5432
   - **MySQL Database**: localhost:3306
   - **Each database folder** contains a working docker-compose.yml for local testing

## 🧪 Testing

### Test Framework Overview

The project uses a comprehensive testing framework with:
- **pytest** for test execution
- **Docker Compose** for test environment
- **Database inspectors** (pgAdmin, phpMyAdmin) for manual verification
- **Automated test reports** with HTML output
- **Integration tests** across multiple databases

### Running Tests

#### Basic Test Commands

```bash
# Run all tests
./tests/run_tests.sh test

# Run quick tests only (exclude slow/integration tests)
./tests/run_tests.sh test-quick

# Run PostgreSQL tests only
./tests/run_tests.sh test-db -d postgres

# Run MySQL tests only  
./tests/run_tests.sh test-db -d mysql

# Run integration tests
./tests/run_tests.sh test-integration

# Run specific test by keyword
./tests/run_tests.sh test -k "health_check"

# Run with verbose output and HTML report
./tests/run_tests.sh test -v --html-report
```

#### Advanced Test Options

```bash
# Keep environment running after tests
./tests/run_tests.sh test --keep-running

# Don't rebuild images before testing
./tests/run_tests.sh test --no-build

# Run tests with specific pytest marker
./tests/run_tests.sh test -m "integration and not slow"

# Show test logs
./tests/run_tests.sh logs

# Clean up test environment
./tests/run_tests.sh clean
```

### Test Categories

#### 1. Health Check Tests (`test_health_checks.py`)
- MCP server health endpoints
- Basic connectivity tests
- Tool availability verification

#### 2. Database-Specific Tests
- **PostgreSQL** (`test_postgres.py`): PostgreSQL-specific features and SQL
- **MySQL** (`test_mysql.py`): MySQL-specific features and SQL
- Direct database connection tests
- Database-specific function testing

#### 3. Integration Tests (`test_integration.py`)
- Multi-database operations
- Concurrent query execution
- MCP protocol compliance
- Load and stress testing

### Test Environment Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │      MySQL      │    │  Test Runner    │
│    Database     │    │    Database     │    │   Container     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       │
┌─────────────────┐    ┌─────────────────┐               │
│ MCP PostgreSQL  │    │   MCP MySQL     │               │
│     Server      │    │    Server       │               │
└─────────────────┘    └─────────────────┘               │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                                 ▼
                    ┌─────────────────┐
                    │   Test Reports  │
                    │   (Web Viewer)  │
                    └─────────────────┘
```

## 🔧 Development Workflow

### 1. Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** to Dockerfiles, scripts, or tests

3. **Test your changes:**
   ```bash
   # Test specific database if you changed database-specific code
   ./tests/run_tests.sh test-db -d postgres
   
   # Run integration tests
   ./tests/run_tests.sh test-integration
   
   # Run all tests
   ./tests/run_tests.sh test
   ```

### 2. Adding New Database Support

To add support for a new database (e.g., Snowflake):

1. **Create Dockerfile:**
   ```bash
   cp databases/postgres/Dockerfile databases/snowflake/Dockerfile
   # Modify for Snowflake-specific dependencies
   ```

2. **Create and update scripts:**
   ```bash
   mkdir -p databases/snowflake/scripts
   cp databases/postgres/scripts/* databases/snowflake/scripts/
   # Modify entrypoint.sh for Snowflake-specific configuration
   # Update healthcheck.sh for Snowflake health checks
   ```

3. **Add to build system:**
   - Update `build.sh` DATABASES array
   - Update `Makefile` targets
   - Update GitHub Actions workflow

4. **Create tests:**
   ```bash
   cp tests/test_postgres.py tests/test_snowflake.py
   # Modify for Snowflake-specific features
   ```

5. **Create Docker Compose setup:**
   ```bash
   cp databases/postgres/docker-compose.yml databases/snowflake/docker-compose.yml
   # Modify for Snowflake-specific configuration and ports
   ```

### 3. Testing Changes

```bash
# Build and test your changes
./build.sh build-db -d your-database --test

# Run comprehensive tests
./tests/run_tests.sh test --html-report

# Check test coverage
./tests/run_tests.sh test --html-report -v
```

## 🏗️ Project Structure

```
toolbox-db-images/
├── databases/                                      # Database-specific folders
│   ├── postgres/
│   │   ├── Dockerfile                             # PostgreSQL image
│   │   ├── docker-compose.yml                     # Local testing setup  
│   │   ├── init.sql                               # Test data
│   │   └── scripts/
│   │       ├── entrypoint.sh                      # Container entrypoint
│   │       ├── healthcheck.sh                     # Health check script
│   │       └── validate_setup.sh                  # Setup validation
│   ├── mysql/
│   │   ├── Dockerfile                             # MySQL image
│   │   ├── docker-compose.yml                     # Local testing setup
│   │   ├── init.sql                               # Test data
│   │   └── scripts/                               # MySQL-specific scripts
│   ├── redis/                                     # Redis configuration
│   ├── neo4j/                                     # Neo4j configuration
│   ├── sqlite/                                    # SQLite configuration
│   └── {snowflake,redshift,bigquery,etc}/         # Cloud databases
├── tests/
│   ├── Dockerfile.test                            # Test runner image
│   ├── conftest.py                                # Pytest configuration
│   ├── test_health_checks.py                     # Health check tests
│   ├── test_postgres.py                          # PostgreSQL tests
│   ├── test_mysql.py                             # MySQL tests
│   ├── test_integration.py                       # Integration tests
│   ├── requirements.txt                          # Test dependencies
│   └── run_tests.sh                              # Test runner script
├── .github/workflows/                             # CI/CD pipelines
├── build.sh                                       # Build automation
├── Makefile                                       # Alternative build system
├── DEVELOPMENT.md                                 # This file
└── README.md                                      # User documentation
```

### Key Changes from Previous Structure

- **Database-specific folders**: Each database now has its own folder under `databases/` with all related files
- **Self-contained configurations**: Each `databases/*/` folder contains everything needed to run that database
- **No more top-level Dockerfiles**: All Dockerfiles moved to `databases/*/Dockerfile`
- **Working examples**: Each `databases/*/docker-compose.yml` serves as a tested, working example

## 🐛 Debugging

### Viewing Logs

```bash
# MCP server logs
docker logs mcp-postgres-server-local
docker logs mcp-mysql-server-local

# Database logs  
docker logs postgres-db-local
docker logs mysql-db-local

# All logs
./tests/run_tests.sh logs
```

### Connecting to Containers

```bash
# Connect to MCP server container
docker exec -it mcp-postgres-server-local /bin/bash

# Connect to database container  
docker exec -it postgres-db-local psql -U testuser -d testdb

# Run test container interactively
cd databases/postgres && docker-compose run --rm -it mcp-postgres bash
```

### Manual Testing

```bash
# Test MCP endpoints directly (PostgreSQL on port 5001, MySQL on port 5002)
curl http://localhost:5001/health
curl -X POST http://localhost:5001/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}'

# Test database connectivity
docker exec -it postgres-db-local pg_isready -U testuser -d testdb
docker exec -it mysql-db-local mysqladmin ping -u testuser -ptestpass
```

## 📊 Performance Testing

### Load Testing

```bash
# Run performance tests
./tests/run_tests.sh test -m slow

# Run specific performance test
./tests/run_tests.sh test -k "performance"
```

### Monitoring

Monitor containers during development:

```bash
# Resource usage
docker stats mcp-postgres-server-local mcp-mysql-server-local

# Container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## 🚢 Release Process

1. **Update version numbers** in build scripts and Dockerfiles
2. **Run full test suite:**
   ```bash
   ./tests/run_tests.sh test --html-report
   ```
3. **Build and tag images:**
   ```bash
   ./build.sh build --push -v v1.0.0
   ```
4. **Create git tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
5. **GitHub Actions** will automatically build and push to DockerHub

## 🤝 Contributing

### Code Style

- Follow existing patterns in Dockerfiles and scripts
- Use clear, descriptive variable names
- Add comments for complex logic
- Include error handling and logging

### Testing Requirements

- All new features must include tests
- Tests must pass in CI/CD pipeline
- Include both unit and integration tests
- Add database-specific tests for new database support

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Run the full test suite
5. Update documentation if needed
6. Submit a pull request with clear description

### Review Criteria

- Code quality and style
- Test coverage
- Documentation updates
- Security considerations
- Performance impact

## 📚 Additional Resources

- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [Google MCP Toolbox Documentation](https://googleapis.github.io/genai-toolbox/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [pytest Documentation](https://docs.pytest.org/)

## 🆘 Getting Help

- **Issues**: [GitHub Issues](https://github.com/your-username/mcp-database-servers/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/mcp-database-servers/discussions)
- **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)