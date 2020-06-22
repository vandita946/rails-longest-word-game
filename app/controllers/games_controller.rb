require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters= generate_grid(10)
  end

  def score
    if params[:attempt]
      @attempt = params[:attempt]
      @letters = params[:letters]
      @result = run_game(@attempt, @letters, 0, 0)
    end

  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    result = []
    (1..grid_size).each { result << ("A".."Z").to_a.sample }
    result
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    in_grid = attempt.upcase.split("").all? { |letter| attempt.upcase.split("").count(letter) <= grid.count(letter) }
    dict_check = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    if dict_check["found"] && in_grid
      { score: calculate_score(start_time, end_time, grid, attempt), message: "well done", time: end_time - start_time }
    elsif dict_check["found"] && !in_grid
      { score: 0, message: "not in the grid", time: end_time - start_time }
    else
      { score: 0, message: "not an english word", time: end_time - start_time }
    end
  end

  def calculate_score(start_time, end_time, grid, attempt)
    (end_time - start_time < 2 ? 5 : 2.5) + (attempt.length > grid.length / 2 ? 5 : 2.5)
  end

end
