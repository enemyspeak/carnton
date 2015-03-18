
local Intro = Gamestate:addState('Title')

local NEXTSTATE = "Intro"
local WIDTH = love.graphics.getWidth()
local HEIGHT = love.graphics.getHeight()
local CENTERX = WIDTH/2
local CENTERY = HEIGHT/2

local colors = 		{
					background = {57,57,57}
					}

local fonts =		{
					Type = love.graphics.newFont("res/LetterGothicStd.otf",24),
					Slant = love.graphics.newFont("res/LetterGothicStd-Slanted.otf",24),					
					Debug = love.graphics.newFont("res/LetterGothicStd.otf",14)
					}

local t

local mx,my







---------------------










function Intro:enteredState()
	t = 0
end

function Intro:exitedState()
	love.graphics.setFont(fonts["Debug"])	
end

function Intro:update(dt)
	t = t + dt
		
	if t > 38 then
		gamestate:gotoState(NEXTSTATE)	
	end
	
	mx,my = love.mouse.getPosition()
end

function Intro:draw()
	love.graphics.setBackgroundColor(unpack(colors["background"]))	
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(fonts["Slant"])	
	
	if t < 11 and t > 3 then
		love.graphics.printf("The Carnton Plantation is a site in Williamson County that played an important role in the Battle of Franklin, a Cival War battle that took place in Tennessee in 1864.", 50,HEIGHT/2-50,WIDTH-100,"center")
	elseif t > 13 and t < 25 then
		love.graphics.printf("During the battle, the manor house became a confederate field hospital. A number of amputations occurred there- the evidence of which still remains in the stained floorboards. Several eye witness accounts describe the pile of amputated limbs reaching as high as the second floor window.", 50,HEIGHT/2-75,WIDTH-100,"center")
	elseif t > 27 and t < 34 then
		love.graphics.setFont(fonts["Type"])	
		love.graphics.printf("The manor house is said to be haunted.", 50,HEIGHT/2-25,WIDTH-100,"center")
	end
end

function Intro:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	end
end

function Intro:mousepressed(x, y, button)
end

function Intro:joystickpressed(joystick, button)
end
