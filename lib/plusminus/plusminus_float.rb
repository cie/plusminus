class Plusminus::PlusminusFloat < Numeric

  DEFAULT_FMT = Nio::Fmt.default.dup

  def initialize value, delta
    @value = value.to_f
    @delta = delta.to_f.abs
  end

  attr_reader :value, :delta

  def to_pm
    self
  end

  def to_f
    @value
  end

  def hash
    @value.hash
  end

  def coerce other
    case other
    when Numeric
      return other.to_pm, self
    else
      raise ArgumentError "#{other} cannot be coerced to #{self.class}"
    end
  end

  def + other
    other = other.to_pm
    (@value + other.value).pm(@delta + other.delta)
  end

  def - other
    other = other.to_pm
    (@value - other.value).pm(@delta + other.delta)
  end

  def * other
    other = other.to_pm
    (self.value * other.value).pm(other.value.abs * self.delta + self.value.abs * other.delta)
  end
  
  def / other
    other = other.to_pm
    (self.value / other.value).pm(self.delta / other.value.abs + other.delta * self.value.abs / other.value.abs**2)
  end
  
  def ** other
    return 1 if other == 0
    return 0 if self == 0
    other = other.to_pm
    res = self.value ** other.value
    res.pm(
      (Math.log(self.value.abs) * res).abs * other.delta +
      (other.value * res / self.value).abs * self.delta
    )
  end

  def -@
    (-@value).pm @delta
  end

  def abs
    @value.abs
  end

  def == other
    @value == other
  end

  def eql? other
    return false unless other.is_a? self.class
    self.value == other.value and self.delta == other.delta
  end

  def <=> other
    self.value <=> other.to_pm.value
  end

  def === other
    other = other.to_pm.value
    @value-@delta < other and other < @value+@delta
  end

  # returns the Nio::Fmt to be used with the number. The returned object can be
  # modified with Nio::Fmt's bang methods 
  def fmt
    unless defined? @fmt
      @fmt = DEFAULT_FMT.dup
      case @value
      when -0.01 ... 0.01 then 
        @fmt.mode!(:sci, sig_digits)
      else 
        @fmt.mode!(:sig, sig_digits)
      end
    end

    @fmt
  end

  Plusminus::FORMATTING_METHODS.each do |m|
    class_eval <<-EOT
      def #{m}! *args
        fmt.#{m}! *args
        self
      end
    EOT
  end

  # returns the number of significant digits
  def sig_digits 
    return 0 if @value == 0
    return Float::DIG if @delta == 0
    Math.log(@value.abs,10).floor + 1.9999 - Math.log(@delta*2,10)
  end

  # produces a string of the number with the appropriate number of decimal
  # digits
  def nio_write fmt=nil
    @value.nio_write(fmt || self.fmt)
  end

  def to_s
    @value.to_s
  end

  def inspect
    "#{@value.inspect}.pm(#{delta.inspect})"
  end

  def to_latex fmt = nil
    fmt ||= self.fmt
    s = @value.nio_write(fmt || self.fmt)
    percent = s =~ /%\z/
    s.sub!(/%\z/, "")
    mantissa, exponent = s.split(/e/i)

    # if exponential form
    if exponent
      # strip decimal point or comma from end
      mantissa.sub!(/[^0-9a-zA-Z]+\z/, "") 

      exponent.sub!(/\A-0*/, "-").sub!(/\A0*/, "")
      res = "\\ensuremath{#{mantissa}\\cdot 10^{#{exponent}}}"
    else
      res = mantissa
    end

    res << "\\%" if percent
    res.respond_to?(:latex!) ? res.latex! : res
  end

  def to_latex_pm
    res = "#{to_latex} \\pm #{@delta.pm_rel(0.1).to_latex}"
    res.respond_to?(:latex!) ? res.latex! : res
  end

  def to_latex_math_pm
    res = "$#{to_latex_pm}$"
    res.respond_to?(:latex!) ? res.latex! : res
  end

end

# modified version of sqrt that uses **, to be able to coerce PlusminusFloat
#
def Math.sqrt x
  x ** 0.5
end
