// -------------------------------------------------------------------
// by: Patrice Mascalchi
// Date: 2020-07
// Location: DRVision Technologies, France
// Contact: p.mascalchi@gmail.com
// -------------------------------------------------------------------

var pmCmds = newMenu("Popup Menu",
	newArray("Help...", "Rename...", "Duplicate...", "Original Scale",
	"Paste Control...", "Revert", "-", "Record...", "Capture Screen ", "Copy to System", "Monitor Memory...",
	"Find Commands...", "Control Panel..."));

macro "Popup Menu" {
	cmd = getArgument();
	if (cmd=="Help...")
		showMessage("About Popup Menu",
			"To customize this menu, edit the line that starts with\n\"var pmCmds\" in ImageJ/macros/StartupMacros.txt.");
	else
		run(cmd);
}

macro "SaveTiff Action Tool - Cb00D11D21D31D41D51D61D71D81D91Da1Db1Dc1Dd1De1Df1D12Df2D13D33D43D53D63D73D83D93Da3Db3Dc3Dd3Df3D14D34Dd4Df4D15D35Dd5Df5D16D36Dd6Df6D17D37D47D57D67D77D87D97Da7Db7Dc7Dd7Df7D18Df8D19D39D49D59D79D99Da9Dc9Dd9Df9D1aD4aD7aD9aDcaDfaD1bD4bD7bD9bDabDcbDdbDfbD1cD4cD7cD9cDccDfcD1dD4dD7dD9dDcdDfdD1eDfeD1fD2fD3fD4fD5fD6fD7fD8fD9fDafDbfDcfDdfDefDff" {
	t = getTitle();
	if (nSlices==1) {
		/*run("Flatten");		// to take the overlay in account
		t2 = getTitle();
		closeWin(t);
		selectWindow(t2);
		rename(t);*/
		run("Tiff...");
	} else {
		//run("Duplicate", "title="+t+"_s.tif");
		chR=false;
		slR=false;
		frR=false;
		getDimensions(wi, he, ch, sl, fr);
		Dialog.create("Save to individual files?");
		if (ch>1) Dialog.addCheckbox("separate channels?", false);
		if (sl>1) Dialog.addCheckbox("separate z-slices?", false);
		if (fr>1) Dialog.addCheckbox("separate timepoints?", false);
		Dialog.show();
		if (ch>1) chR = Dialog.getCheckbox();
		if (sl>1) slR = Dialog.getCheckbox();
		if (fr>1) frR = Dialog.getCheckbox();

		if (chR && slR && frR) {
			run("Image Sequence... ", "format=TIFF name="+t+" digits=3");
			exit;
		}
		if (!chR && !slR && !frR) {
			run("Tiff...");
			exit;
		}		

		// Export folder
		if (chR || slR || frR) path = getDirectory("Choose the directory to save the individual files");

		if (chR) {chnb = ch;} else {chnb = 1;}
		if (slR) {slnb = sl;} else {slnb = 1;}
		if (frR) {frnb = fr;} else {frnb = 1;}
		extC = "";
		extS = "";
		extF = "";
	
		for (c=1;c<=chnb;c++) {
			for (s=1;s<=slnb;s++) {
				ss = ""+s;
				while (lengthOf(ss)<3) ss = "0"+ss;
				for (f=1;f<=frnb;f++) {
					ff = ""+f;
					while (lengthOf(ff)<4) ff = "0"+ff;

					if (chR) {nch = c;} else {nch = "1-"+ch;}
					if (slR) {nsl = s;} else {nsl = "1-"+sl;}
					if (frR) {nfr = f;} else {nfr = "1-"+fr;}
					run("Make Substack...", "channels="+nch+" slices="+nsl+" frames="+nfr);
					
					if (chR) {nch = 1;} else {nch = ch;}
					if (slR) {nsl = 1;} else {nsl = sl;}
					if (frR) {nfr = 1;} else {nfr = fr;}					
					if (nSlices>1) run("Stack to Hyperstack...", "order=xyczt(default) channels="+nch+" slices="+nsl+" frames="+nfr+" display=Color");
					if (nSlices==1 && slR && frR) resetMinAndMax();

					if (chR) extC = "_C"+c;
					if (slR) extS = "_S"+ss;
					if (frR) extF = "_Fr"+ff;
					saveAs("tiff", path+t+extC+extS+extF);
					close;
				}
			}		
		}
			
	} // end if nSlices==1
}

macro "SaveJpeg Action Tool - Cfb8D11D21D31D41D51D61D71D81D91Da1Db1Dc1Dd1De1Df1D12Df2D13D33D43D53D63D73D83D93Da3Db3Dc3Dd3Df3D14D34Dd4Df4D15D35Dd5Df5D16D36Dd6Df6D17D37D47D57D67D77D87D97Da7Db7Dc7Dd7Df7D18Df8D19D39D49D59D79D89D99Db9Dc9Dd9Df9D1aD4aD7aD9aDbaDfaD1bD4bD7bD8bD9bDbbDdbDfbD1cD4cD7cDbcDdcDfcD1dD3dD4dD7dDbdDcdDddDfdD1eDfeD1fD2fD3fD4fD5fD6fD7fD8fD9fDafDbfDcfDdfDefDff" {run("Jpeg...");}

macro "CopyToSystem Action Tool - C555D00D10D20D30D40D50D01D51D61D02C58cD22D32D42C555D52D72D03D53D63D73D83D04D84D05C58cD25D35D45D55D65C555D75D85D95Da5Db5Dc5D06D76Dc6Dd6D07D77C58cD97Da7Db7C555Dc7De7D08C58cD28D38D48D58D68C555D78Dc8Dd8De8Df8D09D79Df9D0aD1aD2aD3aD4aD5aD6aD7aC58cD9aDaaDbaDcaDdaC555DfaD7bDfbD7cDfcD7dC58cD9dDadDbdDcdDddC555DfdD7eDfeD7fD8fD9fDafDbfDcfDdfDefDff" {
	run("Flatten");
	t = getTitle;
	if (getHeight > 800 || getWidth > 800) run("Size...", "width=800 height=800 constrain interpolation=Bicubic");
	run("Copy to System");
	closeWin(t);
}

var colCmds = newMenu("Colour Menu Tool",
newArray("Colour", "Composite", "-", "Make Composite", "-", "Blue", "Green", "Red", "Yellow", "-", "Glow Leica", "Grays", "All Grays", "HiLo", "-", "Merge", "Merge at end"));

macro "Colour Menu Tool - Cb00T0b11CC0b0T8b08OC00bTeb08L" {
	cmd = getArgument();
	if (cmd=="Merge") {
		if (nSlices==1) {
		exit("only 1 channel detected");
		}
		Stack.getDisplayMode(mode);
		if (mode=="color" || mode=="grayscale") {
			t = getTitle();
			Stack.setDisplayMode("composite");
			run("Stack to RGB", "slices keep");
			selectWindow(t);
			Stack.setDisplayMode("color");
		} else {
			run("Stack to RGB", "slices keep");
		}
		//run("Tile");
	} else if (cmd=="Colour") {
		// ne traite pas les RGB
		if (bitDepth()==24){exit("Original image is RGB. Unable to continue.");}
		if (!is("composite")) {exit("Use Make Composite first...");}
		Stack.setDisplayMode("color");
	} else if (cmd=="Composite") {
		// ne traite pas les RGB
		if (bitDepth()==24){exit("Original image is RGB. Unable to continue.");}
		if (!is("composite")) {exit("Use Make Composite first...");}
		Stack.setDisplayMode("composite");
	} else if (cmd=="Merge at end") {
		// ne traite pas les RGB
		if (bitDepth()==24){
		exit("Original image is RGB. Unable to continue.");
		}
		t = getTitle();
		Stack.setDisplayMode("composite");
		run("Duplicate...", "title=["+t+"2.tif] duplicate channels=1-"+nSlices);
		n = nSlices;
		selectWindow(t);
		run("Split Channels");
		selectWindow(t+"2.tif");
		run("Stack to RGB");
		closeWin(""+t+"2.tif");
		run("Images to Stack", "name="+t+" merge title=["+t+"] use keep");
		t2 = getTitle();
		closeWin(""+t+"2.tif (RGB)");
		for (i=1; i<n+1; i++) closeWin("C"+i+"-"+t);
		selectWindow(t2);
	} else if (cmd=="Make Composite") {
		run("Make Composite", "display=Composite");
	} else if (cmd=="All Grays") {
		img = getList("image.titles");
		for (i=0; i<img.length; i++) {
			selectImage(img[i]);
			run("Grays");
		}
	} else if (cmd!="-") run(cmd);
}

// Source of colours: https://jfly.uni-koeln.de/html/color_blind/
var colCmds = newMenu("ColourForAll Menu Tool",
newArray("ColorForAll_Sky_Blue", "ColorForAll_Reddish_Purple", "ColorForAll_Yellow", "ColorForAll_Blue"
	, "ColorForAll_Orange", "ColorForAll_Bluish_Green", "ColorForAll_Vermillon"));

macro "ColourForAll Menu Tool - C6efT0b11CCf3bT8b08OCfd9Teb08L" {
	cmd = getArgument();
	if (cmd != "-") run(cmd);		// just in case :)
}

var stkCmds = newMenu("Stack Menu Tool",
newArray("MAX Projection", "-", "Add Slice", "Delete Slice", "Make Substack...", "Stack Splitter",	
		"-", "Animation Options...", "-", "Convert Images to Stack", "Convert Stack to Images", 
		"Z Project...",	"Make Montage...", "3D Project...", "Plot Z-axis Profile"));

macro "Stack Menu Tool - C037T0b11ST8b09tTcb09k" {
	cmd = getArgument();
	if (cmd=="MAX Projection") {
		t=getTitle();
		run("Z Project...", "projection=[Max Intensity]");
		t2=getTitle();
		closeWin(t);
		selectWindow(t2);
		rename(t);
	} else if (cmd!="-") run(cmd);
}

macro "Toggle Overlay Action Tool - C037T0b11OT7b09VTcb09L" {
	if (Overlay.size>0) { 
		if (Overlay.hidden) {
			Overlay.show;
		} else {
			Overlay.hide;
		}
	}
}

macro "Scale Action Tool - C037T0b11BT7b09aTcb09r" {
	requires("1.45f");
	getPixelSize(unit, pixelWidth, pixelHeight);
	if (unit=="pixels") {
		Dialog.create("Error");
		Dialog.addMessage("No calibration... Do it now?");
		Dialog.show();
		run("Properties...");
		getPixelSize(unit, pixelWidth, pixelHeight);
			while (unit=="pixels"){
				showMessage("Wrong calibration. Unit is still 'pixels'\nExample : write 'um' for microns in the field 'Unit of Length'.");
				run("Properties...");
				getPixelSize(unit, pixelWidth, pixelHeight);
			}
	}
	x = getWidth();
	y = getHeight();
	getPixelSize(unit, pixelWidth, pixelHeight);

	// calculation of optimal size for the scale bar
	// while loop: (xconv * factor) should be between 10 and 99
	xconv = x * pixelWidth;
	factor = 1;
	while (floor(xconv * factor) < 10) {
		factor = factor * 10;
	}
	while (floor(xconv * factor) >= 100) {
		factor = factor / 10;
	}
	xx = xconv * factor;
	
	// take y in account as well
	if (y / x > 1.8) xx = xx * 1.5;
	if (y / x < 0.7) xx = xx / 1.5;
	
	if (xx < 15) {u = 1;}
	else if (xx < 35) {u = 2;}
	else if (xx < 80) {u = 5;}
	else {u = 10;}

	setTool("rectangle");

	// default location of scale bar in the lower right corner
	minlen = u / factor;
	lenpx = minlen / pixelWidth;
	makeLine(x*0.9-lenpx,y*0.9,x*0.9,y*0.9);
	
	// Increase length?
	ans = true;
	while (ans) {
		ans = getBoolean("Increase bar size?");
		if (ans) {
			if (u == 50) u = 100;
			if (u == 20) u = 50;
			if (u == 10) u = 20;
			if (u == 5) u = 10;
			if (u == 2) u = 5;
			if (u == 1) u = 2;
			minlen = u / factor;
			lenpx = minlen / pixelWidth;	//conversion en pixels
			makeLine(x*0.9-lenpx,y*0.9,x*0.9,y*0.9);
		} 
	}
	
	waitForUser("Scale Bar","Move the yellow bar by its center.\n Click OK when done.");

	thick = floor(y/120);
	colorchoice = "White";

	run("Scale Bar...", "width="+minlen+" height="+thick+" font="+floor(y/30)+" color="+colorchoice+" background=None location=[At Selection] bold hide overlay");
	run("Select None");
	t=getTitle;						///1.6
	waitForUser("Scale Bar size","The size of this scale bar is "+minlen+" "+unit);
	rename(replace(t,".tif","")+"_"+minlen+unit);		///1.6
}
	
macro "-" {} //menu divider

macro "About Startup Macros..." {
	title = "About Startup Macros";
	text = "Macros, such as this one, contained in a file named\n"
		+ "'StartupMacros.txt', located in the 'macros' folder inside the\n"
		+ "Fiji folder, are automatically installed in the Plugins>Macros\n"
		+ "menu when Fiji starts.\n"
		+ "\n"
		+ "More information is available at:\n"
		+ "<http://imagej.nih.gov/ij/developer/macro/macros.html>";
	dummy = call("fiji.FijiTools.openEditor", title, text);
}
// close any window without returning any error ****************************************************
function closeWin(name) {
	if (isOpen(name)) {
		 selectWindow(name);
		 run("Close");
	}
}

// CHANGELOG
// v3.0: - added an extra menu with colors for all (both colorblinds and non-colorblinds)
