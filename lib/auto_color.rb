require 'colored'

module AutoColor
  def self.enable(options = {})
    target = options[:on].extend self::IO
    target.colored = options[:colored] != nil ? !!options[:colored] : true
    target.colorings = options[:colorings].to_h || {}
    target
  end

  def self.disable(options = {})
    enable options.merge colored: false
  end

  module IO
    attr_accessor :colored
    attr_accessor :colorings

    alias_method :default_print, :print
    alias_method :default_puts, :puts

    def puts(*args)
      default_puts *enrich(args)
    end

    def print(*args)
      default_print *enrich(args)
    end

    private

    def enrich(args)
      return colorize(args) if args.is_a? String
      return args.map { |a| a.is_a?(String) ? colorize(a) : a } if args.is_a? Array
      args
    end

    def colorize(s)
      return s.gsub(/\e\[(\d+)m/, '') unless colored

      (colorings || {}).each do |regexp, x|
        next if s !~ regexp
        (s = x.call s, regexp) and next if x.respond_to? :call
        [x].flatten.each { |m| s = s.send m }
      end

      s
    end
  end
end
