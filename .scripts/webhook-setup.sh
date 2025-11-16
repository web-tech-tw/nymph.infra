#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Informational message about WebHook application
echo "To install WebHook application, please follow the instructions at:"
echo "https://github.com/adnanh/webhook"
echo ""

# Print setup message
echo "Setting up webhook configuration..."
echo ""

# Define configuration files
CONF_TEMPLATE_FILE="webhook-template.yaml"
CONF_INSTALL_FILE="autogen_webhook.yaml"

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

# Informational message about the generated file
echo "Webhook configuration generated at $CONF_INSTALL_FILE"
echo "Please link this file in your webhook installation."
echo "e.g., ln -s /srv/.scripts/$CONF_INSTALL_FILE /etc/webhook/hooks.yaml"
echo "Don't forget to restart the webhook service after linking."
echo "e.g. systemctl restart webhook"
echo ""

# Print completion message
echo "Setup complete."
