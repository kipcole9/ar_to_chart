module Charting
  module Highcharts
    class Renderer
      DEFAULT_OPTIONS = {
        :container_height      => '200px',
        :type                  => :area,
      }
      DEFAULT_CHARTING_OBJECT = 'arToChart'
    
      attr_accessor :categories, :series, :options, :chart
      cattr_accessor :charting_object
      
      # Generate Highchart based charts.  CSS is used
      # for the colouring.  See the file ar_to_chart.css included
      # in the files directory of the gem.
      #
      # ====Parameters
      #
      #   data_source:        The active record result set
      #   category_column:    The column used for the x-axis
      #   data_columns:       one column name or an array of column names to be charted or a hash
      #                       with pairs of :column_names => :series_type
      #   options:            options hash 
      #
      # ====Options
      #
      #   :type               Chart type to render. Defauly is :area.  Other options
      #                       are :pie and :funnel.  Subclass Base to create other
      #                       chart types available in Highcharts. The name of the subclass
      #                       becomes the chart type.
      #   :container          DOM id of the container to render to.  Default is to
      #                       generate a name.
      #   :container_height   Requested height of the container.  Defaults to 200px
      #   :charting_object    The javascript object that is instantiated as the 
      #                       browser renderer. Defaults to arToChar (supplied in 
      #                       the files directory of the gem)
      #
      def initialize(data_source, category_column, data_columns, options = {})
        @options = DEFAULT_OPTIONS.merge(options)
        @options[:container] ||= generate_container_name
        @options[:charting_object] ||= self.class.charting_object || DEFAULT_CHARTING_OBJECT
        @data_columns = data_columns.respond_to?(:each) ? data_columns : [data_columns]
        @chart = chart_class.new(data_source, category_column, @data_columns, @options)
      end
      
      # Returns the <div> into which the chart will be rendered.
      def container
        <<-EOF
          <div id='#{container_id}' #{styles}"></div>
        EOF
      end
      
      # Returns the javscript (without <script> tag) that is sent
      # to the browser to render the chart.  Note that there is a 
      # dependency on the ar_to_chart.js javascript library being
      # loaded in the <head> of the document.
      #
      # See the ar_to_chart.js file included in the files directory
      # of the gem.
      def script
        <<-EOF
          $(document).ready(function() {
            chart = new #{charting_object};
            #{chart.to_js}
          });     
        EOF
      end
      
      # Return the HTML of the container <div> and the 
      # script to render the chart.
      def to_html
        <<-EOF
          #{container}
          <script type="text/javascript">
            #{script}
          </script>
        EOF
      end
      
      # Set configuration options.  Currently no options
      # are available.
      def self.configure
        yield self
      end
      
    private
      def chart_class
        @chart_class ||= "Charting::Highcharts::#{options[:type].to_s.titleize}".constantize
      end

      def container_id
        @container_id ||= options[:container]
      end
      
      def styles
        container_height ? "style='height:#{container_height}'" : ''
      end
      
      def container_height
        options[:container_height]
      end
      
      def charting_object
        options[:charting_object]
      end
      
      def generate_container_name
        "chart_" + ActiveSupport::SecureRandom.hex(3)
      end
      
    end
  end
end
