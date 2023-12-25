require 'sinatra/base'
require 'json'

module ExpenseTracker
  class API < Sinatra::Base

    post '/expenses' do
      JSON.generate([])
    end

  end
end
