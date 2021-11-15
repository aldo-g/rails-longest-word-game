class GamesController < ApplicationController
  def new
    letters = ('A'..'Z').to_a
    @grid = []
    10.times { @grid << letters[rand(letters.size)] }
    return @grid
  end
  def score
    raise
    attempt = params[:words]
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end
end

def run_game(attempt, grid, start_time, end_time)
  if !get_word_from_api(attempt)
    hash = { time: (end_time - start_time), score: 0, message: "not an english word" }
  elsif !validate_attempt(attempt.upcase, grid)
    hash = { time: (end_time - start_time), score: 0, message: "not in the grid" }
  else
    hash = { time: (end_time - start_time), score: (1 / (end_time - start_time)) * attempt.size, message: "well done" }
  end
  return hash
end

def validate_attempt(attempt, grid)
  letters = attempt.chars
  letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
end

def get_word_from_api(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  word_serialized = URI.open(url).read
  word = JSON.parse(word_serialized)
  return word["found"]
end
