local Moonsters = {}

function Moonsters.newFireCration()
    return {
        sprite = love.graphics.newImage('assets/moonsters/monster1back.png'),
        moonster_name = "Firecration",
        summon_name = "Ace Spades",
        x = 100,
        y = 320, 
        hp = 100,
        maxHp = 100
    }
end

function Moonsters.newCaesar()
    return {
        sprite = love.graphics.newImage('assets/moonsters/monster2front.png'),
        moonster_name = "Caesar",
        summon_name = "Rolling Stones",
        x = 1050,
        y = 350,
        hp = 100,
        maxHp = 100    
    }
end

-- STANDS

function Moonsters.newAceSpades()
    return {
        image = love.graphics.newImage('assets/stands/asback.png'),
        x = 450, 
        y = 300,
        scale = 0.3,
        animations = {}
    }
end

function Moonsters.newRollingStones()
    return {
        image = love.graphics.newImage('assets/stands/rsfront.png'),
        x = 860,
        y = 450,
        scale = 0.3,
        animations = {}
    }
end

return Moonsters