# WeScript

The WeScript is a Docker Command Wrapper (`we.sh`) which simplifies the management and execution of Docker containers for different development environments like PHP, Node.js, Composer, and Hugo, utilizing per-project configuration to manage version dependencies precisely.

## Getting Started

These instructions will cover usage information and for the docker command wrapper.

### Prerequisites

- Docker must be installed on your system.
- Bash shell must be available on your system.

### Install (via Makefile)

This project uses a Makefile to automate the setup and removal of the `we` command. The Makefile simplifies the installation and ensures that the script is properly integrated and removed from the user's environment.

1. **Navigate to the Project Directory**:
   Ensure you are in the root directory of the project where the Makefile is located.

2. **Run the Installation**:
   Execute the following command in your terminal:
   ```bash
   sudo make install
   ```
   This command performs the following actions:
   - Copies the sample configuration file to a working configuration file.
   - Makes the `we.sh` script executable.
   - Creates a symbolic link to allow global access to the `we.sh` script.
   - Adds a source line to your shell configuration file (`.bashrc` or `.zshrc`) to ensure the configuration is loaded automatically.

### Install (manual)

1. Clone the repository:
   ```bash
   git clone ssh://git@git.welink.ro:2424/project/internal/tools/wescript.git ~/.wescript

2. Copy the config sample file and modify it to your needs:
   ```bash
   cp config.sample config
   ```

3. Make the script executable:
   ```bash
    chmod +x we.sh
   ```

4. Add the script to your path to use it from anywhere:
    ```bash
    ln -s $(pwd)/we.sh /usr/local/bin/we
    ```

5. Ensure config is loaded everytime you open a new terminal:
    ```bash
    # zsh users should add the line to `~/.zshrc` instead.
    echo "source ~/.wescript/config" >> ~/.bash_profile
    ```

### Uninstall (Makefile)

1. **Run the Uninstallation**:
   Execute the following command in your terminal:
   ```bash
   sudo make uninstall
   ```
   This command performs the following actions:
   - Removes the symbolic link for the `we.sh` script.
   - Deletes the installation directory and all its contents.
   - Cleans up the shell configuration file by removing the line that sources the configuration.

### Configuration
The script can be configured:

1. Using the ```config``` file from you home directory
2. By adding a ```.weconfig``` file in any project directory.


These files can specify versions of the tools you want to use. Below is a sample configuration:

   ```bash
    # .weconfig
    export WE_PHP_VERSION="8.2"
    export WE_NODE_VERSION="22.1.0"
    export WE_COMPOSER_VERSION="latest"
    export WE_HUGO_VERSION="latest"
   ```
Additionally, if you use Node.js and manage versions via `.nvmrc`, `we.sh` will prioritize the version specified there.

### Usage
Run the script by specifying the command corresponding to the environment you wish to run:

   ```bash
    we node npm install
    we php -v
    we composer install
    we artisan migrate
    we hugo new site
    we hugo server
    we hugo build
   ```
### Supported Commands

- `composer`: Runs the Composer Docker container.
- `node`: Runs the Node.js Docker container.
- `php`: Runs the PHP Docker container.
- `artisan`: Runs Laravel Artisan commands using the PHP Docker container.
- `hugo`: Runs the Hugo static site generator.

### Configuration Precedence

1. **Global Configuration (`~/.wescript/config`)**:
    - This is the base configuration for the script and is sourced by `.bashrc` or `.bash_profile` during the shell's initialization.
    - It should define default versions for the environments you frequently use.

2. **Project-Specific Configuration (`.weconfig`)**:
    - This configuration file should be placed in the root directory of your project.
    - When `we` is executed, it checks for the presence of `.weconfig` in the current directory. If found, the script sources this file, overriding the corresponding global settings specified in `~/.wescript/config`.

3. **Tool-Specific Version Files (`.nvmrc` for Node.js)**:
    - For Node.js, the version can additionally be specified using an `.nvmrc` file, which is commonly used with Node Version Manager (NVM).
    - When running Node.js related commands, `we.sh` first looks for an `.nvmrc` file in the current directory. If present, the script reads the Node.js version from this file and uses it, thereby overriding any versions specified in `.weconfig` or the global configuration.
    - This layer is especially useful for projects that require specific Node.js versions and use NVM for version management.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

