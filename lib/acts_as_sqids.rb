module ActsAsSqids
  class Exception < ::Exception; end
end

require 'acts_as_sqids/version'

if defined?(Rails::Railtie)
  require 'acts_as_sqids/railtie'
elsif defined?(ActiveRecord)
  require 'acts_as_sqids/methods'
  ActiveRecord::Base.send(:include, ActsAsSqids::Methods)
end
