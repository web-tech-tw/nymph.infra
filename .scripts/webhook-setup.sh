#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Define configuration files
CONF_TEMPLATE_FILE="webhook-template.yml"
CONF_INSTALL_FILE="autogen_webhook.yml"

# Function to create a random secret
CREATE_SECRET() {
  openssl rand -hex 16 | tr -d '\n' 
}

# Check if template file exists
if [ ! -f "$CONF_TEMPLATE_FILE" ]; then
  echo "Template file $CONF_TEMPLATE_FILE does not exist. Exiting."
  exit 1
fi

# Generate webhook configuration with a new secret
env \
	WEBHOOK_SECRET_STACK_UP="$(CREATE_SECRET)" \
	WEBHOOK_SECRET_PART_UP="$(CREATE_SECRET)" \
	envsubst <"$CONF_TEMPLATE_FILE" >"$CONF_INSTALL_FILE"
