# Adds method to Array to allow output of flash-based charts from
# active record result sets
module Charting
  module ActiveRecordArray
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
  
    module InstanceMethods
      # Render a chart based upon an ActiveRecord result set.
      # Requires jQuery.
      #
      # ====Parameters
      #
      #   columns:        column name (or array of names) representing the
      #                   Y-Axis
      #   label_column:   The category (X-Axis) column
      #
      # ====Options
      #
      #   See the options in Charting::Highcharts::Renderer
      def to_chart(columns, label_column, options = {})
        chart_object(columns, label_column, options).to_html
      end
     
      # Returns the chart container (the <div>) and the javascript
      # separately so you can put the container where you want and
      # the javascript at the end of the document
      def to_container_and_script(column, label_column, options = {})
        chart = chart_object(column, label_column, options)
        return chart.container, chart.script
      end
      
      # Render a sparkline based upon an ActiveRecord result set.
      # Requires jQuery and jQuery sparklines plugin.
      #
      # ====Parameters
      #
      #   column:         column name representing the
      #                   Y-Axis
      #   label_column:   The category (X-Axis) column
      #
      # ====Options
      #
      #   See the options in Charting::Sparklines::Renderer      
      def to_sparkline(column, options = {})
        sparkline_object(column, options).to_html
      end
      
    private
      # Eventually we'll do charting engine selection here.  For now 
      # only Highcharts or Sparklines
      def chart_object(label_column, columns, options)
        Charting::Highcharts::Renderer.new(self, columns, label_column, merged_options(options))
      end
      
      def sparkline_object(column, options)
        Charting::Sparklines::Renderer.new(self, column, merged_options(options))    
      end
      
      def merged_options(options)
        {}.merge(options)
      end
      
    end
  
    module ClassMethods

    end
  end
end