#############################################
#############################################
#############################################

required_plugins = %w( vagrant-env )
didInstall = false
required_plugins.each do |plugin|
  next if Vagrant.has_plugin? plugin
  didInstall = true
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

if didInstall
  puts('Plugins are installed.')
  abort('Please run vagrant again.')
end

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.env.enable

  memory = ENV['VM_MEMORY'] || 1024
  name = ENV['VM_NAME'] || 'vagrant_alpine'
  cpus = ENV['VM_CPUS'] || 2
  mountdir = ENV['VM_GUEST_MOUNTDIR'] || '/home/vagrant'

  config.vm.define name
  config.vm.box = 'generic/alpine312'
  config.ssh.insert_key = false

  if ENV['VM_PORTS']
    ports = ENV['VM_PORTS'] || ''
    ports.split(",").each do |portConfig|
      portConfig = portConfig.split(':')
      config.vm.network 'forwarded_port', guest: portConfig.last, host: portConfig.first
    end
  end

  if ENV['VM_MOUNTS']
    mounts = ENV['VM_MOUNTS']
    mounts.split(",").each do |mount|
      config.vm.synced_folder mount, mountdir + '/' + File.basename(mount), nfs:false
    end
  end

  portString = ports.dup
  portString.gsub!(/,/, "  ")
  portString.gsub!(/:/, "->")

  if ENV['VM_PROVIDER'] == "virtualbox"
    # This does currently not work with hyperv
    config.vm.hostname = name
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
  end

  if ENV['VM_PROVIDER'] == "hyperv"
    config.vm.provider 'hyperv' do |hv|

      # vb.maxmemory = memory
      hv.memory = memory
      hv.vmname = name
      hv.cpus = cpus

      hv.vm_integration_services = {
        guest_service_interface: true
      }
    end
  end

  if ARGV.include?("up")
    puts ''
    puts '------------------------------------------------------'
    puts "          image:  #{config.vm.box}"
    puts "         memory:  #{memory} MB"
    puts "           CPUs:  #{cpus}"
    puts "   box/hostname:  #{name}"
    puts "   port forward:  #{portString}"
    puts " shared folders:  #{mounts}"
    puts '------------------------------------------------------'
    puts "--- Shared folders are mounted under #{mountdir}"
    puts '------------------------------------------------------'
    puts ''
    print 'Hit [ENTER] to continue or CTRL-C to abort => '
    STDIN.gets
  end

  if ARGV.include?("destroy")
    puts '-- DESTROY -------------------------------------------'
    puts "   box/hostname:  #{name}"
    puts '------------------------------------------------------'
  end

  config.vm.provision 'shell', inline: "echo #{name} > /etc/hostname && hostname -F /etc/hostname", privileged: true
  #config.vm.provision 'shell', path: 'vagrant/setup.sh', privileged: true
  if ENV['VM_PROVISIONSCRIPTS']
    provisionScriptList = ENV['VM_PROVISIONSCRIPTS']
    provisionScriptList.split(',').each do |provisionScript|
      config.vm.provision 'shell', path: provisionScript, privileged: true
    end
  end
end
