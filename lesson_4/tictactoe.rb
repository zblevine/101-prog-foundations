INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "Your marker: #{PLAYER_MARKER}. Computer marker: #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |n| new_board[n] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |n| brd[n] == INITIAL_MARKER }
end

def joinor(a, separator=', ', join_word='or')
  a[-1] = "#{join_word} #{a.last}" if a.size > 1
  a.join(separator)
end

def turn!(brd, curr_player)
  display_board(brd) if curr_player == 'Player'
  place_piece!(brd, curr_player)
  alternate_player(curr_player)
end

def place_piece!(brd, curr_player)
  if curr_player == 'Player' then player_places_piece!(brd) else computer_places_piece!(brd) end
end

def alternate_player(curr_player)
  if curr_player == 'Player' 
    curr_player.gsub!('Player', 'Computer')
  else 
    curr_player.gsub!('Computer', 'Player')
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "This is either already taken or not a square"
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  if threatened_square?(brd, COMPUTER_MARKER)
    brd[find_threat(brd, COMPUTER_MARKER)] = COMPUTER_MARKER
  elsif threatened_square?(brd, PLAYER_MARKER)
    brd[find_threat(brd, PLAYER_MARKER)] = COMPUTER_MARKER
  elsif empty_squares(brd).include?(5)
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def threatened_square?(brd, mark)
  !!find_threat(brd, mark)
end

def find_threat(brd, mark) # returns a square if one is threatened, nil otherwise
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(mark) == 2 && brd.values_at(*line).count(INITIAL_MARKER) == 1
      return line[line.index { |i| brd[i] == INITIAL_MARKER }]
    end
  end

  nil
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    return 'Player' if brd.values_at(*line).count(PLAYER_MARKER) == 3
    return 'Computer' if brd.values_at(*line).count(COMPUTER_MARKER) == 3
  end

  nil
end

loop do
  prompt "Tic-tac-toe: first to five wins!"
  player_score = 0
  computer_score = 0

  loop do
    curr_player = 'Player'

    prompt "Do you want to go first? (y/n)"
    ans = gets.chomp
    curr_player = 'Computer' unless ans.downcase.start_with?('y')

    board = initialize_board

    loop do
      turn!(board, curr_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      winner = detect_winner(board)
      prompt "#{winner} won!"
      player_score += 1 if winner == 'Player'
      computer_score += 1 if winner == 'Computer'
    else
      prompt "It's a tie!"
    end

    prompt "You: #{player_score}"
    prompt "Computer: #{computer_score}"

    if player_score == 5
      prompt "You win!"
      break
    elsif computer_score == 5
      prompt "Computer wins!"
      break
    end

    prompt "Keep going? (y/n)"
    answer = gets.chomp
    break unless answer.downcase.start_with?('y')
  end

  prompt "Play again? (y/n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Exiting game . . ."
