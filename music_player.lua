function play(file_path)
  print(file_path)
  local file = fs.open(file_path, "r")
  local speaker = peripheral.find('speaker')

  -- Vérifier si le fichier est ouvert avec succès
  if not file then
      print("Impossible d'ouvrir le fichier.")
      return
  end
  
  local previousTime = 0  -- Initialiser le temps précédent
  
  -- Lecture et traitement des lignes du fichier
  while true do
    local line = file.readLine()  -- Lire une ligne du fichier
  
    if not line then
      break  -- Sortir de la boucle si toutes les lignes ont été lues
    end
  
    -- Analyser la ligne pour extraire le temps et les notes
    local time, notes = line:match("([%d%.]+),%[(.-)%]")
  
    -- Jouer les notes si le temps est atteint
    local delay = tonumber(time) - previousTime
    
    sleep(delay)
  
    -- Jouer les notes
    for note in notes:gmatch("%((.-)%)") do
      local instrument, pitch = note:match("(%a+), (%d+)")
      speaker.playNote(instrument, 3.0, tonumber(pitch))
    end
  
    previousTime = tonumber(time)  -- Mettre à jour le temps précédent
  end
  
  -- Fermer le fichier
  file.close()
end
