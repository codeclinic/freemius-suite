# Freemius Suite

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c616b55e9b534e13b9e8fe30ff624e19)](https://www.codacy.com/app/mte90net/freemius-suite?utm_source=github.com&utm_medium=referral&utm_content=CodeAtCode/freemius-suite&utm_campaign=badger)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)   

The focus of this project is to have a suite of scripts that automatate some of the process of deploying new versions of a plugin via Freemius and WordPress SVN.

### Requirements

* crudini (parse the config.ini easily from bash)
* php-cli
* jq on OSX
* slack-message (bash script): https://gist.github.com/andkirby/67a774513215d7ba06384186dd441d9e

## deploy.sh

This script uses the `config.ini` file to get settings such as; dev, id, etc.  

`deploy.sh [your-section]`

Automatically execute the script suite to deploy on Freemius, and the free version on the WordPress SVN

## package.sh

This script generates a zip package ready to be uploaded on Freemius.  
It also switches from Fake_Freemius if in this is enabled.  
Generates a zip in to the working directory where the plugin is executed.

`package.sh [plugin-folder] [plugin-root-filename]`

* The first parameter is the plugin folder, if not set use the current working directory.
* The second parameter is the root filename of the plugin (where there are the Plugin Header Comments) without the extension, if not set use the plugin folder name.

## release.sh

This script from a zip file, unzip the package and push a new version of WP SVN.  
It use internally the string `WordPress-Plugin-Boilerplate-Powered` to find the plugin root file, so change based on your needs.

`package.sh [plugin-file-zip]`

* The first parameter is the zip of the plugin.

## deploy.php

This script requires a `config.ini` with the user id, the public key and secret key, and the plugins to deploy (with path).  

`deploy.php [user] []pubkey [secretkey] [zip-file] [freemius-plugin-id] [sandbox:true|false] [version] [releasemode:pending|beta|released]`

The script will download the API wrapper in PHP of Freemius, next execute `package.sh` (that will get the parameters from the config.ini).  
Will execute the deploy system using the official API to upload and download the package.
