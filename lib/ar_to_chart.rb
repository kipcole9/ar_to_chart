require File.dirname(__FILE__) + '/charting/highcharts.rb'
require File.dirname(__FILE__) + '/charting/sparklines.rb'
require File.dirname(__FILE__) + '/charting/period.rb'
require File.dirname(__FILE__) + '/charting/highcharts/base'
require File.dirname(__FILE__) + '/charting/highcharts/area'
require File.dirname(__FILE__) + '/charting/highcharts/pie'
require File.dirname(__FILE__) + '/charting/highcharts/funnel'

require File.dirname(__FILE__) + '/active_record_array.rb'
Array.send :include, Charting::ActiveRecordArray

require File.dirname(__FILE__) + '/charting/transforms.rb'
ActiveRecord::Base.send :include, Charting::Transforms

I18n.load_path << Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{rb,yml}') ]

module ArToChart
  # Your code goes here...
end
