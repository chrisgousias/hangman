class Game

  attr_accessor :tries_left

  def initialize
      @tries_left = 6
  end

  def user_input
    print "Your guess letter: "
    input = gets.chomp.downcase
    until input.length == 1 && input >= 'a' && input <= 'z' do
      print "Invalid input. It must be one letter: "
      input = gets.chomp.downcase
    end
    return input
  end

  def play

    word = "derived"
    hangman_word = word.chars
    hangman_word_covered = Array.new(hangman_word.length, "_") 
    wrong_letters = []

    until tries_left == 0 || hangman_word_covered == hangman_word do

      letter = user_input

      if hangman_word.include?(letter)
        hangman_word.each_with_index {|v, i| hangman_word_covered[i] = v if v == letter}
        puts hangman_word_covered.join(" ")
      else
        puts "#{letter} is not in the word."
        wrong_letters << letter
        self.tries_left -= 1
        puts "Tries left: #{tries_left}"
        puts hangman_word_covered.join(" ")
      end
    end
  end
       
end