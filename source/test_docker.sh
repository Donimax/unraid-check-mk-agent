#!/bin/bash
# Smoke test: install built package like the .plg does, query agent on TCP 6556.
# Usage (inside slackware image): test_docker.sh <expected_version>
set -euo pipefail
EXPECTED="$1"

installpkg /build/packages/xinetd-*.txz /build/packages/check_mk_agent-*.tgz >/dev/null
cp /etc/check_mk/xinetd-service-template.cfg /etc/xinetd.d/check_mk
# minimal image lacks /etc/protocols and syslog, both present on Unraid
[ -f /etc/protocols ] || printf 'tcp 6 TCP\nudp 17 UDP\n' > /etc/protocols
xinetd -filelog /tmp/xinetd.log
sleep 2

exec 3<>/dev/tcp/127.0.0.1/6556
OUT=$(timeout 60 cat <&3)

echo "$OUT" | head -n 15
echo "..."
echo "$OUT" | grep -q '^<<<check_mk>>>$'          || { echo "FAIL: no <<<check_mk>>> section"; exit 1; }
echo "$OUT" | grep -q "^Version: ${EXPECTED}$"     || { echo "FAIL: version != ${EXPECTED}"; exit 1; }
echo "$OUT" | grep -q '^AgentOS: linux$'           || { echo "FAIL: AgentOS not linux"; exit 1; }
echo "OK: $(echo "$OUT" | grep -c '^<<<') sections, version ${EXPECTED}"
