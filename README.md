## ImageJ-Macros-Utilities
A repository for some tools providing features that are external to [Aivia](https://www.drvtechnologies.com/aivia), such as: complex image montage, LUT color mapping creation, etc.

---
### Macro about image montage with 2D+t or 3D datasets, e.g. for lab meeting presentations, etc.

* [CreateMontageWithTime_2.0.ijm](/CreateMontageWithTime_2.0.ijm "Right-click > Save Link As, to download file")

To create montage of single channel 2D+T or 3D images and keep the 3rd dimension as a slider. This allows for navigation in the latter dimension, for quick review and for appropriate choice of montage to keep for a figure, for instance.
The macro let you choose the layout and the images for each position, via a drop-down menu. 

<b>Important note:</b> Images should be opened and display (contrast, etc.) should be adjusted priorily to running the macro.

[Demo video of CreateMontageWithTime_2.0.ijm](/DRVisionFiles/Videos/CreateMontageWithTime_2.0.ijm.mp4 "Demo video")

---
### Macro to export individual Fields-Of-View stored in a multi-image file (.lif, .nd2, .czi, ...)

* [Export-as-individual-images_1.6.ijm](/Export-as-individual-images_1.6.ijm "Right-click > Save Link As, to download file")

The macro can process multiple files in the same folder (batch mode = yes) or only one file (batch mode = no). By default, all images embedded in the same input file will be output in an individual subfolder, but you have an option to export all in the same folder. You can also export RGB merged images and/or max projections.

---
### Macro to create a custom LUT color mapping for Aivia

* [LUTconverterToHEXA_2.0.ijm](/LUTconverterToHEXA_2.0.ijm "Right-click > Save Link As, to download file")

Uses an image in ImageJ or Fiji (gradient of colors) to generate a custom LUT coloring compatible with Aivia / Aivia Community, saved as a **text file**.
Important: input LUT image is expected to have an horizontal gradient. Final color coding is done on 256 levels as a maximum.
Example of use: in ImageJ, use the menu "Image > Color > Display LUTs" and crop the one you want to generate. Then run the macro and save window as a text file (File > Save As > Text). In Aivia, right-click on the channel of interest > Advanced Coloring > Load Coloring.

* [Fiji-to-Aivia-LUT-converter_2.1.ijm](/Fiji-to-Aivia-LUT-converter_2.1.ijm "Right-click > Save Link As, to download file")

Same as above but uses NeuroCyto LUTs list as suggested LUTs. User selects it from a stack (easier than version above).

---
