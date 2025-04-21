local Sfx = require("lib.sfx")
local utils = require("lib.utils")

-- Change the state of the game to the ENEMY'S turn
function startEnemyTurn()
    Game.currentState = Game.states.ENEMY_TURN
    Game.turn.turnCount = Game.turn.turnCount + 1
    
    -- Enemy makes decision after a short delay (for better gameplay feel)
    Game.turn.enemyTimer = 1.0 -- 1 second delay before enemy acts
end

-- Execute an action (attack / defense - not implemented yet)
function executeAction(action)
    if action.type == "attack" then
        local attacker = action.source == "player" and Game.player.character or Game.enemy.character
        local target = action.target == "player" and Game.player.character or Game.enemy.character
        
        -- Calculate base damage (use card's damage or default to 5)
        local damage = action.damage or 12
        
        -- Apply defense if it's an enemy attack and player has defense active
        if action.source == "enemy" and action.name == "ironPunch" then
            if action.source == "enemy" and Game.player.defenseActive then
                damage = damage * (1 - Game.player.defenseActive)  -- Changed to 1 - defenseActive
                Game.player.defenseActive = nil  -- Defense only lasts one turn
                print("Defense reduced damage to:", damage)  -- Debug output
            end
        elseif action.source == "enemy" and action.name == "powerClaw" then
            local damage = action.damage or 15
            if action.source == "enemy" and Game.player.defenseActive then
                damage = damage * (1 - Game.player.defenseActive)  -- Changed to 1 - defenseActive
                Game.player.defenseActive = nil  -- Defense only lasts one turn
                print("Defense reduced damage to:", damage)  -- Debug output
            end
        elseif action.source == "enemy" and action.name == "defense" then
            if action.source == "player" then
                damage = damage * 0.5 -- Changed to 1 - defenseActive
            end
        end
        
        -- Apply the damage
        target.hp = target.hp - damage
        
        -- Ensure HP doesn't go below 0
        target.hp = math.max(0, target.hp)
        
        print(string.format("%s dealt %d damage to %s", action.source, damage, action.target))  -- Debug
        
    elseif action.type == "defense" then  -- Note: Fix typo from "defense" to "defense" if needed
        -- Set up defense for next enemy attack
        Game.player.defenseActive = action.shield or 0.3  -- 0.3 means 30% reduction
        print("Defense activated! Next attack will be reduced by", Game.player.defenseActive * 100, "%")
    end
end

  -- Function responsible to make the enemy chose an attack randomly
function enemyMakeDecision()
    -- Simple AI: pick a random attack
    local attacks = {"ironPunch", "powerClaw", "defense", "powerClaw"} -- Add more as you implement them
    local chosenAttack = attacks[math.random(#attacks)]
    
    -- Execute the enemy attack
    Game.turn.selectedAction = {
        type = "attack",
        name = chosenAttack,
        source = "enemy",
        target = "player"
    }
    
    executeAction(Game.turn.selectedAction)
    
    -- Immediately return to player turn
    Game.currentState = Game.states.PLAYER_TURN
end

  -- TURN COUNTER
function nextTurn()
    Game.turn.turnCount = Game.turn.turnCount + 1
    
    if Game.currentState == Game.states.PLAYER_TURN then
        Game.currentState = Game.states.ENEMY_TURN
        Game.turn.enemyDecided = false
    else
        Game.currentState = Game.states.PLAYER_TURN
    end
end


function animationsComplete()
    -- Check if all attack/effect animations are done
    return true -- Replace with actual check
end

function love.load()
    -- LIBRARIES
    local Animations = require("lib.animations")
    local Moonsters = require("lib.moonsters")
    local Cards = require("lib.cards")

    
    playerCharacter = Moonsters.newFireCration()
    enemyCharacter = Moonsters.newCaesar()

    -- Initialize game state
    Game = {
        settings = {
            screenWidth = 1366,
            screenHeight = 768,
            background = love.graphics.newImage("assets/backgrounds/backgroundc.png"),
            win_screen = love.graphics.newImage("assets/backgrounds/winscreen.png"),
            defeat_screen = love.graphics.newImage("assets/backgrounds/def2.png"),
            draw_screen = love.graphics.newImage("assets/backgrounds/drawscreen.png")
        },
        
        player = {
            character = Moonsters.newFireCration(),
            stand = Moonsters.newAceSpades(),
            animations = {},
            defenseActive = nil,
            -- Mana's player
            mana = {
                max = 3,      -- Maximum mana
                current = 3,   -- Current mana
                visible = true -- Whether mana is visible
            }
        },
        
        enemy = {
            character = Moonsters.newCaesar(),
            stand = Moonsters.newRollingStones(),
            kanji = {
                image = love.graphics.newImage("assets/sfx/kanji.png"),
                x = 730,
                y = 380,
                animations = {}
            }

        },

        cards = {
            ironFist = Cards.newIronFist(),
            overkill = Cards.newOverkill(),
            entersandman = Cards.newEnterSandman()
        },
        
        sfx = {
            kanji = Sfx.kanji()
        },

        turn = {
            state = "player", -- or "enemy"
            phase = "select", -- "select", "execute", "animation"
            selectedAction = nil,
            turnCount = 0
        }
    }


    -- GAME STATES
    Game.states = {
        PLAYER_TURN = "player_turn",
        ENEMY_TURN = "enemy_turn",
        ANIMATION = "animation",
        VICTORY = "victory",
        DEFEAT = "defeat"
    }

    -- Setup window
    love.window.setMode(Game.settings.screenWidth, Game.settings.screenHeight)  -- Window size
    love.window.setTitle("Luna")  -- Window Title
    love.window.setIcon(love.image.newImageData("assets/icons/gameicon.png"))

    -- Initialize animations
    Game.player.stand.animations.float = Animations.createFloatAnimation({
        amplitude = 6,
        speed = 2,
        offset = math.random() * 2 * math.pi
    })
    
    Game.enemy.kanji.animations.shake = Animations.createShakeAnimation({
        amplitude = 6,
        x = 760,
        y = 250,
        speed = 2,
        offset = math.random() * 2 * math.pi
    })

    -- Initialize animation targets
    Game.player.stand.animations.float:init(Game.player.stand)
    Game.enemy.kanji.animations.shake:init(Game.enemy.kanji)
    Game.currentState = Game.states.PLAYER_TURN

    Game.cards.overkill.visible = true
    Game.cards.ironFist.visible = true
    Game.cards.entersandman.visible = true


end

function love.update(dt)

    -- Player Instance
    local p = Game.player
    -- Enemy Instance
    local e = Game.enemy

    local state = "battle"

    -- Update animations
    p.stand.animations.float:update(dt, p.stand)
    e.kanji.animations.shake:update(dt, e.kanji)
    
    -- PLAYER TURN
    if Game.currentState == Game.states.PLAYER_TURN then
        
    elseif Game.currentState == Game.states.ENEMY_TURN then
        if Game.turn.enemyTimer then
            Game.turn.enemyTimer = Game.turn.enemyTimer - dt
            if Game.turn.enemyTimer <= 0 then
                Game.turn.enemyTimer = nil
                enemyMakeDecision()
            end
        end
    elseif Game.currentState == Game.states.ANIMATION then
        if animationsComplete() then
            nextTurn()
        end

    elseif Game.currentState == Game.states.VICTORY then

    elseif  Game.currentState == Game.states.DEFEAT then
        
    end

    -- win/lose conditions
    if e.character.hp <= 0 then
        Game.currentState = Game.states.VICTORY
    elseif p.character.hp <= 0 then
        Game.currentState = Game.states.DEFEAT
    end
end

function love.draw()
    local p = Game.player
    local e = Game.enemy
    
    --Game.currentState = Game.states.PLAYER_TURN

    -- Draw background
    love.graphics.draw(Game.settings.background, 0, 0, 0)

    -- Draw player and stand
    love.graphics.draw(p.character.sprite, p.character.x, p.character.y, 0, 0.5, 0.5)
    love.graphics.draw(p.stand.image, p.stand.x, p.stand.y, 0, 0.3, 0.3)

    -- Draw enemy and stand
    love.graphics.draw(e.character.sprite, e.character.x, e.character.y, 0, 0.5, 0.5)
    love.graphics.draw(e.stand.image, e.stand.x, e.stand.y, 0, 0.3, 0.3)
    love.graphics.draw(e.kanji.image, e.kanji.x, e.kanji.y, 0, 0.15, 0.15)
    

    -- Draw UI elements
    utils.drawHPBar(p.character, 300, 12)
    utils.drawHPBar(e.character, 300, 12)
    
    -- MANA
    if Game.player.mana and Game.player.mana.visible then
        utils.drawMana(Game.player, 50, 5, 15, 5)
    end



    -- Draw cards
    love.graphics.draw(Game.cards.ironFist.image, Game.cards.ironFist.x, Game.cards.ironFist.y, 0, 0.18, 0.18)
    love.graphics.draw(Game.cards.overkill.image, Game.cards.overkill.x, Game.cards.overkill.y, 0, 0.18, 0.18)
    love.graphics.draw(Game.cards.entersandman.image, Game.cards.entersandman.x, Game.cards.entersandman.y, 0, 0.18, 0.18)

    local turnText = Game.currentState == Game.states.PLAYER_TURN and "Your Turn" or "Enemy's Turn"
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print(turnText, 50, 50)
    
    -- Draw victory/defeat messages
    if Game.currentState == Game.states.VICTORY then
        love.graphics.draw(Game.settings.win_screen, 0, 0, 0)

    elseif Game.currentState == Game.states.DEFEAT then
        love.graphics.draw(Game.settings.defeat_screen, 0, -200, 0)
    end

end

function love.mousepressed(x, y, button)
    if Game.currentState == Game.states.PLAYER_TURN and button == 1 then
        local ironFist_card = Game.cards.ironFist
        if x >= ironFist_card.x and x <= ironFist_card.x + ironFist_card.image:getWidth() * 0.18 and
           y >= ironFist_card.y and y <= ironFist_card.y + ironFist_card.image:getHeight() * 0.18 then
           
            -- Player selected an attack
            Game.turn.selectedAction = {
                type = "attack",
                name = ironFist_card.name,
                damage = ironFist_card.attack,
                shield = ironFist_card.defense,
                source = "player",
                target = "enemy"
            }
            
            -- Execute player attack immediately
            executeAction(Game.turn.selectedAction)
            
            -- Immediately start enemy turn (no animation wait)
            startEnemyTurn()

        end    
        
        -- In love.mousepressed, for Overkill card:
        local Overkill_card = Game.cards.overkill
        if x >= Overkill_card.x and x <= Overkill_card.x + Overkill_card.image:getWidth() * 0.18 and
        y >= Overkill_card.y and y <= Overkill_card.y + Overkill_card.image:getHeight() * 0.18 then
        
            -- Check if player has mana and card is visible
            if Game.player.mana.current > 0 and Overkill_card.visible then
                Game.turn.selectedAction = {
                    type = "attack",
                    name = Overkill_card.name,
                    damage = Overkill_card.attack,
                    source = "player",
                    target = "enemy"
                }
                
                executeAction(Game.turn.selectedAction)
                
                -- Consume one mana
                Game.player.mana.current = Game.player.mana.current - 1
                
                -- Hide card if no mana left
                if Game.player.mana.current <= 0 then
                    Overkill_card.visible = false
                end
                
                startEnemyTurn()
            end            
        end

        local entersandman = Game.cards.entersandman
        if x >= entersandman.x and x <= entersandman.x + entersandman.image:getWidth() * 0.18 and
           y >= entersandman.y and y <= entersandman.y + entersandman.image:getHeight() * 0.18 then
           
            -- Player selected an attack
            Game.turn.selectedAction = {
                type = "defense",
                name = entersandman.name,
                damage = entersandman.attack,
                shield = entersandman.defense,
                source = "player",
                target = "enemy"
            }

            Game.player.defenseActive = 0.15
            
            -- Execute player attack immediately
            executeAction(Game.turn.selectedAction)
            
            -- Immediately start enemy turn (no animation wait)
            startEnemyTurn()            
        end
    end
end
