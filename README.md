QuickBot
-------------------------
Bot de telegram usando API conexiones.

Más información en la [API de Telegram](https://core.telegram.org/bots/api).


Clonar repositorio:

```bash
# Clonar QuickBot
git clone https://github.com/jarriztg/QuickBot mi_bot
```
Instalar dependencias:

```bash
sudo apt-get update && sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev make unzip git redis-server g++ libjansson-dev libpython-dev expat libexpat1-dev tmux subversion && wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz && tar zxpf luarocks-2.2.2.tar.gz && cd luarocks-2.2.2 && sudo ./configure && sudo make bootstrap && sudo luarocks install luasocket && sudo luarocks install luasec && sudo luarocks install redis-lua && sudo luarocks install lua-term && sudo luarocks install serpent && sudo apt-get install curl && cd .. && sudo rm -Rf luarocks-2.2.2.tar.gz && sudo rm -Rf luarocks-2.2.2 
 ```
 
 Instalar dkjson:
 ```bash
 sudo apt-get install lua-dkjson -y
 ```
 
Iniciar QuickBot: 

```bash
cd mi_bot
./run.sh
```

Ingresas a ``data/key`` y reemplazas toda la linea por el token que te dió [@botfather](http://telegram.me/botfather)

Despúes, el bot ya estará funcionando si lo haz configurado bien, cualquier falla vuelvelo a configurar.



Más funciones del bash:

```bash
# Iniciar una sesión tmux
./run.sh

# Detener la sesiones (script de lectura de gbans, script del bot. Tmux y sesión segura)
./run.sh kill

# Sesión segura (tmux)
./run.sh secure # previene cierres inesperados pero se recomienda no tener errores de código porque generará un bucle

# Attach del bot (regresar a la sesión del bot. Tmux)
./run.sh attach

# Attach de los gbans (regresar a la sesión de los gbans. Tmux)
./run.sh attach gbans

# Attach de sesión segura
./run.sh attach secure
```




Envia tus pullrequest para mejorar el código.




--------------------
[![https://telegram.me/jarriz](https://img.shields.io/badge/Telegram-%40Jarriz-green.svg)](https://telegram.me/jarriz)
[![https://telegram.me/jarriz](https://img.shields.io/badge/Chat-soporte-orange.svg)](https://telegram.me/equipoQuickSilver)
