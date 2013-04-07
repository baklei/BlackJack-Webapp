#Blackjack.rb
#Bradley Li


busted = false
done = false
player = []
dealer = []
suit = [2,3,4,5,6,7,8,9,10,'J','Q','K','A']

puts "What's your name?"

name = gets.chomp
deck = []

def calculateTotal(hand)
  total = 0
  for i in 0..hand.size
    if hand[i] == 'K' || hand[i] == 'J' || hand[i] == 'Q'
      total += 10
      next
    end
    if hand[i] == 'A'
      if (total + 11) <= 21
	total += 11
      else
	total += 1
      end
    else
      total += hand[i].to_i
    end
  end
  return total
end
  
  


while done == false
  #Creates the deck, shuffles and deals
  for i in 0..3
    for j in 0..suit.size - 1
    deck << suit[j]
    end
  end
  deck.shuffle!
  player << deck.shift
  dealer << deck.shift
  player << deck.shift
  dealer << deck.shift
    
  #Player's Turn  
  while 1
    co = '0' #variable to determine hit or stay
    
    puts "dealer's faceup card is a #{dealer[1]}"
    puts "#{name}'s hand is #{player}, 1) hit or 2) stay"
    co = gets.chomp
    
    #If player gets 21 on first hand
    if calculateTotal(player) == 21
      puts "Blackjack You win"
      break
    end
    #If dealer gets 21 on first hand
    if calculateTotal(dealer) == 21
      puts "Blackjack Dealer wins"
      break
    end
   
    #If the player hits
    if co == '1'
      player << deck.shift
     
      if calculateTotal(player) > 21
        puts "You have Busted Dealer Wins"
        break
      end
    
      if calculateTotal(player) == 21
        puts "Blackjack You win"
        break
      end
      next
    end
   
    #If player stays
    if co == '2'
      #Dealer's Turn
      while 1
	puts "dealer's hand is #{dealer}"
       
	if calculateTotal(dealer) > 21
	  puts "Dealer has Busted"
	  busted = true
	  break
    
        elsif calculateTotal(dealer) == 21
	  puts "Blackjack Dealer wins"
	  break
        end
       
	if calculateTotal(dealer) < 17
	  puts "Dealer hits"
	  dealer << deck.shift
	else
	  puts "Dealer stands"
	  break
        end
      end
      if calculateTotal(player) > calculateTotal(dealer) || busted == true
        puts "You win"
      else
        puts "You Lose"
      end
      break
    end
  end
  
  puts "Play again? 1) yes or 2) no"
  
  again = gets.chomp
  
  if again == '1'
    player.clear
    dealer.clear
    deck.clear
    busted = false
    next
  end
  
  if again == '2'
    done = true
  end
end
