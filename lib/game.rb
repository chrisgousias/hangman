require 'json'

class Game

  #getters and setters
  attr_accessor :tries_left, :secret_word, :guessed_letters

  def initialize
      @tries_left = 6
      @secret_word = get_word.sample
      @guessed_letters = []
  end

  def get_word
    words_array = []
    path = "data/google-10000-english-no-swears.txt"
    file = File.open(path, "r")
    for line in file.readlines()
      word = line.chomp
      if word.length >= 5 && word.length <= 12
        words_array << word
      end
    end
    file.close

    words_array
  end

  def user_input
    print "Your guess letter: "
    input = gets.chomp.downcase

    until input == "save" || input.length == 1 && input >= 'a' && input <= 'z' && !guessed_letters.include?(input) do
      if guessed_letters.include?(input)
        print "You chose this letter in another turn. Enter again: "
        input = gets.chomp.downcase
      else
        print "Invalid input. It must be one letter: "
        input = gets.chomp.downcase
      end
    end
    return input
  end

  def display_word
    result = []
    secret_word.each_char do |c|
      if guessed_letters.include?(c)
        result << c
      else
        result << "_"
      end
    end
    result
  end

  def wrong_letters
    guessed_letters - secret_word.chars
  end

  def display_remaining_turns(wrong_letters)
    self.tries_left = 6 - wrong_letters.length
    puts "Remaining Tries: #{tries_left} "
  end

  def display_result_message
    if tries_left == 0
      puts "You lose. The word was: #{secret_word}"
      puts "---------- GAME OVER ----------"
    else 
      puts "Congratulations! YOU WON!"
    end
  end

  def save_game
    file = File.open("data/save-file.txt", "w+")
    state = {secret_word: secret_word, tries_left: tries_left, guessed_letters: guessed_letters}
    file.write(JSON.generate(state))
    file.close()
  end

  def load_game
    file = File.open("data/save-file.txt", "r")
    json = file.read
    state =JSON.parse(json, symbolize_names: true)
    file.close
    state
  end

  def play

    result = []
    wrong_guesses = []

    until tries_left == 0 || result.join == secret_word do

      letter = user_input
      if letter == "save"
        save_game
        break
      end
      self.guessed_letters << letter

      result = display_word
      puts result.join(" ")

      wrong_guesses = wrong_letters
      print "USED LETTERS: #{wrong_guesses}, "
      display_remaining_turns(wrong_guesses)
    end

    display_result_message
  end  
  
end