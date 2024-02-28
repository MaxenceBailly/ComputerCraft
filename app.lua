local menu = require("menu")
local option = menu({"Factory", "Storage", "Game", "Music", "Turtle Manager", "Calculator", "GPS"}, 'App')

if option == "Music" then
    shell.run('music.lua')
else
    term.setCursorPos(1, 1)
    print('Not available')
    sleep(2)
    shell.run('app.lua')
end
