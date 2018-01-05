#!/bin/bash

# Slack bash script https://gist.github.com/andkirby/67a774513215d7ba06384186dd441d9e

file=$(readlink -f "$1")
if [[ ${file: -4} != ".zip" ]]; then
    echo "The file $file is not a zip."
    exit 1
fi

r=$(( RANDOM % 10 ));
wd="$1-$r"

echo "-Deploy on SVN started!"

echo "-Wait few minutes for the procedure!"
cd /tmp/ || exit
mkdir "$wd"
extract="/tmp/$wd/upload"
unzip "$file" -d "$extract" > /dev/null
cd /tmp/ || exit
cd "$wd" || exit

# Get the plugin root file
rootfile=$(grep -R "WordPress-Plugin-Boilerplate-Powered" . | awk -F: '{print $1}')
# Get plugin version
version=$(grep " * Version:" "$rootfile" | awk -F' ' '{print $NF}')

# slack-message "Deploy on WordPress SVN of $version started!"
# Get the domain for WP SVN
wpdomain=$(grep " * Text Domain:" "$rootfile" | awk -F' ' '{print $NF}')

if [ -z "$wpdomain" ]; then
    exit 1
fi

echo "-Cloning SVN locally"
svn co "https://plugins.svn.wordpress.org/$wpdomain" > /dev/null

echo "-Copying new plugin version on SVN locally"
cp -r "$extract/." ./"$wpdomain"/trunk
cp -r "./$wpdomain"/trunk/. "$wpdomain"/tags/"$version"

echo "-Deploying new plugin version on SVN remote"
cd "$wpdomain" || exit
# This command force to add all the files, also if they are new
svn add --force * --auto-props --parents --depth infinity -q > /dev/null
# svn ci -m "tagging version $version"
#
# cd /tmp/ || exit
# slack-message "Deploy on WordPress SVN of $version done!"
# rm -fr "./$wd"
echo " "
echo "-Deploy of the new free version done!"
