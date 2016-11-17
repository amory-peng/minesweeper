require 'set'
require_relative "Square"

class Board
  attr_reader :bomb_positions

  def initialize
    @grid = Array.new(9) do
      Array.new(9) { Square.new }
    end
    @bomb_positions = []
    seed_bombs
  end

  def seed_bombs
    bomb_count = 0
    while bomb_count < 10
      rand_pos = [rand(9), rand(9)]
      next if self[rand_pos].bomb
      self[rand_pos].bomb = true
      bomb_positions << rand_pos
      update_adjacent_bomb_count(rand_pos)
      bomb_count += 1
    end
  end

  def update_adjacent_bomb_count(bomb_pos)
    row, col = bomb_pos
    (row - 1..row + 1).each do |adj_row|
      (col - 1..col + 1).each do |adj_col|
        adj_pos = [adj_row, adj_col]
        if in_range?(adj_pos) && !bomb?(adj_pos)
          self[adj_pos].adjacent_bombs += 1
        end
      end
    end
  end

  def bomb?(pos)
    self[pos].bomb
  end

  def in_range?(pos)
    pos.all? { |el| el.between?(0, grid.size - 1) }
  end

  def render
    display_rows = []
    grid.each do |row|
      display_rows << row.map(&:to_s).join
    end
    puts display_rows
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def won?
    grid.flatten.all? do |el|
      !el.hidden || el.bomb
    end
  end

  def reveal_bombs
    bomb_positions.each { |bomb_pos| self[bomb_pos].reveal }
  end

  def flag(pos)
    self[pos].flag
  end

  def reveal(pos)
    return if bomb?(pos) || self[pos].flagged
    self[pos].reveal
    return if self[pos].adjacent_bombs > 0

    positions = [pos]
    visited = Set.new [pos]

    until positions.empty?
      current_pos = positions.shift
      next if bomb?(current_pos)
      self[current_pos].reveal
      next if self[current_pos].adjacent_bombs > 0
      row, col = current_pos
      (row - 1..row + 1).each do |adj_row|
        (col - 1..col + 1).each do |adj_col|
          adj_pos = [adj_row, adj_col]
          if in_range?(adj_pos) && !visited.include?(adj_pos)
            positions << adj_pos
            visited << adj_pos
          end
        end
      end
    end
  end

  private

  attr_reader :grid
end
