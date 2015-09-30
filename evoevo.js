

/* EVOLUTIONARY ALGORITHMS FOR LIVE CODING */


var popsize = 50;

var grammar;s

function makeTidalGrammar(){


    /* See patternlibgrammar.md for a description of this grammar */


}




function generateTidal(channel){

    //TODO: randomly pick a channel to assign things to
    if(typeof channel == "undefined")
        channel = 1;

    return 'd'+channel+'$ sound "bd sn sn hh bd"' 


}




function pullBuffer(ebox){

    //TODO: Should pull a genome from the population
    pattern = generateTidal()

    //Write what's happening in the notification area:


    //Write the pattern to ebox:     


    //Finally push the pattern to the server:
    evaluateBuffer(ebox);

}
