require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base

    def initialize(ledger:)
      @ledger = ledger
      super()
    end

    post '/expenses/?' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)
      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    post '/expenses/:date' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)
      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end
  end
end
