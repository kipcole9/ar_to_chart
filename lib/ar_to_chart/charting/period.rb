# Parse parameters (usually from a request via ActionController) into
# chain of named scopes
#
# Format of query parameters:
# => by=dim1,dim2,dim3    dimensions
# => metric=metric1       a metric (only one at this time)
# => from=
# => to=

module Charting
  class Period
    def from_params(params = {})
      default_from  = (today - 30.days).beginning_of_day
      default_to    = today.end_of_day
      if params[:period]
        from, to = from_param(params[:period], default_from..default_to)
      else
        to = date_from_param(params[:to], default_to)
        from = date_from_param(params[:from], default_from)
      end       
      from..to
    end

    def date_from_param(date, default)
      return default unless date
      return date.to_date if date.is_a?(Date) || date.is_a?(Time)
      Time.parse(date) rescue default
    end

    def from_param(period, default)
      return default.first, default.last unless period
      period_range = case period.to_sym
        when :today          then today.beginning_of_day..today.end_of_day
        when :yesterday      then yesterday.beginning_of_day..yesterday.end_of_day
        when :this_week      then first_day_of_this_week.beginning_of_day..last_day_of_this_week.end_of_day
        when :this_month     then first_day_of_this_month.beginning_of_day..last_day_of_this_month.end_of_day
        when :this_year      then first_day_of_this_year.beginning_of_day..last_day_of_this_year.end_of_day
        when :last_week      then first_day_of_last_week.beginning_of_day..last_day_of_last_week.end_of_day
        when :last_month     then first_day_of_last_month.beginning_of_day..last_day_of_last_month.end_of_day
        when :last_year      then first_day_of_last_year.beginning_of_day..last_day_of_last_year.end_of_day
        when :last_30_days   then (today - 30.days).beginning_of_day..today.end_of_day
        when :last_12_months then (today - 12.months).beginning_of_day..today.end_of_day
        when :lifetime       then beginning_of_epoch.beginning_of_day..today.end_of_day;
        else default
      end
      return period_range.first, period_range.last
    end
  
    def range_from(params)
      period = self.from_params(params)
      case params[:time_group]
      when 'date'
        period.first.to_date..period.last.to_date
      when 'day_of_week'
        0..6
      when 'day_of_month'
        1..31
      when 'hour'
        0..24
      when 'month'
        1..12
      when 'year'
        period.first.to_date.year..period.last.to_date.year
      end
    end
  
    # Basic markers
    def today
      Time.zone.now.to_date
    end

    def yesterday
      today - 1.day
    end

    def tomorrow
      today + 1.day
    end

    def beginning_of_epoch
      today - 20.years
    end

    # This week
    def first_day_of_this_week
      today - today.wday.days
    end

    def last_day_of_this_week
      first_day_of_this_week + 7.days
    end

    # This month
    def first_day_of_this_month
      Date.new(today.year, today.month, 1)
    end

    def last_day_of_this_month
      first_day_of_this_month + 1.month - 1.day
    end

    # Last week
    def first_day_of_last_week
      first_day_of_this_week - 7.days
    end

    def last_day_of_last_week
      first_day_of_last_week + 7.days
    end

    # Last month
    def first_day_of_last_month
      last_month = Date.today - 1.month
      Date.new(last_month.year, last_month.month, 1)
    end

    def last_day_of_last_month
      first_day_of_last_month + 1.month - 1.day
    end

    # This year
    def first_day_of_this_year
      Date.new(today.year, 1, 1)
    end

    def last_day_of_this_year
      Date.new(today.year, 12, 31)
    end
  
    # Last year
    def first_day_of_last_year
      Date.new(today.year - 1, 1, 1)
    end

    def last_day_of_last_year
      Date.new(first_day_of_last_year.year, 12, 31)
    end
  
    # Clear the saved instance which we should do at the start
    # of each Rails request
    def self.clear
      Thread.current[:period] = nil
    end
  
    # Called when we're configured as a before_filter which we need to
    # ensure our thread data is ours and no left over from somebody else
    def self.filter(controller)
      clear
    end

    # Arrange for instance methods to be called as if class methods.  Make threadsafe.
    def self.method_missing(method, *args)
      Thread.current[:period] = new unless Thread.current[:period]
      self.instance_methods.include?(method.to_s) ? Thread.current[:period].send(method, *args) : super
    end
  end
end