

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