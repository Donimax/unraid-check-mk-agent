# Unraid Checkmk Agent plugin

This is the repository for the Checkmk Agent plugin.

[![CodeFactor](https://www.codefactor.io/repository/github/donimax/unraid-check-mk-agent/badge/master)](https://www.codefactor.io/repository/github/donimax/unraid-check-mk-agent/overview/master)

## Install the Checkmk Agent plugin on Unraid using these URLs

check_mk agent v2.4.0pXX: [CURRENT](https://docs.checkmk.com/latest/en/cmk_versions.html)  
<https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent24.plg>

check_mk agent v2.3.0pXX: [EOL (29.10.2026)](https://docs.checkmk.com/latest/en/cmk_versions.html)  
<https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent23.plg>

check_mk agent v2.2.0pXX: [DEPRECATED](https://docs.checkmk.com/latest/en/cmk_versions.html)  
<https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent22.plg>

check_mk agent v2.1.0pXX: [DEPRECATED](https://docs.checkmk.com/latest/en/cmk_versions.html)  
<https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent21.plg>

Check_mk agent v2.0.0pXX: [DEPRECATED](https://docs.checkmk.com/latest/en/cmk_versions.html)  
<https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent20.plg>

## Docker local build

The Checkmk agent file can be downloaded manually into the "check_mk_agent" directory, or downloaded by the container by setting the environment variable `-e "CHECK_MK_URL=https://<check_mk_host>/<check_mk_site>/check_mk/agents/check-mk-agent_<check_mk_version>_all.deb"`.  
Replace `<check_mk_host>` with your Checkmk server url and `<check_mk_site>` with your Checkmk site name. Example: `http://localhost:5000/main/`

```bash
docker run -it --rm -v $(pwd)/:/build vbatts/slackware:15.0 sh /build/source/compile_docker.sh
```

## Checkmk docker and smart plugin

Requirements:

- `Python 3 for UNRAID` plugin
- User Scripts plugin
- Checkmk server

Create a script scheduled to run "At Startup of Array" to automatically install Checkmk, Docker and Smart plugin.  
Replace `<check_mk_host>` with your Checkmk server url and `<check_mk_site>` with your Checkmk site name.  

```bash
#!/bin/bash

# Set variables
CHECK_MK_SERVER_URL="https://<check_mk_host>/<check_mk_site>/"
PLUGIN_DIR="/usr/lib/check_mk_agent/plugins"
WAIT_TIME=5 # wait time in seconds
TIMEOUT=300 # timeout in seconds
START_TIME=$(date +%s)

# Install Checkmk docker dependencies
pip install docker
pip3 install docker

# Check if checkmk server is available.
while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [[ $ELAPSED_TIME -ge $TIMEOUT ]]; then
    echo "Timeout reached. Checkmk server is not available."
    exit 1
    break
  fi

  response=$(curl --write-out '%{http_code}' --silent --output /dev/null "${CHECK_MK_SERVER_URL}check_mk/agents/plugins/mk_docker.py")

  if [[ $response -eq 200 ]]; then
    echo "Checkmk server is online"
    break
  else
    echo "Checkmk server is not available. Retrying in $WAIT_TIME seconds..."
    sleep "$WAIT_TIME"
  fi
done

#Install Checkmk Docker and smart plugin
rm -rf ${PLUGIN_DIR}
mkdir -p ${PLUGIN_DIR}
cd ${PLUGIN_DIR}
wget ${CHECK_MK_SERVER_URL}check_mk/agents/plugins/mk_docker.py
chmod 755  mk_docker.py
wget ${CHECK_MK_SERVER_URL}/check_mk/agents/plugins/smart
chmod 755 smart
```
