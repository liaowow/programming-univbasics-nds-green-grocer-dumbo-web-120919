def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  index = 0
  while index < collection.length do
    if name == collection[index][:item]
      return collection[index]
    end
    index += 1
  end
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  arr = []
  index = 0
  while index < cart.length do
    #see if the current item is in the new cart (arr) already...
    #...by using the method above, which returns the hash with item info
    arr_item = find_item_by_name_in_collection(cart[index][:item], arr)
    if arr_item
      arr_item[:count] += 1
    else
      arr_item = {
        :item => cart[index][:item],
        :price => cart[index][:price],
        :clearance => cart[index][:clearance],
        :count => 1
      }
      arr << arr_item
    end
    index += 1
  end
  arr
end

def apply_coupons(cart, coupons)
  #figure out what to loop thru first: cart or coupons 
  #loop thru coupons first bc we need to apply all the coupons
  counter = 0
  while counter < coupons.length
    ## create 3 variables
    #1. create a variable for the item in the cart: cart_item
    #using 1st method to check if coupon item exists in cart collection
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    #2. create a variable to hold couponed item name
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    #3. using 1st method to return hash that has couponed item in cart collection
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    
    ## if cart item exists AND number of cart item is enough for coupon to be applied...
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      ## if coupon item exists already... 
      if cart_item_with_coupon
        ## ...take that item with coupon, access the count, increase by the num of coupons
        cart_item_with_coupon[:count] += coupons[counter][:num]
        ###...and substract count of original cart item from coupon count
        cart_item[:count] -= coupons[counter][:num]
      
      ## if coupon item doesn't exist...
      else
        ## ...create one!
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :count => coupons[counter][:num],
          :clearance => cart_item[:clearance]
        }
        
        ## finally, add couponed item to the cart...
        ## ...and substract count of original cart item from coupon count
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[counter][:num]
      end
    end
    counter += 1
  end
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  new_cart = []
  cart_index = 0
  while cart_index < cart.length do
    if cart[cart_index][:clearance]
      cart[cart_index][:price] = (cart[cart_index][:price] * 0.8).round(2)
    end
    new_cart << cart[cart_index]
    cart_index += 1
  end
  new_cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  total = 0
  
  new_cart = consolidate_cart(cart)
  apply_coupons(new_cart, coupons)
  apply_clearance(new_cart)
  
  new_cart_index = 0
  while new_cart_index < new_cart.length do
    total += new_cart[new_cart_index][:price] * new_cart[new_cart_index][:count]
    new_cart_index += 1
  end
  
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
