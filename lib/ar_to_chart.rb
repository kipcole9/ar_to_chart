require File.dirname(__FILE__) + '/ar_to_chart/charting/highcharts.rb'
require File.dirname(__FILE__) + '/ar_to_chart/charting/sparklines.rb'
require File.dirname(__FILE__) + '/ar_to_chart/charting/period.rb'
require File.dirname(__FILE__) + '/ar_to_chart/charting/highcharts/base'
require File.dirname(__FILE__) + '/ar_to_chart/charting/highcharts/area'
require File.dirname(__FILE__) + '/ar_to_chart/charting/highcharts/pie'
require File.dirname(__FILE__) + '/ar_to_chart/charting/highcharts/funnel'

require File.dirname(__FILE__) + '/ar_to_chart/active_record_array.rb'
Array.send :include, Charting::ActiveRecordArray

require File.dirname(__FILE__) + '/ar_to_chart/charting/transforms.rb'
ActiveRecord::Base.send :include, Charting::Transforms

I18n.load_path << Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{rb,yml}') ]

module ArToChart
  # Your code goes here...
end
