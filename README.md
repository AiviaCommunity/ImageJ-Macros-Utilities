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

* [Export-as-individual-images_1.5.ijm](/Export-as-individual-images_1.5.ijm "Right-click > Save Link As, to download file")

The macro can process multiple files in the same folder (batch mode = yes) or only one file (batch mode = no). 
You can also export RGB merged images and/or max projections.

---
