

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