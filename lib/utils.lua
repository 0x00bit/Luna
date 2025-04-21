local lib = {}

-- DRAW LIFE BAR 

function lib.drawHPBar(entity, barWidth, barHeight)
    -- Garante que o HP nunca seja negativo
    local currentHp = math.max(0, entity.hp)
    local healthRatio = currentHp / entity.maxHp

    local spriteWidth = entity.sprite:getWidth()
    local barX = entity.x + spriteWidth / 2 - barWidth / 1.1
    local barY = entity.y - 40  -- Ajuste vertical

    -- Fundo preto da barra
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

    -- Barra de vida (só desenha se HP > 0)
    if currentHp > 0 then
        -- Cor gradiente conforme o HP
        if healthRatio > 0.5 then
            love.graphics.setColor(0, 1, 0)  -- Verde
        elseif healthRatio > 0.25 then
            love.graphics.setColor(1, 1, 0)  -- Amarelo
        else
            love.graphics.setColor(1, 0, 0)  -- Vermelho
        end
        
        love.graphics.rectangle("fill", barX, barY, barWidth * healthRatio, barHeight)
    end

    -- Moldura branca
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", barX, barY, barWidth, barHeight)

    -- Texto do HP (sempre mostra, mesmo com HP zero)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(math.floor(currentHp) .. "/" .. entity.maxHp, 
                        barX, barY + barHeight + 2, barWidth, "center")
end

-- SHOW THE CARD

function lib.createImageButton(params)
    params = params or {}  -- Correct table initialization
    local btn = {  -- Correct table initialization
        -- Position and size
        x = params.x or 0,
        y = params.y or 0,
        scale = params.scale or 0.18,
        
        -- Single image
        image = params.image or love.graphics.newImage("assets/buttons/default.png"),
        
        -- Click handler
        onClick = params.onClick or function() end  -- Note the comma
    }  -- Properly closed table
    
    -- Calculate dimensions
    btn.width = btn.image:getWidth() * btn.scale
    btn.height = btn.image:getHeight() * btn.scale
    
    function btn:containsPoint(px, py)
        return px > self.x and px < self.x + self.width and
               py > self.y and py < self.y + self.height
    end
    
    function btn:draw()
        love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
    end
    
    function btn:mousePressed(x, y, button)
        if button == 1 and self:containsPoint(x, y) then
            self.onClick()
            return true
        end
        return false
    end

    return btn
end

function lib.drawMana(obj, x, y, size, spacing)
    -- Handle both player object or mana object
    local mana = obj.mana or obj
    
    -- Safety checks
    if not mana or not mana.max or not mana.current then
        print("Warning: Invalid mana object in drawMana")
        return
    end
    
    love.graphics.setColor(0.2, 0.4, 1) -- Blue color
    
    -- Draw filled squares for current mana
    for i = 1, mana.current do
        love.graphics.rectangle("fill", x + (i-1)*(size + spacing), y, size, size)
    end
    
    -- Draw outline squares for empty mana
    for i = mana.current + 1, mana.max do
        love.graphics.rectangle("line", x + (i-1)*(size + spacing), y, size, size)
    end
    
    love.graphics.setColor(1, 1, 1) -- Reset color
end


return lib
