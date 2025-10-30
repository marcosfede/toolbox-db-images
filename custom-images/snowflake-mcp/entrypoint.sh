#!/bin/bash

# Snowflake MCP Server Entrypoint
# Auto-detects authentication mode (password or key-pair)

set -euo pipefail

# Set secure umask for any temp files
umask 077

# Cleanup function for temp files
cleanup() {
    if [[ -n "${TEMP_KEY_FILE:-}" ]] && [[ -f "$TEMP_KEY_FILE" ]]; then
        rm -f "$TEMP_KEY_FILE"
    fi
}
trap cleanup EXIT

# Function to log errors (never log secrets)
log_error() {
    echo "ERROR: $*" >&2
}

# Function to display usage
usage() {
    cat <<EOF
Usage: docker run [docker-options] mcp-snowflake:local [options]

Required arguments:
  --account ACCOUNT       Snowflake account identifier
  --user USER            Snowflake username

Authentication (provide ONE of these):
  --password PASSWORD    Password (or use SNOWFLAKE_PASSWORD env var)
  SNOWFLAKE_PRIVATE_KEY  Private key PEM content (env var only)

Optional arguments:
  --role ROLE            Snowflake role
  --warehouse WAREHOUSE  Snowflake warehouse
  --database DATABASE    Snowflake database
  --schema SCHEMA        Snowflake schema
  --max-rows N           Maximum rows to return (default: 1000)
  --allow-statements STR Allowed SQL statements (default: "SELECT SHOW DESCRIBE")
  --transport TYPE       Transport type (default: stdio)

Environment variables:
  SNOWFLAKE_PASSWORD              Password for authentication
  SNOWFLAKE_PRIVATE_KEY           Private key PEM content for key-pair auth
  SNOWFLAKE_PRIVATE_KEY_FILE_PWD  Passphrase for encrypted private key

EOF
    exit 1
}

# Initialize variables
ACCOUNT=""
USER=""
PASSWORD=""
ROLE=""
WAREHOUSE=""
DATABASE=""
SCHEMA=""
MAX_ROWS="1000"
ALLOW_STATEMENTS="SELECT SHOW DESCRIBE"
TRANSPORT="stdio"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --account)
            ACCOUNT="$2"
            shift 2
            ;;
        --user)
            USER="$2"
            shift 2
            ;;
        --password)
            PASSWORD="$2"
            shift 2
            ;;
        --role)
            ROLE="$2"
            shift 2
            ;;
        --warehouse)
            WAREHOUSE="$2"
            shift 2
            ;;
        --database)
            DATABASE="$2"
            shift 2
            ;;
        --schema)
            SCHEMA="$2"
            shift 2
            ;;
        --max-rows)
            MAX_ROWS="$2"
            shift 2
            ;;
        --allow-statements)
            ALLOW_STATEMENTS="$2"
            shift 2
            ;;
        --transport)
            TRANSPORT="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            log_error "Unknown parameter: $1"
            usage
            ;;
    esac
done

# Check for password from environment if not provided via CLI
if [[ -z "$PASSWORD" ]] && [[ -n "${SNOWFLAKE_PASSWORD:-}" ]]; then
    PASSWORD="$SNOWFLAKE_PASSWORD"
fi

# Validate required parameters
if [[ -z "$ACCOUNT" ]]; then
    log_error "Missing required parameter: --account"
    usage
fi

if [[ -z "$USER" ]]; then
    log_error "Missing required parameter: --user"
    usage
fi

# Auto-detect authentication mode and validate
HAS_PASSWORD=false
HAS_PRIVATE_KEY=false

if [[ -n "$PASSWORD" ]]; then
    HAS_PASSWORD=true
fi

if [[ -n "${SNOWFLAKE_PRIVATE_KEY:-}" ]]; then
    HAS_PRIVATE_KEY=true
fi

# Validate exactly one authentication method
if [[ "$HAS_PASSWORD" == true ]] && [[ "$HAS_PRIVATE_KEY" == true ]]; then
    log_error "Multiple authentication methods provided. Please provide EITHER password OR private key, not both."
    exit 1
fi

if [[ "$HAS_PASSWORD" == false ]] && [[ "$HAS_PRIVATE_KEY" == false ]]; then
    log_error "No authentication method provided. Please provide either --password/SNOWFLAKE_PASSWORD or SNOWFLAKE_PRIVATE_KEY."
    usage
fi

# Build snowflake-labs-mcp command
CMD_ARGS=()
CMD_ARGS+=("--account" "$ACCOUNT")
CMD_ARGS+=("--user" "$USER")
CMD_ARGS+=("--transport" "$TRANSPORT")
CMD_ARGS+=("--max-rows" "$MAX_ROWS")
CMD_ARGS+=("--allow-statements" "$ALLOW_STATEMENTS")

# Add authentication parameters
if [[ "$HAS_PASSWORD" == true ]]; then
    # Password mode
    CMD_ARGS+=("--password" "$PASSWORD")
elif [[ "$HAS_PRIVATE_KEY" == true ]]; then
    # Key-pair mode: write private key to secure temp file
    TEMP_KEY_FILE="/tmp/snowflake_key_$$.p8"
    echo "$SNOWFLAKE_PRIVATE_KEY" > "$TEMP_KEY_FILE"
    chmod 0600 "$TEMP_KEY_FILE"
    
    CMD_ARGS+=("--private-key-path" "$TEMP_KEY_FILE")
    
    # Add passphrase if provided
    if [[ -n "${SNOWFLAKE_PRIVATE_KEY_FILE_PWD:-}" ]]; then
        CMD_ARGS+=("--private-key-passphrase" "$SNOWFLAKE_PRIVATE_KEY_FILE_PWD")
    fi
fi

# Add optional parameters if provided
if [[ -n "$ROLE" ]]; then
    CMD_ARGS+=("--role" "$ROLE")
fi

if [[ -n "$WAREHOUSE" ]]; then
    CMD_ARGS+=("--warehouse" "$WAREHOUSE")
fi

if [[ -n "$DATABASE" ]]; then
    CMD_ARGS+=("--database" "$DATABASE")
fi

if [[ -n "$SCHEMA" ]]; then
    CMD_ARGS+=("--schema" "$SCHEMA")
fi

# Execute the MCP server (replace shell process)
exec snowflake-labs-mcp "${CMD_ARGS[@]}"

