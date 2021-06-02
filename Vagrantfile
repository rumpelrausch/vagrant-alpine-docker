#############################################
# Set these variables to match your project #
#############################################

$DOCKER_VM_NAME = 'localdocker'
$DOCKER_VM_MEMORY = 2048
$DOCKER_VM_CPU = 2

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
  config.vm.network 'forwarded_port', guest: 80, host: 8980
  config.vm.network 'forwarded_port', guest: 81, host: 8981
  config.vm.network 'forwarded_port', guest: 82, host: 8982
  config.vm.network 'forwarded_port', guest: 83, host: 8983
  config.vm.network 'forwarded_port', guest: 84, host: 8984
  config.vm.network 'forwarded_port', guest: 85, host: 8985

  if ENV['DOCKER_VM_PORTS']
    ports = ENV['DOCKER_VM_PORTS']
    ports.split(",").each do |port|
      config.vm.network 'forwarded_port', guest: port, host: port
    end
  end

  config.vm.synced_folder './src', '/src', disabled: false

  if ENV['DOCKER_VM_MOUNTS']
    mounts = ENV['DOCKER_VM_MOUNTS']
    mounts.split(",").each do |mount|
      config.vm.synced_folder mount, File.basename(mount)
    end
  end

  memory = ENV['DOCKER_VM_MEMORY'] || $DOCKER_VM_MEMORY
  cpus = ENV['DOCKER_VM_CPU'] || $DOCKER_VM_CPU
  name = ENV['DOCKER_VM_NAME'] || $DOCKER_VM_NAME

  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    vb.memory = memory
    vb.name = name
    vb.cpus = cpus
  end
  puts ' ---------------------------------------------------------------------'\
    '-----------------------------------'
  puts '               memory                             name                '\
    '             CPUS               '
  puts ' ---------------------------------------------------------------------'\
    '-----------------------------------'
  puts "                 #{memory}                         #{name}           "\
    "               #{cpus}           "
  puts ' --------------------------------------------------------------------'\
    '------------------------------------'

  config.vm.provision 'shell', env: {"hostname" => $DOCKER_VM_NAME}, inline: "echo $hostname > /etc/hostname && hostname -F /etc/hostname", privileged: true
  config.vm.provision 'shell', path: 'vagrant/setup.sh', privileged: true
end
