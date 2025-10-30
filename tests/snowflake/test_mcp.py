#!/usr/bin/env python3
"""
Simple MCP test for Snowflake
Tests both password and key-pair authentication modes via stdio.
"""

import json
import os
import subprocess
import sys
from pathlib import Path


def load_env_file(env_path: Path) -> dict:
    """Load environment variables from .env file."""
    values: dict[str, str] = {}
    if not env_path.exists():
        raise FileNotFoundError(f".env file not found at {env_path}")
    for line in env_path.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if "=" not in stripped:
            continue
        key, value = stripped.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        values[key] = value
    return values


def test_mcp_snowflake(auth_mode: str) -> bool:
    """Test Snowflake MCP server with specified auth mode."""
    print(f"Testing Snowflake MCP server ({auth_mode} mode, stdio)...")

    script_dir = Path(__file__).resolve().parent
    env_path = script_dir / ".env"
    env_file = load_env_file(env_path)

    # Common parameters
    account = env_file.get("SNOWFLAKE_ACCOUNT", "").strip()
    user = env_file.get("SNOWFLAKE_USER", "").strip()
    warehouse = env_file.get("SNOWFLAKE_WAREHOUSE", "").strip()
    database = env_file.get("SNOWFLAKE_DATABASE", "").strip()
    schema = env_file.get("SNOWFLAKE_SCHEMA", "").strip()

    missing = []
    for name, val in [
        ("SNOWFLAKE_ACCOUNT", account),
        ("SNOWFLAKE_USER", user),
    ]:
        if not val:
            missing.append(name)

    if missing:
        print(f"✗ Missing required variables in .env: {', '.join(missing)}")
        return False

    # Auth-specific parameters
    if auth_mode == "password":
        password = env_file.get("SNOWFLAKE_PASSWORD", "").strip()
        if not password:
            print("✗ Missing SNOWFLAKE_PASSWORD for password mode")
            return False
    elif auth_mode == "keypair":
        private_key = env_file.get("SNOWFLAKE_PRIVATE_KEY", "").strip()
        if not private_key:
            print("✗ Missing SNOWFLAKE_PRIVATE_KEY for keypair mode")
            return False
        private_key_pwd = env_file.get("SNOWFLAKE_PRIVATE_KEY_FILE_PWD", "").strip()
    else:
        print(f"✗ Invalid auth mode: {auth_mode}")
        return False

    DOCKER_IMAGE = "mcp-snowflake:local"

    # Build docker run command
    cmd = [
        "docker", "run", "--rm", "-i",
        "--name", f"mcp-snowflake-test-{auth_mode}",
    ]

    # Add environment variables and arguments based on auth mode
    child_env = {**os.environ}
    
    if auth_mode == "password":
        child_env["SNOWFLAKE_PASSWORD"] = password
        cmd.extend(["-e", "SNOWFLAKE_PASSWORD"])
    elif auth_mode == "keypair":
        child_env["SNOWFLAKE_PRIVATE_KEY"] = private_key
        cmd.extend(["-e", "SNOWFLAKE_PRIVATE_KEY"])
        if private_key_pwd:
            child_env["SNOWFLAKE_PRIVATE_KEY_FILE_PWD"] = private_key_pwd
            cmd.extend(["-e", "SNOWFLAKE_PRIVATE_KEY_FILE_PWD"])

    cmd.extend([
        DOCKER_IMAGE,
        "--account", account,
        "--user", user,
    ])

    if warehouse:
        cmd.extend(["--warehouse", warehouse])
    if database:
        cmd.extend(["--database", database])
    if schema:
        cmd.extend(["--schema", schema])

    process = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=child_env,
    )

    try:
        # Send initialize request
        initialize_request = {
            "jsonrpc": "2.0",
            "method": "initialize",
            "params": {
                "protocolVersion": "1.0.0",
                "capabilities": {},
                "clientInfo": {"name": "test-client", "version": "1.0.0"},
            },
            "id": 1,
        }
        assert process.stdin is not None
        process.stdin.write(json.dumps(initialize_request) + "\n")
        process.stdin.flush()

        # Read initialize response
        assert process.stdout is not None
        response_line = process.stdout.readline()
        if not response_line:
            stderr_output = process.stderr.read() if process.stderr else ""
            print("✗ No response from server during initialize")
            if stderr_output:
                print(f"✗ Stderr: {stderr_output}")
            return False
        
        try:
            response = json.loads(response_line)
            server_name = response.get('result', {}).get('serverInfo', {}).get('name', 'Unknown')
            print(f"✓ Initialize response: {server_name}")
        except json.JSONDecodeError:
            stderr_output = process.stderr.read() if process.stderr else ""
            print(f"✗ Failed to parse initialize response. Raw: {response_line}")
            if stderr_output:
                print(f"✗ Stderr: {stderr_output}")
            return False

        # List available tools
        list_tools_request = {
            "jsonrpc": "2.0",
            "method": "tools/list",
            "params": {},
            "id": 2,
        }
        process.stdin.write(json.dumps(list_tools_request) + "\n")
        process.stdin.flush()

        response_line = process.stdout.readline()
        if not response_line:
            print("✗ No response to tools/list")
            return False

        response = json.loads(response_line)
        if "result" not in response:
            print(f"✗ Failed to list tools: {response.get('error', 'Unknown error')}")
            return False

        tools = response.get("result", {}).get("tools", [])
        tool_names = [tool.get("name", "unknown") for tool in tools]
        print(f"✓ Available tools: {', '.join(tool_names)}")

        # Optionally try execute_sql if present
        if "execute_sql" in tool_names:
            execute_sql_request = {
                "jsonrpc": "2.0",
                "method": "tools/call",
                "params": {
                    "name": "execute_sql",
                    "arguments": {"sql": "SELECT CURRENT_DATE();"},
                },
                "id": 3,
            }
            process.stdin.write(json.dumps(execute_sql_request) + "\n")
            process.stdin.flush()
            exec_line = process.stdout.readline()
            if exec_line:
                try:
                    exec_resp = json.loads(exec_line)
                    if "result" in exec_resp:
                        print("✓ execute_sql call successful")
                except json.JSONDecodeError:
                    print(f"✗ execute_sql returned non-JSON: {exec_line[:200]}")

        return len(tools) > 0

    except Exception as e:
        print(f"✗ Error: {e}")
        stderr_output = process.stderr.read() if process.stderr else ""
        if stderr_output:
            print(f"✗ Stderr: {stderr_output}")
        return False
    finally:
        try:
            process.terminate()
            process.wait(timeout=5)
        except Exception:
            pass


if __name__ == "__main__":
    # Determine which auth mode to test from command line or env
    auth_mode = sys.argv[1] if len(sys.argv) > 1 else os.getenv("SNOWFLAKE_AUTH_MODE", "password")
    
    if auth_mode not in ["password", "keypair"]:
        print(f"✗ Invalid auth mode: {auth_mode}. Use 'password' or 'keypair'")
        sys.exit(1)
    
    success = test_mcp_snowflake(auth_mode)
    sys.exit(0 if success else 1)

