require 'grape_logging'

module  API
  module V1
    class Mount < Grape::API
      mount V1::Customer
    end
  end
end