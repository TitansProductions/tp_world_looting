fx_version 'bodacious'
game 'gta5'

author 'Nosmakos'
description 'Titans Productions World Looting'
version '2.1.0'

ui_page 'html/index.html'

shared_script '@es_extended/imports.lua'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'server/tp-server_main.lua',
    'server/tp-server_inventory.lua',
}

client_scripts {
    '@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'client/tp-client_main.lua',
    'client/tp-client_inventory.lua'
}

files {
	'html/index.html',
	'html/js/script.js',
	'html/css/*.css',
	'html/font/Prototype.ttf',
    'html/img/background.jpg',
}

dependency 'es_extended'