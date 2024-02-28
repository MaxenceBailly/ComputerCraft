local buttons = {"Back"}
local music = {}
local music_to_play = nil

local fichiers = fs.list('music/all')
for i, fichier in ipairs(fichiers) do
    local fichierSansExtension = fichier:gsub("%..-$", "")
    table.insert(buttons, fichierSansExtension)
    table.insert(music, fichierSansExtension)
end

local menu = require("menu")
local option = menu(buttons, 'All Music')

local function play_music()
    os.loadAPI("music_player.lua")
    music_player.play(music_to_play)
end

local function music_menu()
    shell.run('music.lua')
end

if option == "" then
    shell.run('play_all.lua')

elseif option == "Back" then
    shell.run('music.lua')

elseif table.concat(music, ","):find(option) then
    music_to_play = 'music/all/'..option..'.txt'
    parallel.waitForAll(play_music, music_menu)
else
    term.setCursorPos(1, 1)
    print('Not available')
    sleep(2)
    shell.run('play_all.lua')
end
