# this is my own code!

def prompt(message)
  puts "=> #{message}"
end

def calc_payment(amt, interest_mo, dur_mo)
  # note: monthly interest is necessarily a float
  exp = (1 + interest_mo)**dur_mo
  top = amt * interest_mo * exp
  bottom = exp - 1
  top / bottom
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def number?(input)
  float?(input) || integer?(input)
end

loop do
  apr = ''
  loop do
    prompt("What's your APR, as a percentage? Must be a non-negative number")
    apr = gets.chomp
    break if number?(apr) && (apr.to_f >= 0)
    prompt("Must be a non-negative number")
  end
  interest_mo = apr.to_f / 1200

  ltr = ''
  loop do
    dur_prompt = <<-MSG
      How long is your mortgage?
      Input y if expressed in years, m if months
    MSG

    prompt(dur_prompt)
    ltr = gets.chomp.downcase
    break if ltr == 'm' || ltr == 'y'
    prompt("Invalid input")
  end

  dur_mo = ''
  if ltr == 'm'
    loop do
      prompt("How many months? Must be a positive integer")
      dur_mo = gets.chomp
      break if integer?(dur_mo) && (dur_mo.to_i > 0)
      prompt("Must be a positive integer")
    end
    dur_mo = dur_mo.to_i
  else
    dur_y = ''
    loop do
      prompt("How many years? Must be a positive integer")
      dur_y = gets.chomp
      break if integer?(dur_y) && (dur_y.to_i > 0)
      prompt("Must be a positive integer")
    end
    dur_mo = dur_y.to_i * 12
  end

  amt = ''
  loop do
    prompt("How much is your loan? Must be a positive number")
    amt = gets.chomp
    break if number?(amt) && (amt.to_f > 0)
    prompt("Must be a positive number")
  end
  amt = amt.to_f

  p = amt / dur_mo
  p = calc_payment(amt, interest_mo, dur_mo) if interest_mo > 0

  prompt("Your monthly payment is: #{p}")

  choice = ''
  loop do
    prompt("Would you like to go again? (y/n)")
    choice = gets.chomp.downcase
    break if choice == 'y' || choice == 'n'
    prompt("Not a valid choice")
  end

  break if choice == 'n'
end
