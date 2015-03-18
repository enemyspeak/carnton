
local One = Gamestate:addState('One')

local Button = require 'obj.button'

local NEXTSTATE = "Two"
local WIDTH = love.graphics.getWidth()
local HEIGHT = love.graphics.getHeight()
local CENTERX = WIDTH/2
local CENTERY = HEIGHT/2

local colors = 		{
					background = {80,72,59}
					}

local t
local mx,my

local buttonPressed

local fadeAlpha
local duration

local audio =	{
				lento = love.audio.newSource("res/Lento.ogg","streaming") -- if "static" is omitted, LÖVE will stream the file from disk --.mp3 playback buggy, .ogg recommended
				}

local canvas = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas2 = love.graphics.newCanvas(WIDTH,HEIGHT)

local effect = love.graphics.newPixelEffect [[
	extern Image trans;
	extern number time;
	extern number duration;
	vec4 effect(vec4 color,Image tex,vec2 tc,vec2 pc)
	{
		vec4 img_color = Texel(tex,tc);
		vec4 trans_color = Texel(trans,tc);
		number white_level	= (trans_color.r + trans_color.b + trans_color.b)/3;
		number max_white	= time/duration;
		
		if (white_level <= max_white)
		{
			return img_color;
		}
		
		img_color.a = 0;
		return img_color;
	}
]]

local cursor = love.graphics.newImage('res/cursor.png')	

local image1 = love.graphics.newImage('res/1.jpg')	
local image3 = love.graphics.newImage('res/3.jpg')	
local image4 = love.graphics.newImage('res/4.jpg')	
local image5 = love.graphics.newImage('res/5.jpg')	
local image6 = love.graphics.newImage('res/6.jpg')	
local image7 = love.graphics.newImage('res/7.jpg')	

local transition1 = love.graphics.newImage('res/trans/1.jpg')	
local transition3 = love.graphics.newImage('res/trans/3.jpg')	
local transition4 = love.graphics.newImage('res/trans/4.jpg')	
local transition5 = love.graphics.newImage('res/trans/5.jpg')	
local transition6 = love.graphics.newImage('res/trans/6.jpg')	
local transition7 = love.graphics.newImage('res/trans/7.jpg')	

local image = image1
local transition = transition1

local buttons = {}
	buttons[1] = Button:new({ x = 650, y = 500, angle = math.pi/2  }) -- back
	buttons[2] = Button:new({ x = 675, y = 180, angle = -5*math.pi/6 }) --stairs
	buttons[3] = Button:new({ x = 780, y = 275, angle = 0 }) --right door
	buttons[4] = Button:new({ x = 375, y = 280, angle = math.pi }) -- left door
	buttons[5] = Button:new({ x = 480, y = 260, angle = -math.pi/2 }) -- forward
	buttons[6] = Button:new({ x = 675, y = 380, angle = 5*math.pi/6 }) -- down stairs

local function updateButtons(dt)
	for n,b in pairs(buttons) do
		b:update(dt,mx)
	end		
end

local function updateScripts()
	if image == image1 then		
		buttons[1]:setPos(650,500)
		buttons[2]:setPos(675,180)
		buttons[3]:setPos(765,275)
		buttons[4]:setPos(375,280)
		--buttons[5]:setPos(480,290)
		buttons[5]:setPos(-50,-50)
		buttons[6]:setPos(-50,-50)
		love.audio.setVolume( 1 )		

		if buttons[1]:getClicked() then		-- back
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image3
			transition = transition3
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
			fadeAlpha = 0
			canvas2:renderTo(function() love.graphics.draw(image1) end)		
			buttonPressed = true
		elseif buttons[3]:getClicked() then		--right
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image6
			transition = transition6
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image5
			transition = transition5
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--right
			buttons[5]:setClicked(false)
		elseif buttons[6]:getClicked() then		--right
			buttons[6]:setClicked(false)
		end
	elseif	image == image2 then
		gamestate:gotoState("Title")	
	elseif	image == image3 then
		buttons[1]:setPos(650,500)
		buttons[2]:setPos(-50,-50)	--nostairs
		buttons[3]:setPos(770,300)
		buttons[4]:setPos(325,280)
		buttons[5]:setPos(512,290)
		--buttons[5]:setPos(-50,-50)
		buttons[6]:setPos(-50,-50)
		love.audio.setVolume( 0.75 )		
		
		if buttons[1]:getClicked() then		-- back
			canvas2:renderTo(function() love.graphics.draw(image) end)
		
			image = image1
			transition = transition1
			t = 0
			fadeAlpha = 0
			effect:send("time",t)
			effect:send("trans",transition)
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
		elseif buttons[3]:getClicked() then		--right
			canvas2:renderTo(function() love.graphics.draw(image) end)
		
			image = image4
			transition = transition4
			t = 0
			fadeAlpha = 0
			effect:send("time",t)
			effect:send("trans",transition)
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			canvas2:renderTo(function() love.graphics.draw(image) end)
		
			image = image7
			transition = transition7
			t = 0
			fadeAlpha = 0
			effect:send("time",t)
			effect:send("trans",transition)
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--F
			canvas2:renderTo(function() love.graphics.draw(image) end)
			buttons[5]:setClicked(false)
			gamestate:gotoState("Intro")		
		elseif buttons[6]:getClicked() then		--D
			buttons[6]:setClicked(false)
		end
	elseif	image == image4 then
		buttons[1]:setPos(650,500)	-- B
		buttons[2]:setPos(-50,-50)	-- U
		buttons[3]:setPos(900,300)	-- R
		buttons[4]:setPos(-50,-50)	-- L
		buttons[5]:setPos(-50,-50)	-- F
		buttons[6]:setPos(-50,-50)	-- D
		love.audio.setVolume( 0.65 )		
		
		if buttons[1]:getClicked() then		-- back
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image3
			transition = transition3
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
		elseif buttons[3]:getClicked() then		--right
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image5
			transition = transition5
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--F
			buttons[5]:setClicked(false)
		elseif buttons[6]:getClicked() then		--D
			buttons[6]:setClicked(false)
		end
	elseif image == image5 then		
		buttons[1]:setPos(500,500)	-- B
		buttons[2]:setPos(-50,-50)	-- U
		buttons[3]:setPos(-50,-50)	-- R
		buttons[4]:setPos(50,350)	-- L
		buttons[5]:setPos(-50,-50)	-- F
		buttons[6]:setPos(-50,-50)	-- D
		love.audio.setVolume( 0.85 )		
		
		if buttons[1]:getClicked() then		-- back
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image1
			transition = transition1
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
		elseif buttons[3]:getClicked() then		--right
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image4
			transition = transition4
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--F
			buttons[5]:setClicked(false)
		elseif buttons[6]:getClicked() then		--D
			buttons[6]:setClicked(false)
		end
	elseif image == image6 then		
		buttons[1]:setPos(-50,-50)	-- B
		buttons[2]:setPos(-50,-50)	-- U
		buttons[3]:setPos(-50,-50)	-- R
		buttons[4]:setPos(50,265)	-- L
		buttons[5]:setPos(300,260)	-- F
		buttons[6]:setPos(-50,-50)	-- D
		love.audio.setVolume( 0.85 )		
		
		if buttons[1]:getClicked() then		-- back
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
		elseif buttons[3]:getClicked() then		--right
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image7
			transition = transition7
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--F
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image1
			transition = transition1
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[5]:setClicked(false)
		elseif buttons[6]:getClicked() then		--D
			buttons[6]:setClicked(false)
		end
	elseif image == image7 then		
		buttons[1]:setPos(-50,-50)	-- B
		buttons[2]:setPos(-50,-50)	-- U
		buttons[3]:setPos(920,250)	-- R
		buttons[4]:setPos(-50,-50)	-- L
		buttons[5]:setPos(740,275)	-- F
		buttons[6]:setPos(-50,-50)	-- D
		love.audio.setVolume( 0.85 )		
		
		if buttons[1]:getClicked() then		-- back
			buttons[1]:setClicked(false)
		elseif buttons[2]:getClicked() then		--stairs
			buttons[2]:setClicked(false)
		elseif buttons[3]:getClicked() then		--right
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image6
			transition = transition6
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[3]:setClicked(false)
		elseif buttons[4]:getClicked() then		--left
			buttons[4]:setClicked(false)
		elseif buttons[5]:getClicked() then		--F
			canvas2:renderTo(function() love.graphics.draw(image) end)
			
			image = image3
			transition = transition3
			t = 0
			fadeAlpha = 0

			effect:send("time",t)
			effect:send("trans",transition)
			buttons[5]:setClicked(false)
		elseif buttons[6]:getClicked() then		--D
			buttons[6]:setClicked(false)
		end
	end
end







------------------------------------------------------------------------------------------









function One:enteredState()
	t = 0
	mx,my = love.mouse.getPosition()
	fadeAlpha = 255
	buttonPressed = false

	duration = 8
--	duration = 1

	audio["lento"]:setVolume( 1 ) -- % of ordinary volume
	audio["lento"]:setLooping( true )
	love.audio.setVolume( 1 )
	love.audio.play(audio["lento"])
	
	effect:send("time",t)
	effect:send("duration",duration)
	effect:send("trans",transition)
	canvas:renderTo(function() love.graphics.draw(image) end)	
end

function One:exitedState()
	love.audio.stop()
end

function One:update(dt)
	t = t + dt
	
	fadeAlpha = fadeAlpha + dt*80
	
	if buttonPressed then
		local temp = 1 - fadeAlpha/200
		if temp < 1 or temp > 0 then
			love.audio.setVolume( temp )
		else
			love.audio.stop()
		end
	end
	
	if fadeAlpha > 255 then 
		fadeAlpha = 255	
		if buttonPressed then
			gamestate:gotoState(NEXTSTATE)	
		end
	end
		
	effect:send("time",t)

	mx,my = love.mouse.getPosition()
	
	updateScripts()
	updateButtons(dt)
	
	if t < duration or buttonPressed then
		for n,b in pairs(buttons) do
			b:setHidden(true)
		end	
	else
		for n,b in pairs(buttons) do
			b:setHidden(false)
		end	
	end
end

function One:draw()
	love.graphics.setBackgroundColor(unpack(colors["background"]))	
	love.graphics.draw(canvas2)
	
	love.graphics.setColor(80,72,59,fadeAlpha)
	love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
	love.graphics.setColor(255,255,255,255)

	if buttonPressed then else
		love.graphics.setPixelEffect(effect)
		love.graphics.draw(image)
		love.graphics.setPixelEffect()
	end

	for n,b in pairs(buttons) do
		b:draw()
	end		
	
	if t > duration or buttonPressed then
		love.graphics.setColor(191,185,149)
		love.graphics.draw(cursor,mx,my,0,1,1,15,6)
	end

	--debug stuff
--	love.graphics.print(mx..", "..my, mx+10,my-10)

	love.graphics.setColor(255,255,255,255)
end

function One:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	end
end

function One:mousepressed(x, y, button)
	for n,b in pairs(buttons) do
		b:mousepressed(x,y,button)
	end	
end

function One:joystickpressed(joystick, button)

end
