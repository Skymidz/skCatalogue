fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'Skymidz#7333'

-- RageUI V2
client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

-- Client
client_scripts {
    "client/*.lua",
}

-- Server
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
}

-- Shared
shared_scripts {
    "config.lua",
}

escrow_ignore {
    "config.lua"
}
