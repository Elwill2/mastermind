class Board
  attr_reader :grid, :feedback

  def initialize
    @grid =
      [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil]
      ]

    @feedback = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end


  def place_guess(row, guess)
    @grid[row] = guess
  end

  def place_feedback(row, feedback)
    @feedback[row] = feedback
  end

  def display
    (0..11).each do |i|
      guess = @grid[i]
      pawns = @feedback[i]

      if pawns.nil?
        puts
      elsif pawns.empty?
        puts "Row #{i} : #{guess.join(" ")} : Try new numbers!"
      else
        puts "Row #{i} : #{guess.join(" ")} : #{pawns.join(" ")}"
      end
    end
  end
end

class Game
  attr_accessor :board, :human_creator, :turn, :secret, :guess_matched

  def initialize(board, human_creator, secret, guess_matched)
    @board = board
    @human_creator = human_creator
    @turn = 0 
    @secret = secret
    @guess_matched = false
    @known_positions = [nil, nil, nil, nil]
  end

  def guesser_or_creator
    puts "Do you prefer to be the guesser or the creator ?"
    choice = gets.chomp.strip.downcase
    until choice == "guesser" || choice == "creator"
      puts "Your answer is invalid, please type guesser or creator."
      puts "Do you prefer to be the guesser or the creator ?"
      choice = gets.chomp.strip.downcase
    end
    choice
  end 
  

  def four_random_numbers
   @known_positions.map do |slot| 
    if slot.nil? 
    rand(1..6)
    else
    slot 
    end
  end
end


  def ask_guess 
    puts "Create a code of four numbers between 1 and 6 with space in between them."
    input = gets.chomp
    input.split(" ").map { |n| n.to_i }
  end 

  
  def valid?(guess)
    guess.length == 4 && guess.all? { |n| n.between?(1, 6) } 
  end
 
  def ask_until_valid
    guess = ask_guess
    until valid?(guess)
    puts "There is a number missing and all numbers have to be between 1 and 6"
    guess = ask_guess  
    end
    guess
 end

 

 def play_turn
   @board.display
   if human_creator
    guess = four_random_numbers
    update_known_positions(guess)
   else 
    guess = ask_until_valid
   end

   @guess_matched = guess == @secret
   @board.place_guess(@turn, guess)
   feedback = result(@secret, guess)
   @board.place_feedback(@turn, feedback)
   @turn += 1 
 end


 
  def play_game
    choice = guesser_or_creator

      if choice == "guesser"
        puts "The human will be the guesser."
        @human_creator = false
      else 
        puts "The human will be the creator."
        @human_creator = true
        puts "Please enter a secret code."
        @secret = ask_until_valid
      end
    

    until guess_matched || @turn == 12   
    play_turn 
    end

    board.display

      if guess_matched  
        puts "You found the secret code, well done."
      else
        puts 'You have not guessed the secret code!'
     end
end


  def update_known_positions(guess)
    (0..3).each do |i|
      if guess[i] == secret[i]
        @known_positions[i] = guess[i]
      end
    end
  end


 def result(secret, guess)
    secret_copy = secret.dup
    guess_copy = guess.dup
    feedback = []

    

    (0..3).each do |i|
      if secret[i] == guess[i]
        feedback << "#"
        secret_copy[i] = nil
        guess_copy[i] = nil
      end
    end

    (0..3).each do |i|
      if guess_copy[i] != nil && secret_copy.include?(guess_copy[i])
        feedback << "*"
        position = secret_copy.index(guess_copy[i])
        secret_copy[position] = nil
        guess_copy[i] = nil
      end
    end

    feedback
  end
end

secret = (1..4).map { rand(1..6)}
board = Board.new
game = Game.new(board, nil, secret, false)
game.play_game