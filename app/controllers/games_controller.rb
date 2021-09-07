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

    @results = nil

    letters.each do |letter|
      input.delete_at(input.index(letter)) if input.include?(letter)
    end

    if input.empty?
      if real_word
        @results = "<p>Congrats, <strong>#{input_for_result.upcase}</strong> is a valid word!</p>"
      else
        @results = "<p>Sorry, but <strong>#{input_for_result.upcase}</strong> does not seem to be a valid word...</p>"
      end
    else
      @results = "<p>Sorry, but <strong>#{input_for_result.upcase}</strong> cannot be built by #{letters.join(', ').upcase}.</p>"
    end
  end
end
