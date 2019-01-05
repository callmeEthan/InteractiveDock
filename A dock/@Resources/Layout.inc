[IconRepeat]
Meter=Image
ImageName=#@#App\#GamecoverRepeat#
LeftMouseUpAction=["#GamedirRepeat#"][!CommandMeasure Animate "highlight(0)"][!CommandMeasure Animation "Stop 7"][!CommandMeasure Animation "Execute 7"]
MouseOverAction=[!CommandMeasure "Animate" "highlight(Repeat)"][!CommandMeasure Animation "Stop 6"][!CommandMeasure Animation "Execute 6"]
MeterStyle=LayoutIcon

[DragNDropChildRepeat]
Measure=Plugin
Plugin=Drag&Drop
Parent=DragNDropParent
Action=Path
DynamicVariables=1
OnEnterAction=[!SetVariable Edit Repeat]
Group=DropGroup
Bounds = IconRepeat
Disabled=1