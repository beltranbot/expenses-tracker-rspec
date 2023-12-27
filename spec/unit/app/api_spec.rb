require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  # frozen_string_literal: true

  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expenses is successfully recorded' do
        expense = { 'some' => 'data' }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end
        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end

      describe 'GET /expenses/:date' do
        context 'when expenses exist on the given date' do
          it 'returns the expense records as JSON'
          it 'responds with a 200 (OK)'
        end
        context 'when there are no expenses on the given date' do
          it 'returns an empty array as JSON'
          it 'responds with a 200 (OK)'
        end
      end

      # context 'pending' do
      #   it 'records submitted expenses' do
      #     # POST coffee, zoo, and groceries expenses here
      #     pending 'Need to persist expenses'
      #     coffee = post_expense(
      #       'payee' => 'Starbucks',
      #       'amount' => 5.75,
      #       'date' => '2017-06-10'
      #     )
      #     zoo = post_expense(
      #       'payee' => 'Zoo',
      #       'amount' => 15.25,
      #       'date' => '2017-06-10'
      #     )
      #     groceries = post_expense(
      #       'payee' => 'Whole Foods',
      #       'amount' => 95.20,
      #       'date' => '2017-06-11'
      #     )
      #     get '/expenses/2017-06-10'
      #     expect(last_response.status).to eq(200)
      #     expenses = JSON.parse(last_response.body)
      #   end
      # end



      # context 'when the expense fails validation' do
      #   it 'returns an error message'
      #   it 'responds with a 422 (Unprocessable entity)'
      # end
    end
  end
end
