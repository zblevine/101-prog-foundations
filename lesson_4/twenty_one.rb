require 'pry'

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  dk = []
  (2..10).each { |i| 4.times { dk << i } }
  ["Jack", "Queen", "King", "Ace"].each { |w| 4.times { dk << w } }
  dk.shuffle!
end

def number?(card)
  card.to_s.to_i == card
end

def value(card)
  v = 10
  v = card if number?(card)
  v
end

def sum_cards(cards)
  aces = cards.select { |c| c == 'Ace' }
  cards.reject! { |c| c == 'Ace' }

  s = 0
  cards.each { |c| s += value(c) }

  unless aces.empty?
    aces.size.times { s += 1 }
    s += 10 if s < 12
    cards << aces # adds back the aces
    cards.flatten! # and makes the last object an ace instead of an array
  end

  s
end

def busted?(cards)
  sum_cards(cards) > 21
end

def player_prompt(p_cards)
  prompt "Your cards: #{p_cards.join(', ')}"
  prompt "Your total: #{sum_cards(p_cards)}"
  puts "\n"
end

def dealer_prompt(d_cards)
  prompt "Dealer cards: #{d_cards.join(', ')}"
  prompt "Dealer total: #{sum_cards(d_cards)}"
  puts "\n"
end

def player_status
  choice = ''
  loop do
    prompt "What would you like to do? (enter 'hit' or 'stay')"
    choice = gets.chomp.downcase
    break if choice == 'hit' || choice == 'stay'
    prompt "That's not one of the choices"
  end

  choice
end

def player_turn!(p_cards, dk)
  loop do
    player_prompt(p_cards)

    if busted?(p_cards)
      prompt "Oh no! You busted!"
      break
    end

    if player_status == 'stay'
      prompt "You stayed!"
      break
    end

    prompt "You hit!"
    p_cards << dk.shift
    puts "\n"
  end
end

def dealer_turn!(d_cards, dk)
  loop do
    dealer_prompt(d_cards)

    if busted?(d_cards)
      prompt "Dealer busted!"
      break
    elsif sum_cards(d_cards) >= 17
      prompt "Dealer stays!"
      break
    else
      prompt "Dealer hits!"
      d_cards << dk.shift
      puts "\n"
    end
  end
end

prompt "Welcome to 21!"
puts "\n"
player_score = 0
dealer_score = 0
push_score = 0
loop do
  prompt "Your wins: #{player_score}"
  prompt "Dealer wins: #{dealer_score}"
  prompt "Pushes: #{push_score}"
  puts "\n"

  deck = initialize_deck
  player_cards = [deck.shift, deck.shift]
  dealer_cards = [deck.shift, deck.shift]

  prompt "Your cards: #{player_cards.join(' and ')}"
  prompt "Dealer shows: #{dealer_cards[0]}"
  puts "\n"

  player_turn!(player_cards, deck)
  puts "\n"
  dealer_turn!(dealer_cards, deck) unless busted?(player_cards)
  puts "\n"

  player_sum = sum_cards(player_cards)
  dealer_sum = sum_cards(dealer_cards)

  prompt "Your total: #{player_sum} (#{player_cards.join(', ')})"
  prompt "Dealer total: #{dealer_sum} (#{dealer_cards.join(', ')})"

  if busted?(player_cards)
    prompt "Dealer wins!"
    dealer_score += 1
  elsif busted?(dealer_cards)
    prompt "You win!"
    player_score += 1
  elsif player_sum > dealer_sum
    prompt "You win!"
    player_score += 1
  elsif dealer_sum > player_sum
    prompt "Dealer wins!"
    dealer_score += 1
  else
    prompt "Push!"
    push_score += 1
  end
  puts "\n"

  prompt "Play again? (y/n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Exiting fake blackjack . . ."
