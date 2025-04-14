#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
                   __      __      
  ____ _____ _____/ /___  / /______
 / __ `/ __ `/ __  / __ \/ __/ ___/
/ /_/ / /_/ / /_/ / /_/ / /_(__  )  Arch Linux System Crafting Tool
\__,_/\__,_/\__,_/\____/\__/____/   by: aaditron

EOF
}

# Clear screen and show logo
clear
print_logo

# Exit on any error
set -e

# Source utility functions
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

echo "Starting system setup..."

# Update the system first
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install yay AUR helper if not present
if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  echo "building yay.... yaaaaayyyyy"
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

# Install packages by category
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system maintenance tools..."
install_packages "${MAINTENANCE[@]}"

echo "Installing desktop environment..."
install_packages "${DESKTOP[@]}"

echo "Installing office packages..."
install_packages "${OFFICE[@]}"

echo "Installing media packages..."
install_packages "${MEDIA[@]}"

echo "Installing yay packages..."
yay -S --noconfirm "${YAY[@]}"


# Enable services
echo "Configuring services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &> /dev/null; then
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled"
  fi
done

# Install gnome specific things to make it like a tiling WM
echo "Setup complete! You may want to reboot your system."
