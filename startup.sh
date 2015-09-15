#!/bin/bash

#15/9/15 - tested, works!


#################################
#START DIRT: (from start.tidal.4)
#
killall dirt
cd ~/tidal/Dirt
./dirt &
cd ~/git/extramuros


###################################################
# START THE SERVER (to handle data from the webpage
#
#TODO: fix the security issue here ;)
xterm -e node server.js --password disney &


###################################################
# START THE CLIENT (to push the data from the server into tidal)
#
#TODO: fix the security issue here ;)
xterm -e node client.js --server 127.0.0.1 --tidal --feedback --osc-port 8000 --password disney &
