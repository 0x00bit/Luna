local Animations = {}

-- Sin animations
function Animations.createFloatAnimation(params)
    params = params or {}
    return {
        amplitude = params.amplitude or 5,       -- How much it moves up/down
        speed = params.speed or 2,               -- Oscillation speed
        offset = params.offset or 0,             -- Phase offset for variety
        time = 0,
        
        -- Call this in your update loop
        update = function(self, dt, target)
            self.time = self.time + dt * self.speed
            target.y = target.baseY + math.sin(self.time + self.offset) * self.amplitude
        end,
        
        -- Initialize (call this when attaching to an object)
        init = function(self, target)
            target.baseY = target.y  -- Store original position
        end
    }
end

function Animations.createShakeAnimation(params)
    params = params or {}
    return {
        amplitude = params.amplitude or 5,
        speed = params.speed or 2,
        offset = params.offset or 0,
        time = 0,
        
        update = function(self, dt, target)
            self.time = self.time + dt * self.speed
            target.x = target.baseX + math.cos(self.time + self.offset) * self.amplitude
        end,
        
        init = function(self, target)
            target.baseX = target.x  -- Fixed: lowercase x instead of X
        end
    }
end

return Animations