class Guide
#####################################################  
# Guide will be our 'controller class'
#####################################################  
  
  #####################################################
  # Dependencies
  #####################################################
  
  #must be loaded in before classes that require them
  # Do not need rb extension, it assumes...
  require 'restaurant'
  require 'string_extend'

  #####################################################
  # Class within a Class definitions
  #####################################################
  
  # ok, this overkill but demonstrates the technique
  # This class will group together configuration info 
  # for class... kind of nice
  class Config
    ####################################
    # Class variables
    ####################################
     @@actions = ['list','find','add','quit']
  
    ####################################
    # Class Geter/Setter Methods
    # note: cannot use attr_ for Class methods
    ####################################
    
    #setter
    # This is how to do it all on one line
    def self.actions; @@actions; end 
    
    ####################################
    # Instance Methods
    ####################################
  end # class Config

  
  #####################################################
  #####################################################
  # Class methods
  #####################################################
  #####################################################  

  #####################################################
  #####################################################
  # Instance methods
  #####################################################  
  #####################################################
  
  ############################
  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_exists?
      puts "Found restaurant file."
      
    elsif Restaurant.create_file # or create a new file
      puts "Created restaurant file."  
    
    else # exit if create fails
      puts "Exiting...\n\n"
      
      #special ruby method that aborts whole app
      exit!
    
    end 
  
  end 
############################  
  #using exclamation point here to indicate this does a lot of stuff
  def launch!
    # introduction - welcome to food finder, etc
    introduction
    
    # action loop
    result = nil
    until result == :quit
      
      # capture action
      # implied array here, cannot use array brackets
      action, args = get_action
      #   do that action
      result = do_action(action, args)
      # repeat until user quits
    end # until result == :quit
    
    # The end...
    conclusion
  end 
############################
  def get_action
    #   what do you want do do (list,find,add,quit)
    # This gets the class variable of available actions
    # from config class and loops until valid
    action = nil
    until Guide::Config.actions.include?(action)
      
      # indicate actions if action is not nil
      puts "Available Actions: " + Guide::Config.actions.join(", ") if action
      
      print "> "
      user_response = gets.chomp
    
      # downcase it, and strip any spaces out of it. Could be two words
      # one flaw here is that this assumes 1 space between words...
      args = user_response.downcase.strip.split(' ')

    # action will be first word
    # shift will move it out of array
    # all the remaining words are still in args
    action = args.shift
     
    end 
    
    # only allowed to return one thing
    # this is actually an implied array
    return action, args
  end


############################
  def do_action(action, args = [])
    #puts "User wants to do this: " + action + "\n"
    case  action
    when 'list'
      list(args)
    when 'find'
      # only going to worry about first keyword one here
      keyword = args.shift
      find (keyword)
    when 'add'
      add
    when 'quit'
      #Use symbol here
      return :quit
    else
      puts "\nThat is bullshit - try again \n"
    end
    
  end
  
############################
  def add
    output_action_header "Adding a restaurant"
    restaurant = Restaurant.build_using_questions
    
    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: restaurant not added\n\n"
    end
    
  end 
############################
  def list (args = [])
    
    # set default and make sure we have valid input
    sort_order = args.shift
    sort_order = "name" unless ['name','cuisine','price'].include?(sort_order)
    
    output_action_header "Listing a restaurant"

    #restaurant_list = Restaurant.saved_restaurants
    restaurants = Restaurant.saved_restaurants
    
    # compare operator = <=>
    restaurants.sort! do |r1,r2|
      
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cusine.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    end
    
    # Notice dont have to use parens
    output_restaurant_table restaurants
    
    puts "Sort using: 'name','cuisine','price'"
    #restaurant_list.each do |rest|
    #  puts rest.name + " | " + rest.cuisine + " | " + rest.formatted_price  
    #end 
  end 
############################
  def find keyword = ""
    output_action_header "Find a restaurant"
    #could pass in nil, so check
    if keyword
      #search
      restaurants = Restaurant.saved_restaurants
      # This creates an array of matching Rest's
      found = restaurants.select do |rest|
        # || is OR operator
        rest.name.downcase.include?(keyword.downcase) ||
          rest.cuisine.downcase.include?(keyword.downcase) ||  
          rest.price.to_i <= keyword.to_i
      end
      
      output_restaurant_table (found)
    else
      puts"Put something in to search moron"
    end 
    
  end 
############################
  def introduction
    puts "\n <<< Welcome to Dave's Food Finder >>> \n "
    puts " (This is my first ruby app and finds restaurants based on my mood.) \n "
  end 

############################
  def conclusion
    puts "\n <<< Exiting App, Good Riddance >>> \n\n "
  end 


  #####################################################
  # Instance PRIVATE methods
  #####################################################  
private 
  
  def output_action_header(text)
    # center title
    puts "\n#{text.upcase.center(60)}\n\n"
  end
  
  def output_restaurant_table restaurants = []
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    # puts gives me a line feed
    puts " " + "Price".ljust(6)
    puts "-" * 60
    
    restaurants.each do |rest|
      line = " " << rest.name.daves_titleize.ljust(30)
      line << " " <<  rest.cuisine.daves_titleize.ljust(20)
      # + is just to be different...
      line << " " +  rest.formatted_price.rjust(6)
      puts line
    end 
    
    puts "No Listings found" if restaurants.empty?
    puts "-" * 60
  end 


  
end 