#!/bin/bash

# Create the directory needed to run the sshd daemon
mkdir /var/run/sshd 

# Add docker user and generate a random password with 12 characters that includes at least one capital letter and number.
DOCKER_PASSWORD=`pwgen -c -n -1 12`
echo User: docker Password: $DOCKER_PASSWORD
DOCKER_ENCRYPYTED_PASSWORD=`perl -e 'print crypt('"$DOCKER_PASSWORD"', "aa"),"\n"'`
useradd -m -d /home/docker -p $DOCKER_ENCRYPYTED_PASSWORD docker
sed -Ei 's/adm:x:4:/docker:x:4:docker/' /etc/group
adduser docker sudo
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbujTRkE1kxl1UR3O/7kV7vlYjo10WibtEy5kCgNlXLWlEeeuGlUuRTUJ0ZGdLqIROMSpQQx8s54nQj1trIYpj5kVYrNeR70sihStVi0o+03NIl51GQKVeF6n1WDMJljrbyI3mMZnrEV02zHh+IDL9jxomLRSUeodG08qCPcP3TxRuPDWHI3ij5B6+A+nk9gr/sRWLP6X5xfaj9f/Rx1a6Gfu/O0g3Fk3BWPbNNIfYatqPAOq63T9sCUNeQC8Mno6nW2yaC5iWFWRwG/57f6vxH51cl1sc8BMVT/ZWZJXbatLEZVToolgXCOmrJ9iNoMP+Vu5W37qFQJp52YSOgr15 root@frank-pc" > /home/docker/.ssh/authorized_keys

# Set the default shell as bash for docker user.
chsh -s /bin/bash docker

# Copy the config files into the docker directory
cd /src/config/ && sudo -u docker cp -R .[a-z]* [a-z]* /home/docker/

# restarts the xdm service
/etc/init.d/xdm restart

# Start the ssh service
/usr/sbin/sshd -D
