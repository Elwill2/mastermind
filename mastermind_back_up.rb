

class Player
  attr_accessor :secret, :guess

  def initialize(secret, guess)
    @secret = secret
    @guess = guess
  end
end

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
  attr_accessor :board, :guesser, :creator, :turn, :secret, :guess_matched

  def initialize(board, guesser, creator, secret, guess_matched)
    @board = board
    @guesser = guesser
    @creator = creator
    @turn = 0 
    @secret = secret
    @guess_matched = guess_matched
  end

  def guesser_or_creator
    puts "Do you prefer to be the guesser or the creator ?"
    gets.chomp.strip.downcase
  end 
  


  def creator 
   computer_guess = (1..4).map { rand(1..6)}
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
   guess = ask_until_valid
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
      elsif choice == "creator"
        puts "The human will be the creator."
        puts "Please enter a secret code."
        @secret = ask_until_valid
        @board = creator
        creator = @secret
        @board.display

      else 
        puts "Your answer is invalid, please type guesser or creator."
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
game = Game.new(board, nil, nil, secret, nil)
game.play_game

