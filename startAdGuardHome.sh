#!/bin/bash

function echo_success() {
  echo -e "\n\e[0;97m ✅ \e[1;32m$1\n\e[0m"
}

function echo_warning() {
  echo -e "\e[0;33m ⚠️  $1 \e[0m"
}

function echo_fail() {
  echo -e "\n\e[0;31m 🛑 \e[1;31m$1\n\e[0m"
}

if [ -n "${AG_CONFIG_URL}" ] && [ -n "${AG_USER}" ] && [ -n "${AG_HTPASSWD}" ]; then

  echo_warning "Fetching AdGuardHome config. from ${AG_CONFIG_URL}/AdGuardHome.yaml"
  curl -L "${AG_CONFIG_URL}/AdGuardHome.yaml" > /opt/AdGuardHome/AdGuardHome.yaml

  echo_warning "Updating local config"
  export CURRENT_HOST=$(tailscale status --peers=false --json | jq -r '.CertDomains[0]')
  sed -i "s/ADMINUSER/${AG_USER}/" /opt/AdGuardHome/AdGuardHome.yaml
  sed -i "s/ADMINPASS/${AG_HTPASSWD}/" /opt/AdGuardHome/AdGuardHome.yaml
  sed -i "s/SERVERNAME/${CURRENT_HOST}/" /opt/AdGuardHome/AdGuardHome.yaml

  echo_success "Config updated successfully"
else
  echo_warning "No CONFIG_URL given, will keep current configuration"
fi

exec "/opt/AdGuardHome/AdGuardHome"