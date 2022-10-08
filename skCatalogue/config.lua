Config = {}

-- Temps en secondes
Config.TimeEssai = 30

-- true: Une personne par une personne pour tester les véhicules / false: Autant de personne peuvent tester les véhicules
Config.OneByOne = true 

-- "~r~" = Red / "~o~" = Orange / "~y~" = Yellow /  "~g~" = Green / "~b~" = Blue / "~p~" = Purple / "~u~" = Black
Config.Menu = {
    Color = "~g~", 
    rgba = { r = 106, g = 186, b = 105, a = 255}
}

-- https://wiki.rage.mp/index.php?title=Vehicle_Colors
Config.ListColor = {
    { nameColor = "Noir", idColor = 0 },
    { nameColor = "Rouge", idColor = 28 },
    { nameColor = "Orange", idColor = 38 },
    { nameColor = "Jaune", idColor = 89 },
    { nameColor = "Vert", idColor = 92 },
    { nameColor = "Bleu", idColor = 70 },
    { nameColor = "Rose", idColor = 135 }
}

Config.Position = {
    Menu = vector3(-33.580760955811, -1103.6141357422, 26.422359466553),
    SpawnCar = vector3(-42.229545593262, -1100.5158691406, 26.422338485718),
    SpawnCarHeading = 281.20697021484375,
    SpawnCarEssai = vector3(-1691.8533935547, -2838.5244140625, 13.944444656372),
    SpawnCarEssaiHeading = 237.03228759765625,
}

Config.Distance = {
    Marker = 10, 
    Texte = 1.5,
}

