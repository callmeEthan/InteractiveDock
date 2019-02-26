function Initialize()
	count = tonumber(SKIN:GetVariable('TotalGame'))
	skinwidth = tonumber(SKIN:GetVariable('CURRENTCONFIGWIDTH'))
	skinheight = tonumber(SKIN:GetVariable('CURRENTCONFIGHEIGHT'))
	divider = SKIN:GetVariable('divider')
	vertical = tonumber(SKIN:GetVariable('vertical'))
	hide = 0
	show = 0
	width=tonumber(SKIN:GetVariable('width'))
	height=tonumber(SKIN:GetVariable('height'))
	padding=tonumber(SKIN:GetVariable('padding'))
	expand=tonumber(SKIN:GetVariable('expand'))
	select=0
	hideicon=tonumber(SKIN:GetVariable('autohide'))
	direction = tonumber(SKIN:GetVariable('direction'))
	edit = 0
	edit_entry = 0
	meter = {}
	x = {}
	y = {}
	w = {}
	h = {}
	xto = {}
	yto = {}
	if vertical == 1 then
	if direction < 0 then start = -height else start = skinwidth end
	for i=1, count do
		meter[i]=SKIN:GetMeter('Icon'..i)
		if meter[i] == nil then SKIN:Bang("!Refresh") end
		xto[i]= -width+(skinwidth/2)+(skinwidth/2)*(1+direction)
		yto[i]= (skinheight/2)
		y[i]= yto[i]
		x[i]= xto[i]
		w[i] = 1
		h[i] = 1
		SKIN:Bang("!SetOption","Icon"..i, "Padding", padding/2 .. ',' .. padding/2 .. ',' .. padding/2 .. ',' .. padding/2)
		end
	else
	for i=1, count do
	if direction < 0 then start = -height else start = skinheight end
		meter[i]=SKIN:GetMeter('Icon'..i)
		if meter[i] == nil then SKIN:Bang("!Refresh") end
		xto[i]= (skinwidth/2)
		yto[i]= -height+(skinheight/2)+(skinheight/2)*(1+direction)
		y[i]= yto[i]
		x[i]= xto[i]
		w[i] = 1
		h[i] = 1
		SKIN:Bang("!SetOption","Icon"..i, "Padding", padding/2 .. ',' .. padding/2 .. ',' .. padding/2 .. ',' .. padding/2)
		end
	end
end


function animate()
	for i=1, show do
		if i == select then
			w[i]=(w[i]-((w[i]-(width*expand-padding))/(divider)))
			h[i]=(h[i]-((h[i]-(height*expand-padding))/(divider)))
			x[i]=(x[i]-((x[i]-xto[i])/(divider)))
			y[i]=(y[i]-((y[i]-yto[i])/(divider)))
			meter[i]:SetX(x[i])
			meter[i]:SetY(y[i])
		else
			w[i]=(w[i]-((w[i]-(width-padding))/(divider)))
			h[i]=(h[i]-((h[i]-(height-padding))/(divider)))
			x[i]=(x[i]-((x[i]-xto[i])/(divider+2)))
			y[i]=(y[i]-((y[i]-yto[i])/(divider)))
			meter[i]:SetX(x[i])
			meter[i]:SetY(y[i])
		end
		SKIN:Bang("!SetOption","Icon"..i, "W", w[i])
		SKIN:Bang("!SetOption","Icon"..i, "H", h[i])
		meter[i]:Show()
	end
end

function update()
	if vertical == 1 then update_vertical() else update_horizonal() end
end

function update_vertical()
	local xs = 0
	if (select % 2 == 0) then xs = (show-select)/2 else xs = -(show-select)/2 end
	local xx = (skinheight/2) - (show * height / 2)
	local d = 1
	if select == 0 then
	for i=1, show do
		if i <= hide then xto[i] = start else xto[i]=((expand-1)*height)/2 end
		yto[i]=xx
		xx=xx + (height*(show-i))*d
		d = d*(-1)
		end
	else for i=1, show do
		if i == select then 
			xto[i]=0
			yto[i]=xx - ((expand-1)*height)/2
			else
			xto[i]=((expand-1)*height)/2
			if -d*((show-i)/2)<xs then
				yto[i]= xx - (expand-1)*height/2
				else
				yto[i]= xx + (expand-1)*height/2
			end
		end
		if i <= hide then xto[i]=start end
		xx=xx + (height*(show-i))*d
		d = d*(-1)
		end
	end
end

function update_horizonal()
	local xs = 0
	if (select % 2 == 0) then xs = (show-select)/2 else xs = -(show-select)/2 end
	local xx = (skinwidth/2) - (show * width / 2)
	local d = 1
	if select == 0 then
	for i=1, show do
		if i <= hide then yto[i] = start else yto[i]=((expand-1)*width)/2 end
		xto[i]=xx
		xx=xx + (width*(show-i))*d
		d = d*(-1)
		end
	else for i=1, show do
		if i == select then 
			yto[i]=0
			xto[i]=xx - ((expand-1)*width)/2
			else
			yto[i]=((expand-1)*width)/2
			if -d*((show-i)/2)<xs then
				xto[i]= xx - (expand-1)*width/2
				else
				xto[i]= xx + (expand-1)*width/2
			end
		end
		if i <= hide then yto[i]=start end
		xx=xx + (width*(show-i))*d
		d = d*(-1)
		end
	end
end

function show_more()
	if show < count then
	show = show+1
	update()
	end
end

function highlight(i)
	if i>0 then edit_entry = i end
	if edit == 0 then
		select = i
		update()
	end
end

function hide_icon()
	if hide < count and hideicon == 1 and edit == 0 then
	hide = hide + 1
	update()
	end
end	

function unhide_icon()
	if hide > 0 and hideicon == 1 and edit == 0 then
	hide = hide - 1
	update()
	end
end	

function toggle_edit()
	if edit == 0 then
		edit = 1
		show = count
		hide = 0
		select = 0
		update()
		SKIN:Bang("!EnableMeasureGroup", "DropGroup")
		SKIN:Bang("!ShowMeter","Debug")
		SKIN:Bang("!SetOption", "Debug", "Text", "Edit enabled")
	else 
		edit = 0
		SKIN:Bang("!DisableMeasureGroup", "DropGroup")
		SKIN:Bang("!HideMeter","Debug")
		update()
	end
end	

function drop_file()
	local i =  tonumber(SKIN:GetVariable('Edit'))
	local file = SKIN:GetVariable('File')
	local path,file,extension = SplitFilename(file)
	SKIN:Bang("!SetVariable", "Filename", file)
	SKIN:Bang("!UpdateMeasure", "Animation")
	if (extension == 'png') or (extension == 'jpg') or (extension == 'bmp') or (extension == 'gif') or (extension == 'tif') or (extension == 'ico') then 
		SKIN:Bang("!CommandMeasure", "Animation", "Execute 4")
		else
		SKIN:Bang("!CommandMeasure", "Animation", "Execute 5")
		end
end

function SplitFilename(strFilename)
	return string.match(strFilename, "(.-)([^\\]-([^\\%.]+))$")
end

function add_icon()
	SKIN:Bang("!WriteKeyValue", "Variables", 'TotalGame', count+1, "#@#Applist.inc")
	SKIN:Bang("!WriteKeyValue", "Variables", 'Gamecover'..count+1, 'new.png', "#@#Applist.inc")
	SKIN:Bang("!Refresh")
end

function remove_icon()
	for i=edit_entry, count-1 do
	local Gamecover=SKIN:GetVariable('Gamecover'..i+1)
	local Gamedir=SKIN:GetVariable('Gamedir'..i+1)
	SKIN:Bang("!WriteKeyValue", "Variables", 'Gamecover'..i, Gamecover, "#@#Applist.inc")
	SKIN:Bang("!WriteKeyValue", "Variables", 'Gamedir'..i, Gamedir, "#@#Applist.inc")
	end
	SKIN:Bang("!WriteKeyValue", "Variables", 'TotalGame', count-1, "#@#Applist.inc")
	SKIN:Bang("!Refresh")
end

function MouseAction( Target )
	if hideicon == 1 then
		if Target == 1 then
			SKIN:Bang( "!CommandMeasure", "Animation", "Stop 3" )
			SKIN:Bang( "!CommandMeasure", "Animation", "Execute 3" )

			if vertical == 1 then
				SKIN:Bang( "!SetOption", "Background", "W", skinwidth )
				SKIN:Bang( "!SetOption", "Background", "X", 0 )
			else
				SKIN:Bang( "!SetOption", "Background", "H", skinheight )
				SKIN:Bang( "!SetOption", "Background", "Y", 0 )
			end

			SKIN:Bang( "!UpdateMeter", "Background" )

		else
			SKIN:Bang( "!CommandMeasure", "Animation", "Stop 2" )
			SKIN:Bang( "!CommandMeasure", "Animation", "Execute 2" )

			if vertical == 1 then
				SKIN:Bang( "!SetOption", "Background", "W", 2 )
				SKIN:Bang( "!SetOption", "Background", "X", skinwidth - 2 )
			else
				SKIN:Bang( "!SetOption", "Background", "H", 2 )
				SKIN:Bang( "!SetOption", "Background", "Y", skinheight - 2 )
			end

			SKIN:Bang( "!UpdateMeter", "Background" )
		end
	end


	highlight( 0 )
	SKIN:Bang( "!CommandMeasure", "Animation", "Stop 6" )
	SKIN:Bang( "!CommandMeasure", "Animation", "Execute 6" )
end
