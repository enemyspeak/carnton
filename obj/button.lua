---------------------------------------------------------
--Button code originally based on code by Michael Enger--
---------------------------------------------------------

local Button = class('Button')

Button.static.MAIN = {255,255,255}
Button.static.BACKGROUND = {57,57,57}
Button.static.FADEFACTOR = 1024
Button.static.HIGHLIGHTRANGE = 150

Button.static.ARROW = love.graphics.newImage("res/arrow.png")  --this is a class variable


function Button:initialize(attributes)
	self.height = attributes.height or 55
	self.width = attributes.width or 50

	self.x = attributes.x
	self.y = attributes.y

	self.hidden	= attributes.hidden or false
	self.hiddenOverride = attributes.hiddenOverride or false
	self.alpha = attributes.alpha or 0
	self.angle = attributes.angle or 0

	self.hover = false -- whether the mouse is hovering over the button
	self.click = false -- whether the mouse has been clicked on the button
	
	self.debug = attributes.debug or false
end

function Button:draw()
	love.graphics.setColor(90,80,68,self.alpha) 
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
	
	if self.hover then
		love.graphics.setColor(133,125,105,self.alpha) 
	else
		love.graphics.setColor(113,105,86,self.alpha) 
	end
	love.graphics.draw(Button.ARROW, self.x+(self.width/2), self.y+(self.height/2),self.angle,1,1,32,32)
end

function Button:update(dt,x)	
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
		
	if 	self.hiddenOverride then 
		self.hidden = true
	else	
		if ( self.x - mx ) ^ 2 + ( self.y - my ) ^ 2 < (Button.HIGHLIGHTRANGE) ^ 2 then		-- Within Circle (x-a)^2 + (y-b)^2 = r ^2
			self.hidden = false
		else
			self.hidden = true
		end
	end
		
	if self.hidden then 
		self.alpha = self.alpha - Button.FADEFACTOR*(dt)
	else 
		self.alpha = self.alpha + Button.FADEFACTOR*(dt) 
	end
	
	if self.alpha < 0 and self.hidden then 
		self.alpha = 0
	elseif self.alpha > 255 and self.hidden == false then 
		self.alpha = 255 
	end
	
	if self.hidden then 
		self.hover = false
	else
		if mx > self.x
			and mx < self.x + self.width
			and my > self.y
			and my < self.y + self.height then
			self.hover = true
		else
			self.hover = false
		end
	end

end

function Button:setPos(x,y)
	self.x = x
	self.y = y
end

function Button:setHidden(value)
	self.hiddenOverride = value
end

function Button:setSize(width,height)
	self.width = width
	self.height = height
end

function Button:setClicked(value)
	self.click = value
end

function Button:getClicked()
	return self.click
end

function Button:mousepressed(x, y, button)
	if self.hover then
		self.click = true
		return true
	end	
	self.click = false		-- this might break something
	return false
end

return Button
