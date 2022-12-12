fx_version 'cerulean'
game 'gta5'

author 'Delbes'
description 'https://lambra.tebex.io'

shared_scripts {
    'config.lua'
}

client_script 'client/main.lua'

server_script '@oxmysql/lib/MySQL.lua'
server_script 'server/main.lua'

lua54 'yes'

escrow_ignore {
    'config.lua',
}