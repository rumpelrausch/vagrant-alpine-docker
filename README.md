# Vagrant - alpine - docker
A vagrant environment for booting a docker machine **under Windows**.

## Prerequisites
- vagrant >= 2.1  
  (Tested with V2.2.16)
- [optional] PuTTY
- Virtualisation platform, either  
  `VirtualBox` or `Hyper-V`

## Installation
  1. Open a cmd/powershell/bash console.  
     Creation of a Hyper-V box will need **admin privileges**
     which have to be set for the whole console.  
     With VirtualBox this is not neccesary from the beginning,
     but you will be asked for admin rights later on.
  2. Create a `.env` file from `.env.example`.  
     All configuration variables are described there.
  3. Run `vagrant up`.

## Additional guest scripts
The environment variable `VM_PROVISIONSCRIPTS`
(see `.env.example`) allows for later registration of
provisioning scripts.

After registration of new provisioning scripts run
`vagrant provision`. This will run all scripts configured via
`VM_PROVISIONSCRIPTS`.

## Shared folders
(see `.env.example`)  
Folder sharing can be used to combine this vagrant solution
with a real docker service in one source repository.  
In the example configuration the folder `./src` is shared into
the box. It could contain files for service creation (the
box contains `docker-compose`) and files shared from the box
into docker containers/services, e.g. a web solution.

Vagrant takes care to share the folder with the best possible
technology. Under Windows the "safe fallback" is using `CIFS`
(aka `SMB`). If NFS is installed it will be used as the more
performant solution.

## Box contents
- Alpine Linux 64Bit
  - ash
  - bash
  - docker
    - docker-compose
    - docker swarm

## Network configuration
The box's IP address can automatically be written into the
local hosts file (see `.env.example`). The hostname
is set to "`VM_NAME`.local".

### Virtualbox
The environment variable `VM_PORTS` defines the forwarded ports
from the box to the local host system.

### Hyper-V
Vagrant/Hyperv does not support port forwarding. All published
ports from within the box are reachable under the box's IP
address (which can be resolved vie the local hosts file).

Example:
- `VM_NAME` is set to "docker".
- The box runs a container/service listening on port `8080`.
- The container/service is reachable from the host machine
  under `docker.local:8080`.
- Using Virtualbox:
  - The forwarding is defined as "8980:8080".
  - The container/service is reachable from the host machine
  under `localhost:8980`.

## Fast SSH access
Upon "`vagrant up`" or "`vagrant provision`" two helper batch files
are created:
- login_ssh.bat
- login_putty.bat

They allow for quick SSH access into the box (much faster than
`vagrant ssh`).
