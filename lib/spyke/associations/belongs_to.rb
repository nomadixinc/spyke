module Spyke
  module Associations
    class BelongsTo < Association
      def initialize(*args)
        super
        @options.reverse_merge!(uri: "#{@name.to_s.pluralize}/:#{primary_key}", foreign_key: "#{klass.model_name.element}_id")
        @params[primary_key] = primary_key_value

        #  ADD MISSING PARAMS FROM PARENT DATA
        Spyke::Path.new(@options[:uri]).variables.each do |v|
          next if v == primary_key
          @params[v] = parent.attributes[v] if !@params.has_key?(v) && parent.attributes.has_key?(v)
        end
      end

      def find_one
        return unless fetchable?
        super
      end

      private

        def fetchable?
          (primary_key_value || embedded_data).present?
        end

        def primary_key_value
          parent.try(foreign_key)
        end
    end
  end
end
