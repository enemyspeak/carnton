-------------------------------------------------------------------
--Shader/transition code originally based on code by someone else--
-------------------------------------------------------------------

local Intro = Gamestate:addState('Intro')

local Button = require 'obj.button'

local NEXTSTATE = "One"
local WIDTH = love.graphics.getWidth()
local HEIGHT = love.graphics.getHeight()
local CENTERX = WIDTH/2
local CENTERY = HEIGHT/2

local colors = 		{
					background = {57,57,57}
					}

local t
local tDelay

local mx,my

local fadeAlpha
local duration

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

local audio =			{
						amb = love.audio.newSource("res/amb.mp3","streaming"),
						}

local cursor = love.graphics.newImage('res/cursor.png')	

local image2 = love.graphics.newImage('res/3.jpg')	
local image = love.graphics.newImage('res/2.jpg')	
local transition = love.graphics.newImage('res/trans/2.jpg')	

local fButton = Button:new({ x = 550, y = 360, angle = -math.pi/2 }) -- forward
local buttonPressed = false

local function updateScripts()	
	if fButton:getClicked() then		--F
		canvas2:renderTo(function() love.graphics.draw(image) end)	
		t = 0
		fadeAlpha = 0
		fButton:setPos(-50,-50)
		buttonPressed = true
		fButton:setClicked(false)
	end
end

------------------------------------------------------------------------------------------









function Intro:enteredState()
	t = 0
	tDelay = 0
	fadeAlpha = 0
	duration = 9
	
	audio["amb"]:setVolume( 0.25 ) -- % of ordinary volume
	audio["amb"]:setLooping( true )
	love.audio.setVolume( 0 )
	
	love.audio.play(audio["amb"])
	
	fButton:setPos(545,375)
	
	fButton:setClicked(false)
	buttonPressed = false

	effect:send("time",t)	
	effect:send("duration",duration)
	effect:send("trans",transition)

	canvas:renderTo(function() love.graphics.draw(image) end)	
end

function Intro:exitedState()
	love.audio.stop()
	canvas2:renderTo(function() love.graphics.draw(image2) end)	
end

function Intro:update(dt)
	if tDelay < 4 then 
		if tDelay > 3 and tDelay < 4 then
			love.audio.setVolume( tDelay-3 )		
		elseif tDelay < 3 then
			love.audio.setVolume( 0 )		
		else
			love.audio.setVolume( 1 )		
		end
		tDelay = tDelay + dt
	else
		t = t + dt
	end
	
	fadeAlpha = fadeAlpha + dt*80
	
	if buttonPressed then
		local value = 1 - fadeAlpha/200
		if value < 1 or value > 0 then
			love.audio.setVolume( value )
		else
			love.audio.stop()
		end
	end
	
	if fadeAlpha > 255 then 
		if buttonPressed then
			fadeAlpha = 255	
			gamestate:gotoState(NEXTSTATE)	
		end
		fadeAlpha = 255	
	end
	if t > duration then
		fButton:update(dt)
	end
	
	updateScripts()	

	effect:send("time",t)
	mx,my = love.mouse.getPosition()
end

function Intro:draw()
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
	
	fButton:draw()
	
	if t > duration then
		love.graphics.setColor(191,185,149)
		love.graphics.draw(cursor,mx,my,0,1,1,15,6)
	end
	
	love.graphics.setColor(255,255,255,255)
end

function Intro:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	elseif key == 'r' then
		t = 0
		fadeAlpha = 0
		effect:send("duration",duration)
	end
end

function Intro:mousepressed(x, y, button)
	fButton:mousepressed(x,y,button)
end

function Intro:joystickpressed(joystick, button)

end
