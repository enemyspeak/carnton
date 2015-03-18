-------------------------------------------------------------------
--Shader/transition code originally based on code by someone else--
-------------------------------------------------------------------

local Outro = Gamestate:addState('Outro')

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

local effectDelay

local fadeAlpha
local fadeAlpha2
local duration
local duration2
local duration3

local canvas = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas2 = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas3 = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas4 = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas5 = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas6 = love.graphics.newCanvas(WIDTH,HEIGHT)
local canvas7 = love.graphics.newCanvas(WIDTH,HEIGHT)

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

local effect2 = love.graphics.newPixelEffect [[
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
						largo = love.audio.newSource("res/Largo.ogg","streaming"),
						}

local image = love.graphics.newImage('res/11.jpg')	
local transition = love.graphics.newImage('res/trans/11.jpg')	
local image2 = love.graphics.newImage('res/12.jpg')	
local transition2 = love.graphics.newImage('res/trans/12.jpg')	
local image3 = love.graphics.newImage('res/13.jpg')	
local transition3 = love.graphics.newImage('res/trans/13.jpg')	
local image4 = love.graphics.newImage('res/14.jpg')	
local transition4 = love.graphics.newImage('res/trans/14.jpg')	
local image5 = love.graphics.newImage('res/15.jpg')	
local transition5 = love.graphics.newImage('res/trans/15.jpg')	
local image6 = love.graphics.newImage('res/16.jpg')	
local transition6 = love.graphics.newImage('res/trans/16.jpg')	

local function updateScripts()	
--[[
	if t == a number then
		canvas2:renderTo(function() love.graphics.draw(image) end)	
		t = 0
		fadeAlpha = 0
		buttonPressed = true
	end
--]]
end

------------------------------------------------------------------------------------------









function Outro:enteredState()
	t = 0
	tDelay = 0
	fadeAlpha = 0
	fadeAlpha2 = 0
--	duration = 5
--	duration2 = 12
--	duration3 = 20
	duration = 10
	duration2 = 24
	duration3 = 40
	
	effectDelay = 4
	
	audio["largo"]:setVolume( 1 ) -- % of ordinary volume
	audio["largo"]:setLooping( false )
	love.audio.setVolume( 1 )
	
	love.audio.play(audio["largo"])
	
	buttonPressed = false

	effect:send("time",t)	
	effect:send("duration",duration)
	effect:send("trans",transition)
	
	effect2:send("time",t)	
	effect2:send("duration",duration2)
--	effect2:send("trans",transition2)

--	canvas:renderTo(function() love.graphics.draw(image) end)	
end

function Outro:exitedState()
	love.audio.stop()
	canvas2:renderTo(function() love.graphics.draw(image2) end)	
end

function Outro:update(dt)
	if tDelay < 2 then 
		tDelay = tDelay + dt
	else
		--t = t + dt/2
		t = t + dt
	end
	
	if t > duration2 + effectDelay then
		fadeAlpha = fadeAlpha + dt*15
	
		if fadeAlpha > 255 then
			fadeAlpha = 255
		end
	end
	
	if t > 85 then
		fadeAlpha2 = fadeAlpha2 + dt*25
	
		if fadeAlpha2 > 255 then
			fadeAlpha2 = 255
		end
	end
	
	

	updateScripts()	

	if t > duration2 + effectDelay + duration3/2 then
		transition = transition5
		effect:send("duration",duration3)	
		effect:send("time",t-(duration2 + effectDelay + duration3/2 ))
		effect:send("trans",transition)	
	elseif t > duration then
		transition = transition3
		effect:send("duration",duration2)	
		effect:send("time",t-(duration+1))
		effect:send("trans",transition)	
	else
		effect:send("time",t)
	end
	if t > duration2 + effectDelay +25 then
		--transition = transition6
		effect2:send("duration",duration3)	
		effect2:send("time",t-(duration2 + effectDelay + 25))
		effect2:send("trans",transition6)	
	elseif t > duration2 + effectDelay then
		--transition = transition4
		effect2:send("duration",duration3)	
		effect2:send("time",t-(duration2 + effectDelay))
		effect2:send("trans",transition6)	
	else
		effect2:send("time",t-4)
	end
	mx,my = love.mouse.getPosition()
	
end

function Outro:draw()
	
	--if tDelay > 2 then
		love.graphics.setBackgroundColor(80,72,59)
	--else
	--	love.graphics.setBackgroundColor(unpack(colors["background"]))	
	--end
	
	--love.graphics.draw(canvas2)
	
	--love.graphics.setColor(80,72,59,fadeAlpha)
	--love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
	--love.graphics.setColor(255,255,255,255)
	
	
	love.graphics.push()
	--love.graphics.scale(t/40)
	--love.graphics.translate(-WIDTH/2,-HEIGHT/2)

	if t < duration then
		love.graphics.setCanvas(canvas3)	
			love.graphics.setPixelEffect(effect)
			love.graphics.draw(image)
			love.graphics.setPixelEffect()		
		love.graphics.setCanvas()
	elseif t > duration2 + effectDelay + duration3/2 then
		love.graphics.setCanvas(canvas6)	
			love.graphics.setPixelEffect(effect)
			love.graphics.draw(image5)
			love.graphics.setPixelEffect()		
		love.graphics.setCanvas()
	else
		love.graphics.setCanvas(canvas3)	
			love.graphics.setPixelEffect(effect)
			love.graphics.draw(image3)
			love.graphics.setPixelEffect()		
		love.graphics.setCanvas()
	end	
	if t > duration2 + effectDelay + 25 then
		effect2:send("trans",transition6)
		love.graphics.setCanvas(canvas7)
			love.graphics.setPixelEffect(effect2)
			love.graphics.draw(image6)
			love.graphics.setPixelEffect()
		love.graphics.setCanvas()		
	elseif t > duration2 + effectDelay then
		effect2:send("trans",transition4)
		love.graphics.setCanvas(canvas5)
			love.graphics.setPixelEffect(effect2)
			love.graphics.draw(image4)
			love.graphics.setPixelEffect()
		love.graphics.setCanvas()		
	elseif t > 4 then
		effect2:send("trans",transition2)
		love.graphics.setCanvas(canvas4)
			love.graphics.setPixelEffect(effect2)
			love.graphics.draw(image2)
			love.graphics.setPixelEffect()
		love.graphics.setCanvas()		
	end
		
	love.graphics.pop()	
	love.graphics.translate(WIDTH/2,HEIGHT/2)

	love.graphics.draw(canvas3, 0, 0,0,0.75 + t/45,0.75 + t/45,WIDTH/2,HEIGHT/2)
	love.graphics.draw(canvas4, 0, 0,0,0.75 + t/55,0.75 + t/55,WIDTH/2,HEIGHT/2)	

	love.graphics.draw(canvas5, 0, 0,0,0.75 + (t-10)/60,0.75 + (t-10)/60,WIDTH/2,HEIGHT/2)	

	if t > duration2 + effectDelay then
		love.graphics.setColor(80,72,59,fadeAlpha)
		love.graphics.rectangle("fill",-WIDTH/2,-HEIGHT/2,WIDTH,HEIGHT)
		love.graphics.setColor(255,255,255,255)
	end	

	love.graphics.draw(canvas6, 0, 0,0,0.75 + (t-40)/90,0.75 + (t-40)/90,WIDTH/2,HEIGHT/2)	
	love.graphics.draw(canvas7, 0, 0,0,0.75 + (t-40)/90,0.75 + (t-40)/90,WIDTH/2,HEIGHT/2)	

	if t > 85 then
		love.graphics.setColor(80,72,59,fadeAlpha2)
		love.graphics.rectangle("fill",-WIDTH/2,-HEIGHT/2,WIDTH,HEIGHT)
		love.graphics.setColor(255,255,255,255)
	end	
	


	love.graphics.setColor(255,255,255,255)
end

function Outro:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	elseif key == 'r' then
		t = 0
		fadeAlpha = 0
		effect:send("duration",duration)
	end
end

function Outro:mousepressed(x, y, button)
end

function Outro:joystickpressed(joystick, button)

end
