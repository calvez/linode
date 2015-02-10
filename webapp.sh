#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#
# stack script variables...
# -------------------------------------------------------
# <udf name="hostname" label="Hostname"/>
# <udf name="ipaddr" label="IP Address"/>
# <udf name="fqdn" label="Fully Qualified Domain Name"/>
# <udf name="username" label="User Name"/>
# <udf name="userpass" label="User Password"/>
# -------------------------------------------------------

# https://github.com/jbaranski/linode/base.sh
source <ssinclude StackScriptID="11286">
# https://github.com/jbaranski/linode/dev.sh
source <ssinclude StackScriptID="11318">

# @BASE
system_update
system_set_hostname
system_add_host_entry
user_add_sudo
ssh_disable_root
config_iptables
get_fail2ban
restart_services

# @CORE
get_docker

# @PYTHON
get_pip
get_python_praw
