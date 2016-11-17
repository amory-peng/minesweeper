require_relative "Board"

class Minesweeper

  attr_accessor :board, :game_over

  def initialize
    @board = Board.new
    @game_over = false
  end

  def play
    play_turn until @game_over
    board.render
  end

  def play_turn
    board.render
    pos = prompt_player
    prompt_action(pos)
    check_game_end(pos)
  end

  def prompt_player
    puts "pick a position:"
    parse_pos(gets.chomp)
  end

  def prompt_action(pos)
    puts "R or F"
    input = gets.chomp.upcase
    if input == "R"
      board.reveal(pos)
    else
      board.flag(pos)
    end
  end


  def parse_pos(input)
    input.split(",").map {|char| Integer(char)}
  end

  def won?
    board.won?
  end

  def lost?(pos)
    board[pos].bomb
  end

  def check_game_end(pos)
    if lost?(pos)
      board.reveal_bombs
      puts "You lost!"
      @game_over = true
    elsif
      @game_over = won?
    end
  end
end

Minesweeper.new.play
