# a simple test change

#### Food Finder ####
#
# Launch this Ruby file from the command line
# to get started
#


#Define Application Path
APP_ROOT = File.dirname(__FILE__)

#Now I can find other files in project - 
#full absolute path method
#require "#{APP_ROOT}/lib/guide.rb"

#Slightly superior method - better for cross platform
#require File.join(APP_ROOT,'lib','guide.rb')

# MORE ADVANCED METHOD
# $:  is a list of Ruby standard paths
# use unshift to append to this list
# notice you dont need the rb  extension...? 
$:.unshift(File.join(APP_ROOT,'lib'))

# Lets add our support directory also since require 'guide'
# will need it due to mixin
$:.unshift(File.join(APP_ROOT,'lib','support'))

# note: a require will pull in all associated objects, so all relevant
# directories must be available in path
require 'guide'
#puts $:



##############################
#ok,lets start up app...
#############################
guide = Guide.new("restaurants.txt")
guide.launch!
