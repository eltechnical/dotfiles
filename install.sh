#!/bin/bash
set -e

# Welcome text
echo "Welcome to the installer for eltechnical/dotfiles (https://github.com/eltechnical/dotfiles)"
# Delay for 1 second
sleep 1
# Confirmation
read -p "Do you want to install my dotfiles? (y/n) " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  echo "Installing dotfiles"
  sleep 1
  # Updating of Arch Linux and installation of required components.
  yes | sudo pacman -Syu --noconfirm
  sleep 1
  yes | sudo pacman -S --needed --noconfirm git base-devel
  sleep 1
  # grab yay if we don't already have it
  if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git
    sleep 1
    cd yay
    sleep 1
    yes | makepkg -si --noconfirm
    sleep 1
    cd ..
    rm -rf yay
    sleep 1
  fi
  yes | yay -S --noconfirm hyprland waybar rofi swaync neovim zsh neofetch nitch swww pfetch xdg-desktop-portal xdg-desktop-portal-hyprland pipewire pipewire-pulse pipewire-jack pipewire-alsa nwg-look
  sleep 1
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sleep 1
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
  sleep 1
  # pull down the dotfiles repo if it's not already there
  if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/eltechnical/dotfiles.git ~/dotfiles
  fi
  # Installation of dotfiles
  mkdir -p ~/.config ~/.themes ~/.icons
  cp -r ~/dotfiles/gtk-3.0 ~/.config
  cp -r ~/dotfiles/gtk-4.0 ~/.config
  cp -r ~/dotfiles/hypr ~/.config
  cp -r ~/dotfiles/waybar ~/.config
  cp -r ~/dotfiles/rofi ~/.config
  cp -r ~/dotfiles/nvim ~/.config
  cp -r ~/dotfiles/swaync ~/.config
  cp -r ~/dotfiles/themes ~/.themes
  cp -r ~/dotfiles/icons ~/.icons
  cp ~/dotfiles/zshrc ~/.zshrc
else
  echo "Not installing"
  exit 0
fi
