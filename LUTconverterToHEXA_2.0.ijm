// -------------------------------------------------------------------
// Written by: Patrice Mascalchi, DRVision
// Date: 2020-06
// Contact: patricem [at] drvtechnologies.com
// -------------------------------------------------------------------

// Generate a file as Aivia software format for custom LUT coloring.
// Important: input LUT image is expected to have an horizontal gradient.
// Final color coding is done on 256 levels as a maximum.

// v2.0: - includes a randomizer (for labelled mask, such as Aivia or StarDist output)
// -------------------------------------------------------------------

if (bitDepth() != 24) exit("LUT image should be RGB");

// Resize LUT image if more than 256 levels
if (getWidth() > 256) {
    run("Scale...", "x=- y=- width=256 interpolation=Bilinear average create");
}
im = getTitle();

na = getString("Name of your custom LUT mapping", "Custom");
endCol = getBoolean("Do you want to replace last color by white?");
doRand = getBoolean("Do you want to randomize colors?");

nLev = getWidth();
run("Text Window...", "name="+na+" width=20 height=50");
print("["+na+"]", "\"" + na +"\"\n");

selectWindow(im);

gradCol = newArray(nLev);
for (n=0; n<nLev; n++) {
    lev = round(n / (nLev-1) * 255);
    
        //waitForUser(n +": "+ lev);
    pix = getPixel(n, 1);           //waitForUser("pix: "+ pix);
    hexCol = toHex(pix);            //waitForUser("hexCol: "+ hexCol);
    hexColF = padMe(hexCol, 6);     //waitForUser("hexColF: "+ hexColF);
    if (lengthOf(hexColF) > 6) hexColF = substring(hexColF, 2);

    // For last color
    if (lev==255 && endCol) hexColF = "ffffff";

    gradCol[n] = toUpperCase(hexColF);
}

// randomize
if (doRand) {
    i = gradCol.length;  // The number of items left to shuffle (loop invariant).
    while (i > 1) {
        k = randomInt(i);     // 0 <= k < i.
        i--;                  // i is now the last pertinent index;
        temp = gradCol[i];  // swap gradCol[i] with gradCol[k] (does nothing if k==i).
        gradCol[i] = gradCol[k];
        gradCol[k] = temp;
   }
}

// option to replace last color with white if not done before
if (lev<255 && endCol) print("["+na+"]", "100 FFFFFF");

// print final values
for (n=0; n<nLev; n++) {
    lev = round(n / (nLev-1) * 255);
    prefix = ""+ lev + " ";
    print("["+na+"]", prefix + gradCol[n] +"\n");
}

selectWindow(na);

// --- functions -----------------------------

function padMe(txt, nb) {
    while (lengthOf(txt) < nb) txt = "0" + txt;
    return txt;
}

// returns a random number, 0 <= k < n
function randomInt(n) {
   return n * random();
}
