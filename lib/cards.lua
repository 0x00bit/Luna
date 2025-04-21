local Cards = {}

function Cards.newOverkill()
    local overkill = {
        name = "Overkill",
        image = love.graphics.newImage("assets/cards/overkill.png"),
        x = 200,
        y = 0,
        attack = 15,
        defense = 0.02,
        isActive = true
    }
    return overkill
end

function Cards.newIronFist()
    local iron_fist = {
        name = "Iron Fist",
        image = love.graphics.newImage("assets/cards/iron_fist.png"),
        x = 400,
        y = 0,
        attack = 10,
        defense = 0,
        isActive = false
    }
    return iron_fist
end

function Cards.newEnterSandman()
    local enter_sandman = {
        name = "Iron Fist",
        image = love.graphics.newImage("assets/cards/enter_sandman.png"),
        x = 600,
        y = 0,
        attack = 0,
        defense = 0.20,
        isActive = true
    }
    return enter_sandman
end


return Cards