require 'acts_as_sqids/methods'

module ActsAsSqids
  class Railtie < Rails::Railtie
    initializer 'acts_as_hashids.include_methods' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsSqids::Methods)
      end
    end
  end
end
