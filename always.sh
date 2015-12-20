if [ ! -d "/home/$USERNAME/.oh-my-zsh" ]; then
  echo "/home/$USERNAME/.oh-my-zsh doesn't exist. Attempting to install.."
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi