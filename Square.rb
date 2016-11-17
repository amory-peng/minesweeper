class Square
  attr_reader :hidden, :flagged
  attr_accessor :adjacent_bombs, :bomb

  def initialize
    @bomb = false
    @hidden = true
    @adjacent_bombs = 0
    @flagged = false
  end

  def to_s
    if @flagged
      return "F"
    elsif @hidden
      return "X"
    else
      return "B" if @bomb
      adjacent_bombs.to_s
    end
  end

  def flag
    @flagged = !flagged if hidden
  end

  def reveal
    @hidden = false unless flagged
  end

end
