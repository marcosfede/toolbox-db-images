# SQL Server MCP Server
FROM alpine:3.19

# Set metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="MCP Toolbox Server for Microsoft SQL Server"
LABEL version="1.0.0"
LABEL database="sqlserver"

# Install system dependencies including ODBC driver for SQL Server
RUN apk add --no-cache \
    ca-certificates \
    curl \
    bash \
    tzdata \
    tini \
    openssl \
    python3 \
    python3-dev \
    py3-pip \
    gcc \
    g++ \
    musl-dev \
    libffi-dev \
    unixodbc \
    unixodbc-dev \
    freetds \
    freetds-dev \
    && update-ca-certificates

# Create non-root user for security
RUN addgroup -g 1001 mcp && \
    adduser -D -u 1001 -G mcp mcp

# Set up application directory
WORKDIR /app

# Create virtual environment and install SQL Server Python driver (using pymssql which works well with FreeTDS)
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir pymssql>=2.2.8 pyodbc>=4.0.39

# Download and install MCP Toolbox
ARG TOOLBOX_VERSION=0.9.0
ARG TARGETPLATFORM
RUN case ${TARGETPLATFORM} in \
    "linux/amd64") ARCH="linux/amd64" ;; \
    "linux/arm64") ARCH="linux/arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    curl -L -o toolbox "https://storage.googleapis.com/genai-toolbox/v${TOOLBOX_VERSION}/${ARCH}/toolbox" && \
    chmod +x toolbox && \
    mv toolbox /usr/local/bin/mcp-toolbox

# Copy scripts
COPY scripts/entrypoint.sh /app/scripts/entrypoint.sh
COPY scripts/healthcheck.sh /app/scripts/healthcheck.sh

# Make scripts executable
RUN chmod +x /app/scripts/entrypoint.sh /app/scripts/healthcheck.sh

# Set ownership
RUN chown -R mcp:mcp /app

# Switch to non-root user
USER mcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD /app/scripts/healthcheck.sh

# Expose port
EXPOSE 5000

# Set environment variables
ENV DB_TYPE=sqlserver
ENV TOOLBOX_PORT=5000
ENV TOOLBOX_LOG_LEVEL=info
ENV PATH="/opt/venv/bin:$PATH"

# Use tini as init system
ENTRYPOINT ["/sbin/tini", "--"]

# Default command
CMD ["/app/scripts/entrypoint.sh"]
