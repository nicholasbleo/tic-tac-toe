# frozen_string_literal: true

require 'pry-byebug'

# Initializes a 3x3 board.
class Board
  attr_accessor :grid, :player, :last_player

  def initialize
    @grid = Array.new(3) { Array.new(3, '.') }
    @last_player = ''
    @player = 'X'
  end

  def show_grid
    puts ''
    @grid.each { |row| puts row.join(' ') }
    puts ''
    puts "Next player's turn: #{@player}\n"
  end

  def play_turn(coords)
    if coords[0] <= 3 && coords[1] <= 3
      place_marker(coords)
    else
      puts "Those coordinates are invalid - please try again.\n"
    end
  end

  private

  def place_marker(coords)
    case @grid[coords[0] - 1][coords[1] - 1]
    when 'X'
      puts "That spot has already been taken.\n"
    when 'O'
      puts "That spot has already been taken.\n"
    when '.'
      @grid[coords[0] - 1][coords[1] - 1] = @player
      @last_player = @player
      @player = @player == 'X' ? 'O' : 'X'
    end
  end
end

# Gameplay procedure

board = Board.new

gameover = false

until gameover
  puts "Please enter two coordinates (row, column), separated by a comma: \n"
  user_input = gets.split(',').map(&:to_i)
  board.play_turn(user_input)
  board.show_grid

  gameover_checks = []

  # Check horizontal win conditions.
  gameover_checks.push(board.grid.map { |row| row.all?('X') || row.all?('O') }.any?)

  # Check vertical win conditions.
  [0, 1, 2].each do |i|
    gameover_checks.push(board.grid.map { |row| row[i] == 'X' }.all? || board.grid.map { |row| row[i] == 'O' }.all?)
  end

  # Check diagonal win conditions.
  check_hash = board.grid.flatten.each_with_index.reduce({}) do |hash, (element, index)|
    unless hash[element]
      hash[element] = []
    end
    hash[element].push(index)
    hash
  end

  if [[0, 4, 8], [2, 4, 6]].include?(check_hash['X']) || [[0, 4, 8], [2, 4, 6]].include?(check_hash['O'])
    gameover_checks.push(true)
  else
    gameover_checks.push(false)
  end
  gameover = gameover_checks.any?
end

puts "Player #{board.last_player} wins!"
