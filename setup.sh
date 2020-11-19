#!/bin/bash
# Setup script for Ubuntu. Run from ~/ directory.
sudo apt update && sudo apt upgrade -y 
remove_games() {
    GAMES=( gnome-tetravex gnome-sudoku swell-foop gnome-chess gnome-mines gnome-mahjongg gnome-nibbles gnome-books gnome-klotski gnome-robots gnome-taquin )
    for i in "${GAMES[@]}";do sudo apt remove -y $i; done; sudo apt autoremove -y
}
echo -e "\n"
echo -e "Removing games..\n"
remove_games
TOOLS=(curl forensics-full git gnome golang ipython3 ncrack net-tools python3-pip smbclient sqlmap terminator tmux vim wifite)
install_tools () {
    for i in "${TOOLS[@]}";do sudo apt install -y $i; done
    go get github.com/OJ/gobuster    
    echo -n "Install sublime-text? y/n "
    read INSTALL_SUBLIME
    if [[ $INSTALL_SUBLIME = 'y' ]]; then
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        sudo apt-get install apt-transport-https
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        sudo apt-get update
        sudo apt-get install sublime-text
        elif [[ $INSTALL_SUBLIME = 'n' ]]; then :
    fi
}
echo ${TOOLS[@]}
echo -ne "Install tools? y/n "
read INSTALL_TOOLS
if [[ $INSTALL_TOOLS = 'y' ]]; then
    install_tools
    elif [[ $INSTALL_TOOLS = 'n' ]]; then :
fi
# tmux.conf and vimrc from github
echo -e "\n\n"
echo "downloading tmux.conf and vimrc.."
curl https://raw.githubusercontent.com/finallybrethren/tmux.conf/master/.tmux.conf?token=ALH2SZEKAVHR7R6BNCFSC3C7WXKRYO -o .tmux.conf
curl https://raw.githubusercontent.com/finallybrethren/.vimrc/main/.vimrc -o .vimrc
install_vimplug () {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
    vim
}
echo -n "Install vimplug? y/n "
read INSTALL_VIMPLUG
if [[ $INSTALL_VIMPLUG = 'y' ]]; then
    install_vimplug
    elif [[ $INSTALL_VIMPLUG = 'n' ]]; then :
fi
dropbox_installation () {
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    ~/.dropbox-dist/dropboxd
    echo -n "Download dropbox.py? "
    read DOWNLOAD_DBSCRIPT
    if [[ $DOWNLOAD_DBSCRIPT = 'y' ]]; then
        xdg-open https://www.dropbox.com/download?dl=packages/dropbox.py
        elif [[ $DOWNLOAD_DBSCRIPT = 'n' ]]; then :
    fi
    echo -n "Add dropbox.py to PATH? (make sure dropbox.py is in ~/Downloads) "
    read PATH_DBSCRIPT
    if [[ $PATH_DBSCRIPT = 'y' ]]; then
        chmod +x ~/Downloads/dropbox.py 
        mv ~/Downloads/dropbox.py ~/Downloads/dropbox
        sudo mv ~/Downloads/dropbox /usr/local/bin
        elif [[ $PATH_DBSCRIPT = 'n' ]]; then :
    fi
}
echo -n "Install dropbox? y/n "
read INSTALL_DROPBOX
if [[ $INSTALL_DROPBOX = 'y' ]]; then
    dropbox_installation
    elif [[ $INSTALL_DROPBOX = 'n' ]]; then :
fi
change_background () {
    echo -n "Enter url for background image: "
    read SRC_URL
    echo -n "Rename background: "
    read BACKGROUND_NAME
    FNAME="/home/nick/Pictures/$BACKGROUND_NAME"
    wget "$SRC_URL" -O "$FNAME"
    gsettings set org.gnome.desktop.background picture-uri file:////home/nick/Pictures/$BACKGROUND_NAME
}
echo -n "choose background from web? y/n "
read CHANGE_BACKGROUND
if [[ $CHANGE_BACKGROUND = 'y' ]]; then                                                                                                                                      
    change_background
    elif [[ $CHANGE_BACKGROUND = 'n' ]]; then :
fi
