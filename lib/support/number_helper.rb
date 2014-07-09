# This module illustrates how additional functionality can be 
# included (or "mixed-in") to a class and then reused.
# Borrows heavily from Ruby on Rails' number_to_currency method.
module NumberHelper
  
  def number_to_currency(number, options={})
    # Is it the daller sign by default
    # Note: the || facilites a default. if nil, then def
    unit      = options[:unit]      || '$'
    # How many decimal places it should have
    precision = options[:precision] || 2
    # what to use between the numbers 1,000
    delimiter = options[:delimiter] || ','
    # decimal separator
    separator = options[:separator] || '.'

    # Remove separator if no decimal places
    separator = '' if precision == 0
    #Split number into 2 - integer/decimal
    integer, decimal = number.to_s.strip.split('.')
    
    # For integer half, loop through and insert delimeter after every
    # 3 places
    i = integer.length
    until i <= 3
      # move backwards through number and insert delimeter every 
      # 3 places
      i -= 3
      integer = integer.insert(i,delimiter)
    end
    
    if precision == 0
      precise_decimal = ''
    else
      # make sure decimal is not nil
      decimal ||= "0"
      # make sure the decimal is not too large
      # return everything up to option/precision -1
      # clips it if to large.  what about rounding?
      decimal = decimal[0, precision-1]
      
      # make sure the decimal is not too short.
      # if so, pad 0's
      # ljust is left justify
      # example  > dec => "3"                                                                               #           > precise_dec = dec.ljust(4,"0")  => "3000"   
      precise_decimal = decimal.ljust(precision, "0")
    end
    
    return unit + integer + separator + precise_decimal
  end
  
end
