#!/usr/bin/env bash

if [ -z `getent passwd ${APPLICATION_USER_NAME:=server}`  ]
then
    groupadd -r -g ${APPLICATION_GROUP:=1000} ${APPLICATION_GROUP_NAME:=server} && \
    useradd -r -u ${APPLICATION_USER:=1000} -g ${APPLICATION_GROUP:=1000} -m -s /bin/false ${APPLICATION_USER_NAME:=server}

    if [ ! -d /home/${APPLICATION_USER_NAME:=server}/.ssh ]; then mkdir /home/${APPLICATION_USER_NAME:=server}/.ssh ; fi
    printf "Host gitlab.com\n\tIdentityFile ~/.ssh/id_rsa\n\tIdentitiesOnly yes\n" > /home/${APPLICATION_USER_NAME:=server}/.ssh/config
    cp /etc/ssh/id_rsa /home/${APPLICATION_USER_NAME:=server}/.ssh/id_rsa
    cp /etc/ssh/id_rsa.pub /home/${APPLICATION_USER_NAME:=server}/.ssh/id_rsa.pub
    chown -R ${APPLICATION_USER:=1000}:${APPLICATION_GROUP:=1000} /home/${APPLICATION_USER_NAME:=server}/.ssh
    chmod 600 /home/${APPLICATION_USER_NAME:=server}/.ssh/id_rsa
fi