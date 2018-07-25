ok_move () {
tput cuf 4
tput cuu 1
echo "$(tput setaf 2)ok"
tput cud 1
}

fail_move () {
tput cuf 3
tput cuu 1
echo "$(tput setaf 5)fail"
tput cud 1
}


add_script_to_gamelist () {
if [ -e $1 ]; then #only edit if exists
  #echo "$1 exists"
  if ! grep -q bezelproject $1 ; then #does bezelproject alread exist in file
    sed -i '/<\/gameList>/d' $1
    echo '        <game>' >> $1
    echo '                <path>./bezelproject.sh</path>' >> $1
    echo '                <name>The Bezel Project</name>' >> $1
    echo '                <desc>The Bezel Project Installation Script</desc>' >>$1
    echo '                <image>/home/pi/RetroPie/retropiemenu/icons/bezelproject.png</image>' >> $1
    echo '        </game>' >> $1
    echo '</gameList>' >> $1
  fi
fi
}


#intro
  tput clear
  tput cud 2
  echo "  $(tput setaf 6)$(tput smul)installing The Bezel Project Scripts$(tput rmul)"
  tput cud 2

#download script
  echo "$(tput setaf 7)  [    ] Pulling down menu item"

  #download new version
  cd /home/pi/
  wget -q https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh
  if [ -e /home/pi/bezelproject.sh ]; then

    #remove file if it already exists
    if [ -e /home/pi/RetroPie/retropiemenu/bezelproject.sh ]; then
      rm /home/pi/RetroPie/retropiemenu/bezelproject.sh
    fi

    mv /home/pi/bezelproject.sh /home/pi/RetroPie/retropiemenu/bezelproject.sh
    chmod +x /home/pi/RetroPie/retropiemenu/bezelproject.sh
    ok_move
  else
    fail_move
  fi


#download the graphics
  echo "$(tput setaf 7)  [    ] Pulling down graphics"

  #download new version
  cd /home/pi/
  wget -q https://raw.githubusercontent.com/steveskalley/thebezelproject_resources/master/bezelproject.png
  if [ -e /home/pi/bezelproject.png ]; then

    #remove file if it already exists
    if [ -e /home/pi/RetroPie/retropiemenu/icons/bezelproject.png ]; then
      rm /home/pi/RetroPie/retropiemenu/icons/bezelproject.png
    fi

    mv /home/pi/bezelproject.png /home/pi/RetroPie/retropiemenu/icons/bezelproject.png
    ok_move
  else
    fail_move
  fi

#modify menus
  echo "$(tput setaf 7)  [    ] Adding to Retropie Setup menu"
  if [ -e /home/pi/RetroPie/retropiemenu/bezelproject.sh ]; then
    add_script_to_gamelist /home/pi/gamelist-bkp.xml
    add_script_to_gamelist /home/pi/RetroPie/retropiemenu/gamelist.xml
    add_script_to_gamelist /home/pi/.emulationstation/gamelists/retropie/gamelist.xml
    add_script_to_gamelist /etc/emulationstation/gamelists/retropie/gamelist.xml

    #add shortcut for attractMode
    sudo mkdir /home/pi/RetroPie/roms/setup/
    echo sudo /home/pi/RetroPie/retropiemenu/bezelproject.sh > /home/pi/RetroPie/roms/setup/bezelproject.sh
    #chmod +x /home/pi/RetroPie/roms/setup/bezelproject.sh
    ok_move
  else
    fail_move
  fi



#outro
  tput cud 3
  tput bel
  echo "$(tput setaf 6)  Thank you for installing The Bezel Project"
  echo ""
  echo "  Please configure options through the RetroPie Setup Menu!"

  tput cud 3
  echo "$(tput setaf 7) Done.."
  tput sgr0
