require 'argd'
require 'colored'

module KernelColors
  alias_method :inform, :puts

  { abort: :red, inform: :cyan, warn: :magenta }.each do |method, color|
    original_method = "original_#{method}".to_sym
    alias_method original_method, method
    define_method(method) { |*args| send original_method, colorize_arguments(color, *args).join($\) }
    private original_method
  end

  private

  def colorize_arguments(color, *args)
    # TODO checking if AutoColor is disabled is not enough since OptionParser may abort prior to that happening
    return args if (respond_to?(:colored) && colored === false) || ARGD.include?('--no-color')
    args.map { |arg| Colored.colorize arg.to_s, foreground: color }
  end
end

Object.send(:include, KernelColors)
