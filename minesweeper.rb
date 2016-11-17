require 'yaml'
require_relative "Board"

class Minesweeper

  def self.load_game_from_file(filename)
    board_text = File.read(filename)
    loaded_board = YAML::load(board_text)
    new(loaded_board).play
  end

  attr_accessor :board, :game_over

  def initialize(board = Board.new)
    @board = board
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
    parse_pos($stdin.gets.chomp)
  end

  def prompt_action(pos)
    puts "R, S, F"
    input = $stdin.gets.chomp.upcase
    if input == "R"
      board.reveal(pos)
    elsif input == "S"
      save_game
    else
      board.flag(pos)
    end
  end

  def save_game
    File.open("game01.txt", 'w') { |file| file.write(board.to_yaml) }
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

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    Minesweeper.new.play
  else
    Minesweeper.load_game_from_file(ARGV.first)
  end
end
