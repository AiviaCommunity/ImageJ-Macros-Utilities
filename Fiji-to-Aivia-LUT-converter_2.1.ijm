// -------------------------------------------------------------------
// Written by: Patrice Mascalchi, Leica Microsystems
// Date: 2021-12
// Contact: patrice.mascalchi [at] leica-microsystems.com
// -------------------------------------------------------------------

// Generate a file as Aivia software format for custom LUT coloring.
// Prerequisite: Fiji version, "NeuroCyto LUTs" update site selected.

// v2.0: - includes a randomizer (for labelled mask, such as Aivia or StarDist output)
// v2.1: - Specific script for Fiji, generating all LUT as a preview. User selects the one of interest
// -------------------------------------------------------------------

// Generates the previewing stack of LUTs
newImage("Temp-Image-For-LUTs.tif", "8-bit ramp", 1024, 100, 1);
run("Test LUTs");

// Check stack is generated
if (getInfo("window.title") != "Temp-Image-For-LUTs.tif-LUTs") {
	exit("LUT list was not created. Check that NeuroCyto LUTs package is ticked in the update sites.");
}

rename("Temp-STK-For-LUTs.tif");
close("Temp-Image-For-LUTs.tif");

// Let the user choose the one of interest
waitForUser("Select the LUT to convert and press OK");

// Collecting channel name = LUT name
selectWindow("Temp-STK-For-LUTs.tif");
na = getInfo("slice.label");

endCol = getBoolean("Do you want to replace last color by white?");
doRand = getBoolean("Do you want to randomize colors?");

// Resizing scale to 256 pixels
run("Scale...", "x=- y=- width=256 interpolation=Bilinear average create");
rename("Temp-Final-LUT-to-convert.tif");
close("Temp-STK-For-LUTs.tif");

nLev = getWidth();
run("Text Window...", "name="+na+" width=20 height=50");
print("["+na+"]", "\"" + na +"\"\n");

selectWindow("Temp-Final-LUT-to-convert.tif");

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

close("Temp-Final-LUT-to-convert.tif");

// --- functions -----------------------------

function padMe(txt, nb) {
    while (lengthOf(txt) < nb) txt = "0" + txt;
    return txt;
}

// returns a random number, 0 <= k < n
function randomInt(n) {
   return n * random();
}