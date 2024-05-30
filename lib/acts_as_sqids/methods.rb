require_relative 'core'

module ActsAsSqids
  module Methods
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_sqids(options = {})
        include ActsAsSqids::Core unless ancestors.include?(ActsAsSqids::Core)

        define_singleton_method :sqids do
          length = options[:length] || 8
          alphabet = options[:alphabet] || Sqids::DEFAULT_ALPHABET
          blocklist = options[:blocklist] || Sqids::DEFAULT_BLOCKLIST
          Sqids.new(min_length: length, alphabet: alphabet, blocklist: blocklist)
        end
      end
    end
  end
end
