// Drawing tools
// This toolset installs IJ's built-in drawing tools. It supersedes the
// previous macro-based toolset and requires ImageJ 1.47a or later.

// This is a duplicate of the original toolset named "Drawing Tools"
// First four macros are additions to the original toolset.

// Some part were inspired from Jerome Mutterer:
// http://imagej.1557.x6.nabble.com/How-do-I-set-Pencil-Width-Brush-Width-or-Eraser-Width-from-within-a-Java-Plug-in-td3682608.html

// Global variables
var pencilWidth=1,  eraserWidth=10, leftClick=16, alt=8;

macro "ToDraw Action Tool - CfffD11D21D31D41D51D61D71D81D91Da1Db1Dc1Dd1De1Df1D12D22D32D42D52D62D72D82D92Da2Db2Dc2Dd2De2Df2D13D23D33D43D53D63D73D83D93Da3Db3Dc3Dd3De3Df3D14D24D34D44D54D64D74D84D94Da4Db4Dc4Dd4De4Df4D15D25D35D45D55D65D75D85D95Da5Db5Dc5Dd5De5Df5D16D26D36D46D56D66D76D86D96Da6Db6Dc6Dd6De6Df6D17D27D37D47D57D67D77D87D97Da7Db7Dc7Dd7De7Df7D18D28D38D48D58D68D78D88D98Da8Db8Dc8Dd8De8Df8D19D29D39D49D59D69D79D89D99Da9Db9Dc9Dd9De9Df9D1aD2aD3aD4aD5aD6aD7aD8aD9aDaaDbaDcaDdaDeaDfaD1bD2bD3bD4bD5bD6bD7bD8bD9bDabDbbDcbDdbDebDfbD1cD2cD3cD4cD5cD6cD7cD8cD9cDacDbcDccDdcDecDfcD1dD2dD3dD4dD5dD6dD7dD8dD9dDadDbdDcdDddDedDfdD1eD2eD3eD4eD5eD6eD7eD8eD9eDaeDbeDceDdeDeeDfeD1fD2fD3fD4fD5fD6fD7fD8fD9fDafDbfDcfDdfDefDff" {
    setForegroundColor(255, 255, 255);
}
macro "ToErase Action Tool - C000D11D21D31D41D51D61D71D81D91Da1Db1Dc1Dd1De1Df1D12D22D32D42D52D62D72D82D92Da2Db2Dc2Dd2De2Df2D13D23D33D43D53D63D73D83D93Da3Db3Dc3Dd3De3Df3D14D24D34D44D54D64D74D84D94Da4Db4Dc4Dd4De4Df4D15D25D35D45D55D65D75D85D95Da5Db5Dc5Dd5De5Df5D16D26D36D46D56D66D76D86D96Da6Db6Dc6Dd6De6Df6D17D27D37D47D57D67D77D87D97Da7Db7Dc7Dd7De7Df7D18D28D38D48D58D68D78D88D98Da8Db8Dc8Dd8De8Df8D19D29D39D49D59D69D79D89D99Da9Db9Dc9Dd9De9Df9D1aD2aD3aD4aD5aD6aD7aD8aD9aDaaDbaDcaDdaDeaDfaD1bD2bD3bD4bD5bD6bD7bD8bD9bDabDbbDcbDdbDebDfbD1cD2cD3cD4cD5cD6cD7cD8cD9cDacDbcDccDdcDecDfcD1dD2dD3dD4dD5dD6dD7dD8dD9dDadDbdDcdDddDedDfdD1eD2eD3eD4eD5eD6eD7eD8eD9eDaeDbeDceDdeDeeDfeD1fD2fD3fD4fD5fD6fD7fD8fD9fDafDbfDcfDdfDefDff" {
    setForegroundColor(0, 0, 0);
}

macro "DecreaseBrushSize Action Tool - T6e20-" {
    brushWidth = parseInt(call("ij.Prefs.get", "brush.width", 2));
    newBrushWidth = brushWidth - 1;
    if (newBrushWidth < 1) newBrushWidth = 1;
    
    call("ij.Prefs.set", "brush.width", newBrushWidth);
}

macro "IncreaseBrushSize Action Tool - T3f20+" {
    brushWidth = parseInt(call("ij.Prefs.get", "brush.width", 0));

    call("ij.Prefs.set", "brush.width", brushWidth + 1);
}

macro "SwapCompositeView Action Tool - Cb00T0b11CC0b0T7b09oC00bTcb09l" {
    if (!is("composite") || nSlices < 2) {exit("Use Make Composite first...");}
    Stack.getDisplayMode(mode);
    if (mode == "color") {
        Stack.setDisplayMode("composite");
    } else {
        Stack.setDisplayMode("color");
    }
}

macro "Paintbrush Tool - C037La077Ld098L6859L4a2fL2f4fL3f99L5e9bL9b98L6888L5e8dL888c" {
    brushWidth = CollectBrushWidth();
    getCursorLoc(x, y, z, flags);
    if (flags&alt!=0)
        setColorToBackgound();
    draw(brushWidth);
}

macro 'Paintbrush Tool Options...' {
    brushWidth = call("ij.Prefs.get", "brush.width", 1);
    newBrushWidth = getNumber("Brush Width (pixels):", brushWidth);
    call("ij.Prefs.set", "brush.width", newBrushWidth);
}

//macro "Pencil Built-in Tool" {}

//macro "Flood Filler Built-in Tool" {}

// macro "Overlay Brush Built-in Tool" {}

function CollectBrushWidth() {
    // Trying to collect Paintbrush width in prefs
    brushWidth = parseInt(call("ij.Prefs.get", "brush.width", 0));
    //print("Collects brush width: " + brushWidth);
    
    // Set dummy line to get line width if previous fails
    if (brushWidth == 0) {
        makeLine(0,0,1,0);
        brushWidth = getValue("selection.width");
        run("Select None");
        
        //print("Transferred line width to brush width");
    }
    
    // Setting key if not existing
    call("ij.Prefs.set", "brush.width", brushWidth);
    
    return brushWidth;
}

function draw(width) {
    requires("1.32g");
    setupUndo();
    getCursorLoc(x, y, z, flags);
    setLineWidth(width);
    moveTo(x,y);
    x2=-1; y2=-1;
    while (true) {
        getCursorLoc(x, y, z, flags);
        if (flags&leftClick==0) exit();
        if (x!=x2 || y!=y2)
            lineTo(x,y);
        x2=x; y2 =y;
        wait(10);
    }
}

function setColorToBackgound() {
   savep = getPixel(0, 0);
   makeRectangle(0, 0, 1, 1);
   run("Clear");
   background = getPixel(0, 0);
   run("Select None");
   setPixel(0, 0, savep);
   setColor(background);
}