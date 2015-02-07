#!/bin/bash
#
# @author baransja - https://github.com/baransja/linode
#
# @BASE - base stack script...
# - run system updates
# - set the hostname
# - make host entry
# - add user to sudo group
# - disable root ssh access
# - configure iptables to be secure
# - get fail2ban
# - restart the system services
#
# @DEV - development / production tools...
# - get docker
#
#  stack script variables...
# -------------------------------------------------------
# <udf name="hostname" label="Hostname"/>
# <udf name="ipaddr" label="IP Address"/>
# <udf name="fqdn" label="Fully Qualified Domain Name"/>
# <udf name="username" label="User Name"/>
# <udf name="userpass" label="User Password"/>
# -------------------------------------------------------

# @BASE
function system_update {
    apt-get update
    apt-get -y install aptitude
    aptitude -y full-upgrade
}

function system_set_hostname {
    if [ ! -n "$HOSTNAME" ]; then
        echo "Hostname undefined"
        return 1;
    fi
    echo "$HOSTNAME" > /etc/hostname
    hostname -F /etc/hostname
}

function system_add_host_entry {
    if [ -z "$IPADDR" -o -z "$FQDN" ]; then
        echo "IP address and/or FQDN Undefined"
        return 1;
    fi
    echo $IPADDR $FQDN  >> /etc/hosts
}

function user_add_sudo {
    if [ ! -n "$USERNAME" ] || [ ! -n "$USERPASS" ]; then
        echo "No new username and/or password entered"
        return 1;
    fi
    aptitude -y install sudo
    adduser $USERNAME --disabled-password --gecos ""
    echo "$USERNAME:$USERPASS" | chpasswd
    usermod -aG sudo $USERNAME
}

function ssh_disable_root {
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    touch /tmp/restart-ssh
}

function config_iptables {
    # based on: https://help.ubuntu.com/community/IptablesHowTo
    # and http://www.thegeekstuff.com/2011/06/iptables-rules-examples/
    #
    # adapted from https://www.linode.com/stackscripts/view/5830

    # allow established sessions to recieve traffic
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    # allow loopback/127.0.0.1 traffic
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # allow ssh traffic
    iptables -A INPUT -p tcp --dport ssh -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p tcp --sport ssh -m state --state ESTABLISHED -j ACCEPT

    # allow http traffic
    iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

    # allow https traffic
    iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

    # allow pings from the outside world
    iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
    iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

    # linode specific longivew metrics
    iptables -A INPUT -s longview.linode.com -j ACCEPT
    iptables -A OUTPUT -d longview.linode.com -j ACCEPT

    # setting uplogging
    iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

    # drop the rest
    iptables -A INPUT -j DROP

    # saving the rules
    iptables-save > /etc/iptables.rules
    echo "  pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces
}

function get_fail2ban {
    apt-get install fail2ban -y
}

function restart_services {
    for service in $(ls /tmp/restart-* | cut -d- -f2-10); do
        /etc/init.d/$service restart
        rm -f /tmp/restart-$service
    done
}

# @DEV
function get_docker {
    curl -sSL https://get.docker.com/ubuntu/ | sudo sh
}

# @BASE
system_update
system_set_hostname
system_add_host_entry
user_add_sudo
ssh_disable_root
config_iptables
get_fail2ban
restart_services

# @DEV
get_docker
