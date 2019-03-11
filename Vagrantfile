# -*- mode: ruby -*-
# vi: set ft=ruby :

$nnscript = <<-SCRIPT
echo "" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "auto enp0s8" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "iface enp0s8 inet dhcp" >> /etc/network/interfaces.d/50-cloud-init.cfg
sudo /etc/init.d/networking restart
sudo apt-get update
sudo apt-get install -y nfs-common
sudo mkdir /shared
sudo chmod 777 /shared
sudo echo "10.11.13.3:/export/shared  /shared  nfs  auto  0  0" >> /etc/fstab
sudo mount -a
sudo apt-get update
sudo apt-get install -y libopenmpi-dev
sudo apt-get install -y openmpi-bin
sudo apt-get install -y openssh-client
sudo apt-get install -y openssh-server
SCRIPT

$nmscript = <<-SCRIPT
echo "" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "auto enp0s8" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "iface enp0s8 inet static" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "address 10.11.13.3" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "gateway 10.11.13.1" >> /etc/network/interfaces.d/50-cloud-init.cfg
echo "netmask 255.255.255.0" >> /etc/network/interfaces.d/50-cloud-init.cfg
sudo /etc/init.d/networking restart ; true
sudo apt-get update
sudo apt-get -y install nfs-kernel-server
sudo mkdir -p /export/shared
sudo mkdir /shared
sudo chmod 777 /{export,shared} && sudo chmod 777 /export/*
sudo mount --bind /shared /export/shared
sudo echo "/export/shared *(rw,fsid=0,insecure,no_subtree_check,async)" >> /etc/exports
sudo service nfs-kernel-server restart
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y haproxy
sudo echo "" >> /etc/haproxy/haproxy.cfg
sudo echo "frontend master" >> /etc/haproxy/haproxy.cfg
sudo echo "  bind 10.11.13.3:3306" >> /etc/haproxy/haproxy.cfg
sudo echo "  mode tcp" >> /etc/haproxy/haproxy.cfg
sudo echo "  option tcplog" >> /etc/haproxy/haproxy.cfg
sudo echo "  default_backend nodes" >> /etc/haproxy/haproxy.cfg
sudo echo "" >> /etc/haproxy/haproxy.cfg
sudo echo "backend nodes" >> /etc/haproxy/haproxy.cfg
sudo echo "  balance roundrobin" >> /etc/haproxy/haproxy.cfg
sudo echo "  mode tcp" >> /etc/haproxy/haproxy.cfg
sudo echo "  server node1 10.11.13.6:3306 check weight 1" >> /etc/haproxy/haproxy.cfg
sudo echo "  server node2 10.11.13.7:3306 check weight 1" >> /etc/haproxy/haproxy.cfg
sudo service haproxy restart
sudo apt-get update
sudo apt-get install -y libopenmpi-dev
sudo apt-get install -y openmpi-bin
sudo apt-get install -y openssh-client
sudo apt-get install -y openssh-server
sudo apt-get install -y make
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "master" do |m|
      m.vm.box = "ubuntu/xenial64"
        m.vm.hostname = "master.localhost"
      m.vm.provider :virtualbox do |vb|
        vb.customize [ 'modifyvm', :id, '--memory', '1500' ]
        vb.customize [ 'modifyvm', :id, '--cpus', '1' ]
        vb.customize [ 'modifyvm', :id, '--name', 'cluster-master' ]
                vb.customize [ "modifyvm", :id, "--nic2", "hostonly" ]
                vb.customize [ "modifyvm", :id, "--hostonlyadapter2", "vboxnet0" ]
      end
        m.vm.provision "shell", inline: $nmscript
  end
  (1..2).each do |i|
    config.vm.define "node#{i}" do |m|
      m.vm.box = "ubuntu/xenial64"
        m.vm.hostname = "node-0#{i}.localhost"
      m.vm.provider :virtualbox do |vb|
        vb.customize [ 'modifyvm', :id, '--memory', '750' ]
        vb.customize [ 'modifyvm', :id, '--cpus', '1' ]
        vb.customize [ 'modifyvm', :id, '--name', "cluster-node-#{i}" ]
                vb.customize [ "modifyvm", :id, "--nic2", "hostonly" ]
                vb.customize [ "modifyvm", :id, "--hostonlyadapter2", "vboxnet0" ]
      end
        m.vm.provision "shell", inline: $nnscript
    end
  end
end


