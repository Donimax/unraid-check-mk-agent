# Unraid check-mk Agent plugin

This is the repository for the check-mk Agent plugin.


###2022.09.10
- Bumped checkmk_agent to v2.1.0p11

###2022.09.01
- Bumped checkmk_agent to v2.1.0p9

Install in Unraid with this url:
https://raw.githubusercontent.com/donimax/unraid-check-mk-agent/master/check_mk_agent.plg

Docker build:

```bash
docker run -it --rm -v $(pwd)/:/build -e "CHECK_MK_URL=https://<check_mk_host>/main/check_mk/agents/check-mk-agent_<check_mk_version>_all.deb" vbatts/slackware:latest sh /source/compile_docker.sh
```
