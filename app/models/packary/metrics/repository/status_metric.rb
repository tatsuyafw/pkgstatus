module Packary
  class Metrics::Repository::StatusMetric < Packary::Metric
    def self.group
      :repository
    end

    def self.title
      'CI Status'
    end

    def read(source)
      source.status
    end

    def status
      case value
      when 'pending'
        :warning
      when 'success'
        :success
      when 'failure'
        :danger
      end
    end
  end
end
