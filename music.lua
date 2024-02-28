local menu = require("menu")
local option = menu({"Play all", "Playlists", "Back"}, 'Music')

if option == "Play all" then
    shell.run('play_all.lua')
elseif option == "Back" then 
    shell.run('app.lua')
else
    term.setCursorPos(1, 1)
    print('Not available')
    sleep(2)
    shell.run('music.lua')
end
