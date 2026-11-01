# Lessons learned

1. **Test one layer at a time.** Each failure was isolated by checking the adapter, IP, network firewall rule, host firewall, then the application.
2. **A host firewall can override a correct network rule.** pfSense allowed the traffic, but the Windows profile still blocked it.
3. **Check raw events before writing a correlation rule.** Rule 100100 only started firing after the success and failure events were confirmed in the archive, with matching fields.
4. **Validate config before restarting.** `wazuh-analysisd -t` would have avoided most of the SIEM downtime.
5. **Expect noise.** Low-level alert volume from routine activity is normal. Tuning is a decision to make on evidence, not a default.
