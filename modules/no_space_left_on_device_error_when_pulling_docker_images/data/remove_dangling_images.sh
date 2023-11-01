

#!/bin/bash



# Remove dangling docker images

docker images -q --filter "dangling=true" | xargs docker rmi