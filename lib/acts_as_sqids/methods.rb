require_relative 'core'

module ActsAsSqids
  module Methods
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_sqids(options = {})
        include ActsAsSqids::Core unless ancestors.include?(ActsAsSqids::Core)

        define_singleton_method :hashids_secret do
          secret = options[:secret]
          (secret.respond_to?(:call) ? instance_exec(&secret) : secret) || base_class.name
        end

        define_singleton_method :hashids do
          length = options[:length] || 8
          alphabet = options[:alphabet] || Sqids::DEFAULT_ALPHABET
          Sqids.new(hashids_secret, length, alphabet)
        end
      end
    end
  end
end
