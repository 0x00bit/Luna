local Sfx = {}

function Sfx.kanji()
    rolling_stones_kanji = {
        image = love.graphics.newImage('assets/sfx/kanji.png'),
        x = 700,
        y = 250,
        scale = 0.15
    }
    return kanji
end

return Sfx