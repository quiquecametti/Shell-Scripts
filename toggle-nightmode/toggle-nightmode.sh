#!/bin/bash
#!/bin/zsh

# Simple script to toggle between two themes. Currently used to switch between a dark and a light theme
sleep 0.2 # Used for keybind to work
light_theme="Yaru-Blue-light"
dark_theme="Yaru-Blue-dark"

# Light mode theme. Replace names your desired theme names.
lightmode () {
    gsettings set org.gnome.shell.extensions.user-theme name 'Yaru-Blue'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-Blue-light'
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru-Blue'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-Deepblue'
}

# Dark mode theme. Replace names your desired theme names.
darkmode () {
    gsettings set org.gnome.shell.extensions.user-theme name 'Yaru-Blue-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-Blue-dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru-Blue'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-Deepblue'
}

toggleModes () {
    theme=$(gsettings get org.gnome.desktop.interface gtk-theme) # Theme currenty in use
    if [ "$theme" = "'$light_theme'" ]; then
        darkmode
    elif [ "$theme" = "'$dark_theme'" ]; then
        lightmode
    fi # If current theme isn't in any of the theme modes, don't do anything
}

toggleModes