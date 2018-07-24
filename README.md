# Kuemmel

Setup your device with this simple script and a single config file.

## How to

### Config file

In order to run the script you have to create your cyml file. This is a Yaml format.

### Let there be order

At the top of the file is the order of the stages.
The key is a single increasing number with the value being the name of the stage used later on.

```yml
order:
  1: "base"
  2: "docker_cfgs"
  3: "compose"
```

### Stages

There are different types of stages.

Every stage requires a `type` and a `provider` key.

#### Install stage

This stage will add new packages from the package manager or some other source.

The type of this stage is always `install`.

```yml
# Install packages
base:
  type: install
  provider: apt
  packages: "git-core docker"
```

#### Download stage

In this stage you can download/copy files from one location to another.

The type of this stage is always `download`.

This stage type always requires a `from` and a `to` key.

```yml
# Download configs
docker_cfgs:
  type: download
  provider: git
  from: https://git.your-server.com/server/docker-configs.git
  to: /tmp/configs
```

### Providers

Providers are used to support any action you may encounter while setting up your device.

#### Default

Default providers at this time are

- cyml
- apt
- git

#### Custom

In order to create your custom provider take a look at the default providers on how they are built.

### Running the setup

Make sure you have the required providers in the `scripts/` directory.
Run the setup command with your file as the only argument.

```shell
./setup.sh config.cyml
```

## Run on a server

Download this repository to somewhere on the PC you use to configure the new system.

Create a config file as described in [Config file](#config-file).

Transfer the files to your server and open a shell on the remote server.

Run the script as described in [Running the setup](#running-the-setup) where `config.cyml` is the file you just created.

Example:

```bash
git clone https://github.com/christophschlosser/Kuemmel.git # Do this on your local machine
cd Kuemmel
vim config.cyml # Create your config
tar zcf - printers scripts/* setup.sh config.cyml | ssh your-server 'cat - > cfg.tar.gz' # Transfer through SSH using a tar archive
ssh your-server # Now we start working on the remote server
tar xzf cfg.tar.gz # This will extract the required files
./setup.sh config.cyml # Run the config
```

Ofcourse there are many other ways to achieve the same thing but this can be done in less than 10 steps.
