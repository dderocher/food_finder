require 'number_helper'

class Restaurant

  #####################################################
  # Mixins
  #####################################################
  include NumberHelper
  
  #####################################################
  # Class variables
  #####################################################
   @@filepath = nil
  
  #####################################################
  # Class Setter Methods
  # note: cannot use attr_ for Class methods
  #####################################################
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT,path)
  end
  
  #####################################################
  # Instance variables
  #####################################################
  attr_accessor :name, :cuisine, :price
  
  #####################################################
  #####################################################
  # Class methods
  #####################################################
  #####################################################
 
   def self.file_usable?
    #this shows a short cut structure for a bunch of tests
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    
    return true
  end 
  
  def self.file_exists?
    #Class should know if the restaurant file exists
    
    # This will check if @@filepath has been set and if it exists in dir
    # notice that since it is initialized as nil, you can test for boolean
    
    #if @@filepath && File.exists?(@@filepath)
    # should just use file_usable but wanted to show both ways
    if file_usable?
      return true
    else
      return false
    end 
  end 
  
  def self.create_file
    # Create the restaurant file
    File.open(@@filepath,'w') unless file_exists?
    return file_usable?
  end 
  
  def self.saved_restaurants
    # read the restaurant file
    restaurant_list = []
    
    # since a class method, dont need to put class name 
    # in front of it
    if file_usable?
      file = File.new(@@filepath,'r')
      
      file.each_line do |line|
        
        # append to array
        # ask the empty instance to import line using instance method import_line
        # so, create an empty instance and then populate it
        restaurant_list << Restaurant.new.import_line(line.chomp)
      end 
      
      file.close
    end
    
    return restaurant_list  
      
    # return instances of restaurant
  end 
  
  def self.build_using_questions
    args = {}
    
    print "Restaurant name: "
    args[:name]    = gets.chomp.strip
    
    print "Cuisine type: "
    args[:cuisine] = gets.chomp.strip
    
    print "Average price: "
    args[:price]   = gets.chomp.strip
    
    return self.new(args)
  
  end
  
  #####################################################
  #####################################################
  # Instance methods
  #####################################################  
  #####################################################
  
  #remember, initialize is a special method It does not have to be 
  # called explicitly, it happens automatically
  
  # arg will be a hash 
  def initialize (args = {})
    # since we dont want a nill showing up, default to empty string
    # very common pattern that you will see in the creation of attributes in 
    # the initialize method. We will book for some value in the arguments. 
    # If it's not there, then we default to a default value. 
    @name    = args[:name]    || ""
    @cuisine = args[:cuisine] || ""
    @price   = args[:price]   || ""
    
  end 
  
  def import_line(line)
    line_array = line.split("\t")
    
    # How to set attributes?
    # could say @name = line_array[0], etc
    # coould say @name = line_array.shift, etc
    # slicker way is:
    @name, @cuisine, @price = line_array
    
    #need this because this method is called with the following:
      #restaurant_list << Restaurant.new.import_line(line.chomp)
    #we need to end result to return the instance and append to array
    return self
    
  end 
  
  def save
    return false unless Restaurant.file_usable?
    
    File.open(@@filepath, 'a') do |file|
      #writes a tab delimited line of our values to file
      file.puts "#{ [@name, @cuisine, @price].join("\t")}\n"
    end 
    
    return true
  end 
  
  def formatted_price
    number_to_currency(@price)
  end 

end 