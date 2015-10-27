
Searching for handlers of the eval message

Not in misc.js

#writing directly to the sharejs documents. 

see https://github.com/share/ShareJS/wiki/Client-API

rather than trigger events via the textarea, we can use the doc del() and insert() commands to do it directly. 

afaict, the sharejs documents have the SAME NAME as the text areas in extramuros (elem1, elem2 
- wrong! in index.html, the text areas are called 'edit1', 'edit2' etc. 

in browser.js, 'evaluateBuffer' sends 'edit1' etc. as variable in bufferName in a json message with 
request: "eval", bufferName: name, password: password 

this structure is picked up in server.js (I think) in the wss.on() function - in the 'eval' option, there's a call to ANOTHER evaluateBuffer function (this time on the server side) 


...actually, that's not right, becuase the data is shared across clients without pressing the 'eval' button. It's more something to do with textarea.js - this seems to use a coffeescript to pass all changes. 

In the end I was able to fix this bu issuing 
				             edit_box.trigger('textInput');
after modifying the text box - this event was handled by share, so the new text was then incorporated into the document
