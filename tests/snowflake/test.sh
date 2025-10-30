#!/bin/bash
set -e

# Always run from this script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Snowflake MCP Server Test ==="
echo

# Check if .env file exists
if [[ ! -f .env ]]; then
    echo "✗ .env file not found. Please create one based on .env.example"
    exit 1
fi

# Determine which auth mode to test
AUTH_MODE="${SNOWFLAKE_AUTH_MODE:-password}"

if [[ "$AUTH_MODE" != "password" ]] && [[ "$AUTH_MODE" != "keypair" ]]; then
    echo "✗ Invalid SNOWFLAKE_AUTH_MODE: $AUTH_MODE. Use 'password' or 'keypair'"
    exit 1
fi

echo "Testing with auth mode: $AUTH_MODE"
echo

echo "1. Testing MCP server (stdio) using $AUTH_MODE authentication..."
python3 test_mcp.py "$AUTH_MODE"

echo
echo "2. Test completed!"

echo
echo "✅ Snowflake MCP test passed!"

