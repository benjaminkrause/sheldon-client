require 'addressable/uri'

class SheldonClient
  module UrlHelper
    include ActiveSupport::Inflector
    
    def connections_url( from, type, to = nil )
      if to.nil?
        path = "/nodes/#{from.to_i}/connections/#{type.to_s.pluralize}"
      else
        path = "/nodes/#{from.to_i}/connections/#{type.to_s.pluralize}/#{to.to_i}"
        
      end
      Addressable::URI.parse( SheldonClient.host + path )
    end
    
    def node_url( *args )
      if     args[0].is_a?(Numeric) and args[1].nil?
        # e.g. node_url( 1 )
        path = "/nodes/#{args[0]}"
      elsif !args[1].nil? and args[1].is_a?(Symbol)
        # e.g. node_url( 1, :reindex )
        path = "/nodes/#{args[0]}/#{args[1]}"
      elsif !args[1].nil?
        # e.g. node_url( :movie, 2 )
        path = "/nodes/#{args[0].to_s.pluralize}/#{args[1]}"
      elsif  args[0].is_a?(Symbol) or args[0].is_a?(String)
        # e.g. node_url( :movie )
        path = "/nodes/#{args[0].to_s.pluralize}"
      end
      Addressable::URI.parse( SheldonClient.host + path )
    end
    
    def neighbours_url( from, type = nil )
      path = "/nodes/#{from}/neighbours"
      path = path + "/#{type.to_s.pluralize}" if type
      Addressable::URI.parse( SheldonClient.host + path )
    end
    
    def search_url( query, options = {} )
      if options[:type]
        path = "/search/nodes/" + options.delete(:type).to_s.pluralize
      else
        path = "/search"
      end
      options[:mode] ||= :exact
      query = { q: query } if query.is_a?(String)
      uri = Addressable::URI.parse( SheldonClient.host + path )
      uri.query_values = query.update(options)
      uri
    end
    
    def status_url
      Addressable::URI.parse( SheldonClient.host + "/status" )
    end
  end
end


__END__

def self.build_search_url( type, query_parameters )
  uri = Addressable::URI.parse( self.host + "/search" + (type.nil? ? "" : "/nodes/#{type}") )
  uri.query_values = Hash[*query_parameters.clone.map{|k,v| [k,v.to_s]}.flatten] # convert values to strings
  uri
end

