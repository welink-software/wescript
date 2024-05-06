# Variables
INSTALL_DIR = $(HOME)/.wescript
EXECUTABLE_PATH = /usr/local/bin/we
SHELL_RC = $(HOME)/.bash_profile

# Detect Zsh shell
ifeq ($(shell echo $$ZSH_VERSION),)
    SHELL_RC = $(HOME)/.zshrc
endif

.PHONY: install uninstall

install:
	@echo "Creating $(INSTALL_DIR) if it does not exist..."
	mkdir -p $(INSTALL_DIR)
	@echo "Copying project files to $(INSTALL_DIR)..."
	rsync -av --exclude '.git' ./ $(INSTALL_DIR)/
	@echo "Copying configuration sample file..."
	cp $(INSTALL_DIR)/config.sample $(INSTALL_DIR)/config
	@echo "Making the script executable..."
	chmod +x $(INSTALL_DIR)/we.sh
	@echo "Linking the script to be accessible from anywhere..."
	ln -sf $(INSTALL_DIR)/we.sh $(EXECUTABLE_PATH)
	@echo "Configuring shell to load configuration on startup..."
	echo "source $(INSTALL_DIR)/config" >> $(SHELL_RC)
	@echo "Installation completed successfully."

uninstall:
	@echo "Removing the symlink..."
	rm -f $(EXECUTABLE_PATH)
	@echo "Removing the installed directory..."
	rm -rf $(INSTALL_DIR)
	@echo "Cleaning up shell startup script..."
	sed -i '/source $(INSTALL_DIR)\/config/d' $(SHELL_RC)
	@echo "Uninstallation completed successfully."
