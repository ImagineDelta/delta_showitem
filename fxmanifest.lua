shared_script "@ReaperV4/bypass.lua"
lua54 "yes" -- needed for Reaper


fx_version 'cerulean'
game 'gta5'
author 'Imagine Delta'
description 'Script to show your inventory or items to nearby players'
lua54 "yes"
version '1.0.0'

escrow_ignore{
    'config.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    '@es_extended/locale.lua',  
    '@oxmysql/lib/MySQL.lua',   
    'config.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'oxmysql',
    --'ox_lib'                   
}
