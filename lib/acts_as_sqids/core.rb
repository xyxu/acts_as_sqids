require 'sqids'

module ActsAsSqids
  module Core
    extend ActiveSupport::Concern

    def to_param
      id = public_send(self.class.primary_key)
      id && self.class.sqids.encode([id])
    end

    module FinderMethods
      def find(ids = nil, &block)
        return detect(&block) if block.present? && respond_to?(:detect)

        encoded_ids = Array(ids).map do |id|
          id = id.to_i if Integer(id)
          sqids.encode([id])
        rescue TypeError, ArgumentError
          id
        end

        encoded_ids = encoded_ids.flatten

        res = with_sqids(encoded_ids).all
        if ids.is_a?(Array)
          raise_record_not_found_exception! encoded_ids, res.size, encoded_ids.size if res.size != encoded_ids.size
        else
          raise_record_not_found_exception! encoded_ids[0], res.size, encoded_ids.size if res.empty?
          res = res[0]
        end
        res
      end

      private

      def raise_record_not_found_exception!(ids, result_size, expected_size)
        if Array(ids).size == 1
          error = "Couldn't find #{name} with '#{primary_key}'=#{ids.inspect}"
        else
          error = "Couldn't find all #{name.pluralize} with '#{primary_key}': "
          error << "(#{ids.map(&:inspect).join(', ')}) (found #{result_size} results, but was looking for #{expected_size})"
        end

        raise ActiveRecord::RecordNotFound, error
      end
    end

    module ClassMethods
      include FinderMethods

      def with_sqids(*ids)
        ids = ids.flatten
        decoded_ids = ids.map { |id| sqids.decode(id) }.flatten
        raise ActsAsSqids::Exception, "Decode error: #{ids.inspect}" if ids.size != decoded_ids.size

        where(primary_key => decoded_ids)
      end

      def has_many(*args, &block) # rubocop:disable Naming/PredicateName
        options = args.extract_options!
        options[:extend] = (options[:extend] || []).concat([FinderMethods])

        clazz = options.fetch(:class_name, *args).to_s.singularize.camelize.constantize
        clazz.acts_as_sqids if !clazz.include?(ActsAsSqids::Core) && clazz.respond_to?(:acts_as_sqids)

        super(*args, **options, &block)
      end

      def relation
        r = super
        r.extend FinderMethods
        r
      end
    end
  end
end
