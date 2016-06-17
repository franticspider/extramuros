#!/bin/bash

#15/9/15 - tested, works!


#################################
#START DIRT: (from start.tidal.4)
#
killall dirt
cd ~/tidal/Dirt
./dirt &
cd ~/git/extramuros

sleep 10
###################################################
# START THE SERVER (to handle data from the webpage
#
#TODO: fix the security issue here ;)
xterm -e node server.js --password disney &

sleep 10
###################################################
# START THE CLIENT (to push the data from the server into tidal)
#
#TODO: fix the security issue here ;)
xterm -e node client.js --server 127.0.0.1 --tidal --feedback --osc-port 8000 --password disney &


sleep 10
#######################################################
# START THE PARSER SERVER (to generate legal mutations)
#

xterm -e ~/localtomcat/bin/catalina.sh run &



sleep 10
#######################################################
# Open the browser:
#
echo "All done! pointing your browser at http://sjh-evotop:8000/jqtest.html"
echo "password is 'disney'"
google-chrome http://sjh-evotop:8000/jqtest.html
