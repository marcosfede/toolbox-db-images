# MySQL MCP Server
FROM alpine:3.19

# Set metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="MCP Toolbox Server for MySQL"
LABEL version="1.0.0"
LABEL database="mysql"

# Install system dependencies including MySQL client
RUN apk add --no-cache \
    ca-certificates \
    curl \
    bash \
    tzdata \
    tini \
    mysql-client \
    && update-ca-certificates

# Create non-root user for security
RUN addgroup -g 1001 mcp && \
    adduser -D -u 1001 -G mcp mcp

# Set up application directory
WORKDIR /app

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
    chown mcp:mcp toolbox

# Create directories for configuration and data
RUN mkdir -p /app/config /app/data /app/logs && \
    chown -R mcp:mcp /app

# Copy scripts
COPY --chown=mcp:mcp scripts/healthcheck.sh /app/healthcheck.sh
COPY --chown=mcp:mcp scripts/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/healthcheck.sh /app/entrypoint.sh

# Switch to non-root user
USER mcp

# Set MySQL-specific environment variables
ENV DB_TYPE=mysql
ENV DB_PORT=3306
ENV DB_CHARSET=utf8mb4
ENV TOOLBOX_PORT=5000
ENV TOOLBOX_LOG_LEVEL=info

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /app/healthcheck.sh

# Use tini as init system
ENTRYPOINT ["/sbin/tini", "--", "/app/entrypoint.sh"]