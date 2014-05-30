#!/bin/bash

# Process arguments
while [ "$1" != "" ]; do
  case $1 in 
    -v | --views_includes )
    				# Provision includes/views directory and files
                    views=true;
                    ;;
    -r | --rules_includes )
    				# Provision .rules.inc and .rules_defaults.inc
                    rules=true;
                    ;;
    -i | --entity_info )
    				# Provision .info.inc
                    entity_info=true;
                    ;;
    --install )
    				# Provision .install
                    install_file=true;
                    ;;                                   
    * ) break ;;
  esac
  shift
done

name=$1

if [ -z $name ]
then
  echo "Error: you must provide a name"
  exit
fi

back=${PWD}

# Create the module directory
if [ ! -d $name ]
then
  mkdir $name
fi

cd $name

# .module
touch "$name.module"
cat > "$name.module" <<EOF
<?php
EOF

# .info
touch "$name.info"
cat > "$name.info" <<EOF
name = ""
description = ""
core = 7.x
EOF

# .info.inc
if [ ! -z $entity_info ]
then
  touch "$name.info.inc"
  cat > "$name.info.inc" <<EOF
<?php

/*
 * Implements hook_entity_property_info_alter().
 */
function %name_entity_property_info_alter(&\$info) {

}
EOF
fi

# .install
if [ ! -z $install_file ]
then
  touch "$name.install"
  cat > "$name.install" <<EOF
<?php

/*
 * Implements hook_install().
 */
function %name_install() {

}
EOF
fi

# Rules
if [ ! -z $rules ]
then
  
  # .rules.inc
  touch "$name.rules.inc"
  cat > "$name.rules.inc" <<EOF
<?php

/*
 * Implements hook_rules_action_info().
 */
function %name_rules_action_info() {

}

/*
 * Implements hook_rules_condition_info().
 */
function %name_rules_condition_info() {

}
EOF
  
  # .rules_defaults.inc
  touch "$name.rules_defaults.inc"
  cat > "$name.rules_Defaults.inc" <<EOF
<?php

/*
 * Implements hook_default_rules_configuration().
 */
function %name_default_rules_configuration() {

}
EOF
fi

# Views
if [ ! -z $views ]
then
  # includes
  if [ ! -d "includes" ]
  then
    mkdir includes
  fi

  # includes/views
  if [ ! -d "includes/views" ]
  then
    mkdir includes/views
  fi
  
  # includes/views/handlers
  if [ ! -d "includes/views/handlers" ]
  then
    mkdir includes/views/handlers
  fi  
   
  # views.inc
  touch "includes/views/$name.views.inc"
  cat > "includes/views/$name.views.inc" <<EOF
<?php

/*
 * Implements hook_views_data_alter().
 */
function %name_views_data_alter(\$data) {

}

/*
 * Implements hook_views_datar().
 */
function %name_views_data() {

}
EOF
  
  # .views_default.inc
  touch "includes/views/$name.views_default.inc"
  cat > "includes/views/$name.views_default.inc" <<EOF
<?php

/*
 * Implements hook_views_default_views().
 */
function %name_views_default_views() {

}
EOF

  # Views api declaration
  cat >> "$name.module" <<EOF

/*
 * Implements hook_views_api().
 */
function %name_views_api()  {
  return array(
    'api' => 3,
    'path' => drupal_get_path('module', '%name') . '/includes/views',
  );
}
EOF
fi

# Replace any %name with the module machine name
find . -type f -print0 | xargs -0 sed -i .sedbk -e "s/%name/$name/g"

# Remove the backups created by sed
find . -name "*.sedbk" -print0 | xargs -0 rm

cd $back