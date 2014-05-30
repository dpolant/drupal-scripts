#!/bin/bash

if [ "$1" != '' ]
then 
  drush php-eval "print_r(array_keys(module_invoke_all('permission')))"  | grep $1
  exit
fi

drush php-eval "print_r(array_keys(module_invoke_all('permission')))"