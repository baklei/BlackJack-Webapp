require 'rubygems'
require 'sinatra'
require 'pry'


set :sessions, true

helpers do
  
  def calculate_total(cards)
    arr = cards.map{|element| element[1]}
    
    total = 0
    arr.each do |a|
      if a == "A"
	total += 11
      else
	total += a.to_i == 0 ? 10: a.to_i
      end
    end
    
    #correct for Aces
    arr.select{|element| element == "A"}.count.times do
      break if total <= 21
      total -= 10
    end
    
    total
  end
  
  def get_card_image(card)
    suit = case card[0]
    when 'H' then 'hearts'
    when 'D' then 'diamonds'
    when 'C' then 'clubs'
    when 'S' then 'spades'
    end
    
    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value= case card[1]
    when 'J' then 'jack'
    when 'Q' then 'queen'
    when 'K' then 'king'
    when 'A' then 'ace'
      end
    end
      
      
    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end
  
  def winner!(msg)
    @success = "<strong>#{session[:username]} wins!</strong> #{msg}"
  end
  
  def loser!(msg)
    @error = "<strong>#{session[:username]} loses!</strong> #{msg}"
  end
  
  def tie!(msg)
    @success = "<strong> It's a tie!</strong> #{msg}"
  end
  
end

before do
  @show_buttons = true
end



get '/' do
  "hello world"
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:username].nil? || params[:username].empty?
  
    @error = "Name can't be blank"
    halt(erb(:new_player))
  
  end
 
  session[:username] = params[:username]
  redirect '/game'
end

get '/game' do
  
  session[:turn] = session[:username]
  
  suits = ["H", "D", "S", "C"]
  values = ["2", "3", "4", "5", "6" , "7", "8", "9", "10", "J", "Q", "K", "A"]
  session[:deck] = suits.product(values).shuffle!
  
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  
 erb :game

end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == 21
    winner!("BLACKJACK! #{session[:username]} has hit 21")
    @show_buttons = false
  elsif player_total > 21
    loser!("#{session[:username]} has busted")
    @show_buttons = false
  end
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:username]} stands"
  @show_buttons = false
  redirect 'game/dealer'
end

get '/game/dealer' do
  session[:turn] = "dealer"
  @show_buttons = false
  
  dealer_total = calculate_total(session[:dealer_cards])
  
  if dealer_total == 21
     @error = "Dealer has won"
  elsif  dealer_total > 21
    @success = "Dealer has busted"
  elsif dealer_total >= 17
      redirect '/game/compare'
  else
     @dealer_show_button = true
    end
    
    erb :game
end


post '/game/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  @show_buttons = false
  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])
  
  if player_total < dealer_total
    loser!("#{session[:username]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}")
  elsif player_total > dealer_total
    winner!("#{session[:username]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}")
  else
    tie!("Both #{session[:username]} and dealer stayed at #{player_total}")
  end
  erb :game
end