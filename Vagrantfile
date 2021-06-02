#############################################
#############################################
#############################################

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.env.enable
  config.vbguest.auto_update = false
  config.vm.box = 'generic/alpine312'

  if ENV['VM_PORTS']
    ports = ENV['VM_PORTS']
    ports.split(",").each do |portConfig|
      portConfig = portConfig.split(':')
      config.vm.network 'forwarded_port', guest: portConfig.first, host: portConfig.last
    end
  end

  if ENV['VM_MOUNTS']
    mounts = ENV['VM_MOUNTS']
    mounts.split(",").each do |mount|
      config.vm.synced_folder mount, '/mnt/host/' + File.basename(mount), nfs:true
    end
  end

  portString = +ports
  portString.gsub!(/,/, "  ")
  portString.gsub!(/:/, "<-")

  memory = ENV['VM_MEMORY'] || 1024
  name = ENV['VM_NAME'] || 'vagrant_alpine'
  cpus = ENV['VM_CPUS'] || 2


  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    vb.memory = memory
    vb.name = name
    vb.cpus = cpus

    # change the network card hardware for better performance
    vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]

    # suggested fix for slow network performance
    # see https://github.com/mitchellh/vagrant/issues/1807
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  if ARGV.include?("up")
    puts '------------------------------------------------------'
    puts "         memory:  #{memory}"
    puts "           CPUs:  #{cpus}"
    puts "   box/hostname:  #{name}"
    puts "   port forward:  #{portString}"
    puts " shared folders:  #{mounts}"
    puts '------------------------------------------------------'
    puts '--- Shared folders are mounted under /mnt/host -------'
    puts '------------------------------------------------------'
  end

  if ARGV.include?("destroy")
    puts '-- DESTROY -------------------------------------------'
    puts "   box/hostname:  #{name}"
    puts '------------------------------------------------------'
  end

  config.vm.provision 'shell', inline: "echo #{name} > /etc/hostname && hostname -F /etc/hostname", privileged: true
  config.vm.provision 'shell', path: 'vagrant/setup.sh', privileged: true
  if ENV['VM_PROVISIONSCRIPTS']
    provisionScriptList = ENV['VM_PROVISIONSCRIPTS']
    provisionScriptList.split(',').each do |provisionScript|
      config.vm.provision 'shell', path: provisionScript, privileged: false
    end
  end
end
