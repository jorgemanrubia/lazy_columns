module LazyColumns
  module ActsAsLazyColumnLoader
    extend ActiveSupport::Concern

    module ClassMethods
      def lazy_load(column_or_columns)
        lazy_columns = as_array_of_strings column_or_columns
        exclude_columns_from_default_scope lazy_columns
        make_columns_lazy_loadable lazy_columns
      end

      private

      def as_array_of_strings(element_or_elements)
        array = element_or_elements.respond_to?(:each) ? element_or_elements : [element_or_elements]
        array.collect(&:to_s)
      end

      def exclude_columns_from_default_scope(columns)
        default_scope select((column_names - columns).map { |column_name| "`#{table_name}`.`#{column_name}`" })
      end

      def make_columns_lazy_loadable(columns)
        columns.each { |column| define_lazy_load_method_for column }
      end

      def define_lazy_load_method_for(column)
        define_method column do
          self.reload(select: column) unless has_attribute?(column)
          read_attribute column
        end
      end
    end
  end
end

if ActiveRecord::Base.respond_to?(:lazy_load)
  $stderr.puts "ERROR: Method `.lazy_load` already defined in `ActiveRecord::Base`. This is incompatible with LazyColumns and the plugin will be disabled."
else
  include LazyColumns::ActsAsLazyColumnLoader
end


