#!/bin/bash

# SSH config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i '/127.0.1.1/d' /etc/hosts >& /dev/null
systemctl restart sshd

SSH_PUBLIC_KEY=/vagrant/provisioning/id_rsa.pub
USER_DIR=/home/vagrant/.ssh

if [[ "$HOSTNAME" == *"-master" ]]; then
	mkdir -p /etc/ansible
	cp /vagrant/ansible.inventory /etc/ansible/hosts
	cp /vagrant/provisioning/ansible.cfg /etc/ansible
	chmod 0644 /etc/ansible/hosts
	chmod 0644 /etc/ansible/ansible.cfg

	if [ ! -f $USER_DIR/id_rsa.pub ]; then
		# Create ssh keys
		echo -e 'y\n' | sudo -u vagrant ssh-keygen -t rsa -f $USER_DIR/id_rsa -q -N ''
	fi

	if [ ! -f $USER_DIR/id_rsa.pub ]; then
		echo "SSH public key could not be created"
		exit -1
	fi

	chown vagrant:vagrant $USER_DIR/id_rsa*

	if [ -f $SSH_PUBLIC_KEY ]; then
		rm $SSH_PUBLIC_KEY >& /dev/null
	fi

	cp $USER_DIR/id_rsa.pub /vagrant/provisioning
fi

if [ ! -f $SSH_PUBLIC_KEY ]; then
	echo "SSH public key does not exist"
	exit -1
fi

sed -i "/-aisi/d" $USER_DIR/authorized_keys >& /dev/null
cat $SSH_PUBLIC_KEY >> $USER_DIR/authorized_keys
chown vagrant:vagrant $USER_DIR/authorized_keys
chmod 0600 $USER_DIR/authorized_keys