# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'puppetlabs/centos-7.0-64-nocm'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #config.vm.network "forwarded_port", guest: 389, host: 8389

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.provision 'shell' do |s|
    s.inline = <<-EOS.gsub(/^ +/, '')
      rpm -Uvh http://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-0.9.2-1.el7.noarch.rpm
      yum -y install puppet-agent

      cat >/etc/profile.d/puppet.sh <<-'EOF'
        export PATH=$PATH:/opt/puppetlabs/bin
      EOF
    EOS
  end

  #config.vm.provision 'puppet' do |puppet|
  #  puppet.manifests_path = 'manifests'
  #  puppet.manifest_file  = 'site.pp'
  #  puppet.module_path    = 'modules'
  #end

  # Hack until Vagrant supports Puppet 4.x
  config.vm.provision 'shell' do |s|
    s.inline = 'puppet apply --modulepath /vagrant/modules /vagrant/manifests/site.pp'
  end

  config.vm.provision 'shell' do |s|
    s.inline = <<-EOS.gsub(/^ +/, '')
      ldapadd -Y EXTERNAL -H ldapi:/// -f /vagrant/test.ldif
    EOS
  end
end
