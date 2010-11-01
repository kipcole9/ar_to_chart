module Charting
  module Highcharts
    class Pie < Charting::Highcharts::Base

      # Generate data series array (for each data column)
      def series
        data_columns.inject([]) do |series, column|
          series_data = data_source.inject([]) do |series_data, row|
            series_data << [row.format_column(category_column).strip_tags.strip, row[column].to_i]
          end
          series << {:type => chart_type, :name => series_name(column), :data => series_data}
        end
      end

      # No categories for pie charts
      def categories
        nil
      end

    end
  end
end
