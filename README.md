# Unraid check-mk Agent plugin

This is the repository for the check-mk Agent plugin.

###2023.07.08
- Bumped checkmk_agent to v2.1.0p29

###2022.09.10
- Bumped checkmk_agent to v2.1.0p11

###2022.09.01
- Bumped checkmk_agent to v2.1.0p9

## Install in Unraid with this urls:
check_mk agent v2.1.0pXX:
https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent.plg

Check_mk agent v2.0.0pXX:
https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent20.plg

## Docker local build:

```bash
docker run -it --rm -v $(pwd)/:/build -e "CHECK_MK_URL=https://<check_mk_host>/main/check_mk/agents/check-mk-agent_<check_mk_version>_all.deb" vbatts/slackware:latest sh /build/source/compile_docker.sh
```
