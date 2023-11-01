
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# "No space left on device" error when pulling docker images
---

This incident type occurs when attempting to pull a docker image to run a container, but the process fails with an error message stating that there is no space left on the device. This error usually indicates that the disk where the image is being pulled has run out of space. To resolve this issue, the user needs to determine what is taking up the disk space and free up some space. One potential method to identify the files or directories consuming excessive space is to check the /var/log/syslog file.

### Parameters
```shell
export PATH="PLACEHOLDER"

export DIRECTORY_PATH="PLACEHOLDER"

export OUTPUT_FILE_PATH="PLACEHOLDER"

export MAX_SIZE="PLACEHOLDER"
```

## Debug

### Check available space on the device
```shell
df -h
```

### Identify top disk space consumers in the current directory
```shell
du -sh ./* | sort -hr
```

### Identify top disk space consumers in the /var directory
```shell
sudo du -sh /var/* | sort -hr
```

### Check the available inodes on the device
```shell
df -i
```

### Identify the directories with the most inodes in the current directory
```shell
sudo find ${PATH} -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -rn
```

### Check the syslog file for errors
```shell
sudo tail -f /var/log/syslog
```

## Repair

### Identify the files or directories consuming excessive space on the disk by using a disk space analyzer tool like 'ncdu' or running the 'df' command to see the disk usage.
```shell


#!/bin/bash



# set the path to the directory to be analyzed

dir=${DIRECTORY_PATH}



# install ncdu if not already installed

if ! command -v ncdu &> /dev/null

then

    sudo apt-get install ncdu

fi



# run ncdu on the specified directory and output results to a text file

ncdu $dir -o ${OUTPUT_FILE_PATH}


```

### Truncate the /var/log/syslog if the size is large and your containers emit logs
```shell


#!/bin/bash



# Check the size of the /var/log/syslog file

size=$(stat -c%s /var/log/syslog)



# Set the maximum log file size (in bytes)

max_size=${MAX_SIZE}



if [ $size -gt $max_size ]; then

  # Truncate the /var/log/syslog file

  sudo tee /var/log/syslog </dev/null

  echo "The /var/log/syslog file has been truncated."

else

  echo "The /var/log/syslog file is within the maximum size limit of $max_size bytes."

fi


```

### Remove any dangling docker images
```shell


#!/bin/bash



# Remove dangling docker images

docker images -q --filter "dangling=true" | xargs docker rmi


```