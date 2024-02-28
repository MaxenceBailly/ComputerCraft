local totalPages = 1 -- Initialisation à une valeur par défaut
local boutonsParPage -- Déclaration de la variable

local menu = {}

local function afficherMenu(boutons, selection, pageActuelle, titre)
    term.clear()

    local largeur, hauteur = term.getSize()
    
    -- Déterminer le nombre de boutons à afficher à la fois
    boutonsParPage = hauteur - 4
    
    -- Calculer le nombre total de pages
    totalPages = math.ceil(#boutons / boutonsParPage)

    -- afficher le titre
    term.setCursorPos(math.floor((largeur - #titre) / 2), 2)
    print(titre)

    -- Afficher les boutons sur la page actuelle
    for i = (pageActuelle - 1) * boutonsParPage + 1, math.min(pageActuelle * boutonsParPage, #boutons) do
        local bouton = boutons[i]
        -- Afficher le bouton
        if i == selection then
            bouton = ("[".. bouton.. "]")
        end
        term.setCursorPos((largeur-#bouton)/2, (i - (pageActuelle - 1) * boutonsParPage +1)+2) 
        print(bouton)
    end
    
    -- Afficher les flèches de navigation si nécessaire
    if totalPages > 1 then
        -- Afficher la flèche gauche si ce n'est pas la première page
        if pageActuelle > 1 then
            term.setCursorPos(1, hauteur)
            print("<")
        end
        -- Afficher la flèche droite si ce n'est pas la dernière page
        if pageActuelle < totalPages then
            term.setCursorPos(largeur, hauteur)
            print(">")
        end
    end
end

function menu.choisirBouton(boutons, titre)
    local selection = 1
    local pageActuelle = 1 -- Initialisation à la première page
    
    while true do
        afficherMenu(boutons, selection, pageActuelle, titre)
        local event, key = os.pullEvent("key")
        if key == keys.up then
            -- Déplacer la sélection vers le haut
            if selection > 1 then
                selection = selection - 1
                -- Si la sélection est sur le premier bouton de la page actuelle
                -- et que l'utilisateur appuie sur la touche haut, alors passer à la page précédente
                if selection < (pageActuelle - 1) * boutonsParPage + 1 then
                    pageActuelle = pageActuelle - 1
                end
            end
        elseif key == keys.down then
            -- Déplacer la sélection vers le bas
            if selection < #boutons then
                selection = selection + 1
                -- Si la sélection est sur le dernier bouton de la page actuelle
                -- et que l'utilisateur appuie sur la touche bas, alors passer à la page suivante
                if selection > pageActuelle * boutonsParPage then
                    pageActuelle = pageActuelle + 1
                end
            end
        elseif key == keys.left then
            -- Déplacer vers la page précédente
            if pageActuelle > 1 then
                pageActuelle = pageActuelle - 1
                selection = (pageActuelle - 1) * boutonsParPage + 1
            end
        elseif key == keys.right then
            -- Déplacer vers la page suivante
            if pageActuelle < totalPages then
                pageActuelle = pageActuelle + 1
                selection = (pageActuelle - 1) * boutonsParPage + 1
            end
        elseif key == keys.enter then
            -- Retourner le nom du bouton sélectionné
            term.clear()
            return boutons[selection]
        end
    end
end

return menu.choisirBouton
