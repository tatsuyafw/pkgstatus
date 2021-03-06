module Packary
  module RegistryPackages
    class RubygemsPackage
      def initialize(name)
        @name = name
      end

      attr_reader :name

      def self.metric_classes
        [
          ::Packary::Metrics::RegistryPackage::DownloadsMetric,
          ::Packary::Metrics::RegistryPackage::ReleasesMetric,
          ::Packary::Metrics::RegistryPackage::ReleasesInMetric,
          ::Packary::Metrics::RegistryPackage::LatestReleaseMetric,
        ]
      end

      # Attach resource from cache
      attr_writer :resource
      def resource
        @resource ||= {}
      end

      def metrics
        self.class.metric_classes.map { |klass| klass.new.preload(self) }
      end

      def gem_info
        resource[:info] ||= begin
                              Gems.info(name)
                            rescue JSON::ParserError
                              # When the package is not found on rubygems,
                              # Gems does try to parse html as json and raise JSON::ParserError :sob:
                              nil
                            end
      end

      def gem_versions
        resource[:versions] ||= begin
                                  Gems.versions(name)
                                rescue JSON::ParserError
                                  # When the package is not found on rubygems,
                                  # Gems does try to parse html as json and raise JSON::ParserError :sob:
                                  nil
                                end
      end

      # for metric
      def downloads
        gem_info&.dig('downloads')
      end

      def html_url
        "https://rubygems.org/gems/#{name}"
      end
    end
  end
end
