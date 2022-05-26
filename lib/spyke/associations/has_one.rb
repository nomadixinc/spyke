module Spyke
  module Associations
    class HasOne < Association
      def initialize(*args)
        super
        @options.reverse_merge!(uri: "#{parent.class.model_name.plural}/:#{foreign_key}/#{@name}")
        @params[foreign_key] = parent.id

        #  ADD MISSING PARAMS FROM PARENT DATA - USEFUL FOR TRIPLE-NESTED (OR WORSE) MODELS
        Spyke::Path.new(@options[:uri]).variables.each do |v|
          next if v == primary_key
          @params[v] = parent.attributes[v] if !@params.has_key?(v) && parent.attributes.has_key?(v)
        end
      end
    end
  end
end
