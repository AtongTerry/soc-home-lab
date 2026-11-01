#!/usr/bin/env bash
# Validate Wazuh rules before restarting. Run on SIEM01.
# Ignore the "malicious-ioc" list warnings; any ERROR or CRITICAL line is a real problem.
set -u
if sudo /var/ossec/bin/wazuh-analysisd -t 2>&1 | grep -E 'ERROR|CRITICAL' ; then
  echo "Config errors found. Fix them before restarting." >&2
  exit 1
fi
sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager --no-pager
