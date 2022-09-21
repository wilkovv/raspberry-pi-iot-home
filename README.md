# Ansible playbook: Raspberry Pi IoT

Setup Raspberry Pi for use with my home setup. Installs docker for arm64, configures RPi to work with RS485 hat adapter and Zigbee coordinator. Setups automatic backups to USB drive. (Do NOT ever use this playbook on RPi outside of private home network)

Sets up following docker containers with docker-compose:

- Grafana

- Node-Red

- Influxdb

- Zigbee2mqtt

- Mosquitto (mqtt broker)

## Usage

You need to use **pi** user otherwise playbook might not function correctly.

Before starting the playbook make sure **inventory.yml** file is setup correctly. For zigbee2mqtt and serial ports in node-red to work you need to uncomment/modify correctly device mappings in **configs/compose.yml** file.

```shell
# Pulls required roles from ansible-galaxy, run only once
ansible-galaxy install -r requirements.yml

# Setup everything
ansible-playbook main.yml

# Run only docker installation
ansible-playbook main.yml -t docker

# Run only RPi setup
ansible-playbook main.yml -t pi

# Run only backup setup
ansible-playbook main.yml -t backup

# Run RPi and backup setup
ansible-playbook main.yml -t setup
```

## Enabling / Disabling containers on RPi

```shell
sudo docker-compose -f compose.yml up -d
sudo docker-compose -f compose.yml down
```

## Files setup on RPi

```
/home/pi/  
├─ backup.log # Logs from backup script
├─ backup-script.sh # Backup script (launched every week with cron job)
├─ compose.yml # Used with docker compose
├─ docker-volumes/ # Container volumes  
│ ├─ grafana/
│ ├─ node-red/
│ ├─ influxdb2/
│ ├─ zigbee2mqtt/
├─ backups/ # Directory containing up to 5 recent backups
│ ├─ backup1.zip
│ ├─ backup2.zip
│ ├─ backup3.zip
│ ├─ backup4.zip
│ ├─ backup5.zip
```
