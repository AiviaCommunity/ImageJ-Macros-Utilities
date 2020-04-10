// -------------------------------------------------------------------
// Written by: Patrice Mascalchi, DRVision
// Date: 2020-04
// Contact: patricem [at] drvtechnologies.com
// -------------------------------------------------------------------

// v1.0: - Expects all stacks (single dimension) to be opened before running the macro
//       - Images are converted to RGB to keep the current display for all FOV
// v2.0: - Allows choosing image for each FOV space in montage // allows choosing an image multiple times

borderSize = 2;
setBatchMode(true);

rows = 2;
columns = 3;
imgList = getList("image.titles");

// Pick images to show
Dialog.create("Select opened images for montage");
for (i=0; i<imgList.length; i++) {
    Dialog.addCheckbox(imgList[i], true);
    if (nImages > 10) {if (i%2 == 0) Dialog.addToSameRow();}
}
Dialog.addMessage(" ");
Dialog.addMessage(" ");
Dialog.addSlider("Rows in montage", 1, 8, rows);
Dialog.addSlider("Columns in montage", 1, 10, columns);
Dialog.show();

selectedImg = newArray(imgList.length);
maxn = 0;
for (i=0; i<imgList.length; i++) {
    if (Dialog.getCheckbox()) {
        selectedImg[maxn] = imgList[i];
        maxn++;
    }
}
selectedImg = Array.trim(selectedImg, maxn);
rows = Dialog.getNumber();
columns = Dialog.getNumber();

// Checking image list
if (maxn == 0) exit("No images selected. Macro will end.");

// Get info from first image and create empty FOV
selectWindow(selectedImg[0]);
refDim = nSlices();
refWi = getWidth();
refHe = getHeight();
for (i=1; i<maxn; i++) {
    selectWindow(selectedImg[i]);
    if (refDim != nSlices() || refWi != getWidth() || refHe != getHeight()) exit("Following image doesn't have same dimensions as first image...\n"+ selectedImg[i]);
}

// Define montage scheme
n = rows*columns;
emptyLbl = newArray("emptyFOV.tif");
imgChoices = Array.concat(emptyLbl, selectedImg);

montageImg = newArray(n);
Dialog.create("Define montage layout");
for (i=0; i<n; i++) {
    Dialog.addChoice("R"+ floor(i/columns)+1 +"C"+ ((i%columns)+1), imgChoices);
    if (rows > 1) {if (i%columns < (columns-1)) Dialog.addToSameRow();}
}
Dialog.show();

for (i=0; i<n; i++) montageImg[i] = Dialog.getChoice();

run("Text Window...", "name=ProgressInfo width=60 height=3");

// create empty FOV
refBit = "RGB";
newImage("emptyFOV.tif", refBit +" black", refWi, refHe, 1);

// Prepare images = convert to RGB
for (i=0; i<n; i++) {
    if (montageImg[i] != "emptyFOV.tif") {
        selectWindow(montageImg[i]);
        run("Duplicate...", "title=TEMP-DUP-"+ i +" duplicate");
        run("RGB Color");
        montageImg[i] = getTitle();
    }
}

// Create montage for each timepoint
for (t=0; t<refDim; t++) {
    print("[ProgressInfo]", "\\Update:Processing timepoint: "+ t+1);
    for (i=0; i<n; i++) {
        if (montageImg[i] != "emptyFOV.tif") {
            selectWindow(montageImg[i]);
            run("Duplicate...", "title=TEMP-IMG-"+ IJ.pad(i, 3) +".tif duplicate range="+ t+1 +"-"+ t+1);
        } else {
            selectWindow("emptyFOV.tif");
            run("Duplicate...", "title=TEMP-IMG-"+ IJ.pad(i, 3) +".tif duplicate");
        }
    }
        //waitForUser(t);             // For tests ONLY
    run("Images to Stack", "name=TEMP-TP.tif title=TEMP-IMG- use");
    run("Make Montage...", "columns="+ columns +" rows="+ rows +" scale=1 border="+ borderSize +"  use");
    rename("TEMP-MONTAGE-"+ IJ.pad(t, 3) +".tif");
    
    wait(20);
    selectWindow("TEMP-TP.tif");
    close();
}

run("Images to Stack", "name=Final-Montage-Border"+ borderSize +"px.tif title=TEMP-MONTAGE- use");

// Close all RGB duplicates
for (i=0; i<n; i++) {
    close(montageImg[i]);
    wait(100);
}

setBatchMode(false);