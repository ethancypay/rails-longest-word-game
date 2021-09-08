require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    20.times { @letters << ('a'..'z').to_a[rand(0..25)] }
  end

  def score
    input = params['letter-game-input'].downcase.split(//)
    input_for_result = params['letter-game-input']

    file = URI.open("https://wagon-dictionary.herokuapp.com/#{input_for_result}").read
    doc = JSON.parse(file)
    real_word = doc['found']

    letters = params['data_letters'].split(' ')

    letters.each do |letter|
      input.delete_at(input.index(letter)) if input.include?(letter)
    end

    if real_word && input.empty?
      @results = "Congrats, #{input_for_result.upcase} is a valid word!"
    elsif !input.empty?
      @results = "Sorry, but #{input_for_result.upcase} cannot be built by #{letters.join(', ').upcase}."
    else
      @results = "Sorry, but #{input_for_result.upcase} does not seem to be a valid word..."
    end
  end
end
