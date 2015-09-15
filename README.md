#extramuros - language-neutral shared-buffer networked live coding system

##Quick start:

run the script: 

```
sh start.sh
```

This script starts dirt, server and client for tidal


##Slow Start



See install-osx.md and install-win.md for installation instructions.  See this document for usage.

The big picture: This is software for collaborative live coding.  On one machine, you run an extramuros "server".  Then, from as many machines as you like, you use a web browser to connect to the server and code into shared text buffers.  Finally, and again from as many machines as you like, your run the extramuros "client" code in order to receive code from the server and pipe it to the language interpreter of your choice (SuperCollider, Tidal, etc).  Think of the "client" code as a way for machines to listen in on a public stream of code.

The connections between the web browsers, the server, and the client are structured to make it easier to do collaborative live coding across various firewalls, institutional networks, etc.  Both the web browser and the client are making "outbound" TCP connections to the server.  So long as the server is generally reachable you don't have to worry about the web browsers and clients being firewalled.  (Moreover: This type of collaborative live coding is also robust to bandwidth challenges as it generally just involves sending small bits of text back and forth.)   

To launch a server (only one person in a collaborative performance group needs to do this) - and assuming extramuros has been cloned/downloaded to your user folder:
```
cd ~/extramuros
node server.js --password insertFunnyPasswordHere
```

To verify that the server is running, point your browser to the IP address of the server and port 8000.  If the server is not running on your local machine, replace 127.0.0.1 with the actual address of the server in the following (and in all subsequent examples):
```
http://127.0.0.1:8000
```

To launch a test client just to verify that you can listen in on the code as people click "eval" in the browser.  (note: If you already have a server in one terminal window it is convenient to launch the client in a second terminal window):
```
cd ~/extramuros
node client.js --server 127.0.0.1
```

To test, enter some code into the text buffers in the web browser, make sure you have entered the funny password you chose (forgetting to enter the password in the browser window is a common mistake) and click "eval".  If everything is working, you should see the code from the browser appear in the terminal where you launched node client.js.  By the way, you can terminate the client (or server) by pressing Ctrl-C twice in the relevant terminal window.

If that test worked, you're ready to launch a client piped into a language interpreter.  Here's a slightly abstract example of what that would look like: 
```
cd ~/extramuros
node client.js --server 127.0.0.1 | pathToYourFavouriteInterpreter
```

For SuperCollider, one strategy is to pipe the text to sclang.  This is an example using a default SC installation on OSX (and assuming extramuros has been cloned into your user folder).  We use the --newlines-to-spaces option so that line breaks in the browser will become spaces in the code sent to SuperCollider, allowing you to stretch expressions over multiple lines.  Note that you won't have cmd-period to interrupt your SC synths, so it's helpful to have other ways of stopping/freeing things:
```
cd /Applications/SuperCollider/SuperCollider.app/Contents/Resources/ 
node ~/extramuros/client.js --server 127.0.0.1 --newlines-to-spaces | ./sclang
```

You can also use short options, in which case the last line of the preceding example would be as follows:
```
node ~/extramuros/client.js -s 127.0.0.1 -n | ./sclang
```

You can send arbitrary OSC messages to the client and they will arrive at all browsers as calls to JavaScript functions with the same name as the OSC address (i.e. "/amp 0.5" becomes the call amp(0.5);). To activate this function on the client use the osc-port option AND specify the password (anything that sends things to the server needs a password!):
```
cd ~/extramuros
node client.js --server 127.0.0.1 --osc-port 8000 --password yourFunnyPasswordHere| ./sclang
```

Another command-line option launches Tidal as a sub-process of the client.  Note that the extramuros distribution includes a file .ghci which helps establish a useful working environment for Tidal, and that because of this you should probably be in the extramuros folder when you start the client for Tidal:
```
cd ~/extramuros
node client.js --server 127.0.0.1 --tidal
```

In addition to being more convenient than the command-line pipes used above with SuperCollider, this option also allows for feedback from a client to reach the server and thus be displayed in the browser windows:
```
cd ~/extramuros
node client.js --server 127.0.0.1 --tidal --feedback
```

To really get cooking with extramuros and Tidal, activate the osc-port option as well.  You'll have feedback from the ghci/Tidal interpreter AND the browser will receive JavaScript function calls when Tidal notes/events happen:
```
cd ~/extramuros
node client.js --server 127.0.0.1 --tidal --feedback --osc-port 8000 --password yourFunnyPassword
```

Now in the web browser, enter some code, make sure you have entered the correct password, and click "eval".  Not only should you see the evaluated code in the terminal - hopefully you will also hear it's effect!  

There are a number of keyboard short cuts:
- Shift-Enter: evaluate code through the server (i.e. Tidal or SuperCollider code)
- Ctrl-Shift-Enter: evaluate JavaScript code on all browsers 
- Ctrl-Enter: evaluate JavaScript code on only this browser
- Ctrl-Shift-C: clear the JavaScript canvas on all browsers
- Alt-C: clear the JavaScript canvas on this browser only
- Ctrl-Shift-R: restart animation if it has crashed, on all browsers
- Alt-R: restart animation it it has crashed, on this browser only

For more information about JavaScript visuals/animation in extramuros, see the document visualizationexamples.md.

All of this is rough, unfriendly and probably even mistaken in some cases. So let's all help make it better!...

-d0kt0r0 (aka David Ogborn)

PS: thanks to the following people for contributing to extramuros in various ways (additions, fixes, testing, championing, etc): Holger Ballweg, Alexandra Cárdenas, Ian Jarvis, Alex McLean, Ashley Sagar, Eldad Tsabary, Scott Wilson and anyone else who should be named here (submit a pull request...)
