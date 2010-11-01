module Charting
  module Sparklines
    class Base
      attr_reader :data_source, :data_column, :options
      
      DEFAULT_OPTIONS = {}

      def initialize(data_source, data_column, options = {})
        @data_source      = data_source
        @data_column      = data_column
        @options          = DEFAULT_OPTIONS.merge(options)
      end
    
      # No options currently defined
      def chart_options
        {}
      end
    
      # Define in concrete subclass
      def series
        []
      end
      
      # The name of a data series
      def series_name
        data_source.first.class.human_attribute_name(data_column)
      end
      
      # The chart type (derived from the class name)
      def chart_type
        @chart_type ||= self.class.name.split('::').last.downcase
      end

      # Render the chart HTML.  Requires jQuery and jQuery sparklines plugin
      def to_html
        <<-EOF
          <span id="#{container_id}" class="#{chart_css_class}">
            #{series.join(',')}
          </span>
        EOF
      end
      
    private
      def chart_css_class
        "spark#{chart_type}"
      end

      def container_id
        @container_id ||= options[:container]
      end

    end
  end
end