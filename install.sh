#!/bin/bash
set -e

# Welcome text
echo "Welcome to the installer for eltechnical/dotfiles (https://github.com/eltechnical/dotfiles)"
sleep 1

# Confirmation
read -p "Do you want to install my dotfiles? (y/n) " answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  echo "Installing dotfiles"
  sleep 1

  # Updating Arch Linux and installing required components
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm git base-devel

  # Install yay (AUR helper) if not already present
  if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si --noconfirm)
    rm -rf yay
  fi

  # Install packages
  yay -S --noconfirm hyprland waybar rofi swaync neovim zsh neofetch nitch swww pfetch \
    xdg-desktop-portal xdg-desktop-portal-hyprland pipewire pipewire-pulse pipewire-jack \
    pipewire-alsa nwg-look

  # Oh My Zsh + Powerlevel10k
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

  # Clone dotfiles repo if missing
  if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/eltechnical/dotfiles.git ~/dotfiles
  fi

  # Install dotfiles
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

  echo "Done! Restart your session to apply changes."
else
  echo "Not installing"
  exit 0
fi
