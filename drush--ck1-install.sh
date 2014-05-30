#!/bin/bash
# Download and install a fresh kickstart 1 site in the current directory.

handle="commerce_kickstart"
identifier=$handle
name="Commerce Kickstart"

# Process arguments
while [ "$1" != "" ]; do
  case $1 in 
    -v | --version ) shift
                    # Set version handle.
                    ck_version=$1
                    handle="$handle-7.x-$ck_version"
                    ;;
    -i | --identifier ) shift
                    # Site identifier; used for database name as well as directory name.
                    identifier=$1;
                    ;;                    
    -n | --name ) shift
                    # Site name.
                    name=$1;
                    ;;
    * ) break ;;
  esac
  shift
done

# Download Commerce Kickstart if it is not already present and we are not already in a 
# Drupal root.
drupal_version=`drush status drupal-version --format=list`
if [ -z $drupal_version ] && [ ! -d $handle ] && [ ! -d $identifier ];
then
  echo "Downloading Commerce Kickstart ..."
  drush dl $handle
fi

# If we are above the Drupal root directory, change its name to the identifier arg.
if [ -d $handle ]
then
  back=${PWD}

  if [ ! -d $identifier ] 
  then
    mv -f $handle $identifier
  fi
fi

# If the site directory exists, move into it.
if [ -d $identifier ]
then
  cd $identifier
fi

db_name=`drush status --fields=db-name`
db_url=""
# If there are no database settings for this installation, define them now.
if [ -z "$db_name" ]
then
  # Set the identifier as the database name.
  db_url="--db-url=mysql://root:toor@localhost:8889/$identifier"
fi

# Install the site.
drush si -y commerce_kickstart $db_url --account-mail='dan@commerceguys.com' --account-name='dan' --account-pass='root' --site-name="$name" --site-mail='dan@commerceguys.com' install_configure_form.update_status_module='array(FALSE,FALSE)'

# Install standard development tools
drush dl devel admin_menu
drush en -y devel admin_menu_toolbar
drush dis -y toolbar

# Go back to the directory we were just in, if necessary.
if [ ! -z "$back" ] 
then 
  cd $back
fi
