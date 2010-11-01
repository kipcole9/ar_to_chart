module Charting
  module Highcharts
    # Produces a Funnel graph.  Subclasses Highcharts::Pie
    # since the data format is pretty much the same, only needs
    # different name.
    class Funnel < Charting::Highcharts::Pie
      
    end
  end
end
