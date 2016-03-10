VALID_CHOICES = %w(rock paper scissors lizard spock).freeze

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  (first == 'rock' && %w(lizard scissors).include?(second)) ||
    (first == 'scissors' && %w(paper lizard).include?(second)) ||
    (first == 'paper' && %w(rock spock).include?(second)) ||
    (first == 'lizard' && %w(paper spock).include?(second)) ||
    (first == 'spock' && %w(scissors rock).include?(second))
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You win!")
  elsif win?(computer, player)
    prompt("Computer wins!")
  else
    prompt("It's a tie!")
  end
end

def display_score(ps, cs)
  prompt("You: #{ps}, Computer: #{cs}")
end

loop do
  prompt("RPSLS: First to five wins!")
  player_score, computer_score = 0, 0
  loop do
    choice = ''
    loop do
      prompt("Choose one: rock, paper, scissors, lizard, spock")
      choice = gets.chomp.downcase

      break if VALID_CHOICES.include?(choice)
      prompt("That's not a valid choice")
    end

    computer_choice = VALID_CHOICES.sample
    prompt("You chose: #{choice}, computer chose: #{computer_choice}")

    display_results(choice, computer_choice)

    player_score += 1 if win?(choice, computer_choice)
    computer_score += 1 if win?(computer_choice, choice)
    display_score(player_score, computer_score)

    prompt("You win the set!") if player_score == 5
    prompt("Computer wins the set!") if computer_score == 5

    break if player_score == 5 || computer_score == 5
  end

  ex = ''
  loop do
    prompt("Would you like to play again? (y/n)")
    ex = gets.chomp.downcase
    break if ex == 'y' || ex == 'n'
    prompt("Not a valid choice")
  end

  break if ex == 'n'
end
