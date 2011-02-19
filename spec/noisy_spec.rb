require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Noisy::Noisy' do
  before(:all) do
    seed = 1 + rand(100)
    @check_x = 1 + rand(10) + rand
    @check_y = 1 + rand(10) + rand
    puts "Running tests with seed #{seed} and check value [#{@check_x}, #{@check_y}]"

    @noisy = Noisy::Noisy.new(seed)
  end

  describe '#raw_noise' do
    it 'returns a number from -1.0 to 1.0' do
      @noisy.raw_noise(@check_x).should be_within(1.0).of(0.0)
    end

    it 'returns the same number for the same input' do
      v1 = @noisy.raw_noise(@check_x)
      v2 = @noisy.raw_noise(@check_x)
      v1.should == v2
    end
  end

  describe '#raw_noise_2d' do
    it 'returns a number from -1.0 to 1.0' do
      @noisy.raw_noise_2d(@check_x, @check_y).should be_within(1.0).of(0.0)
    end

    it 'returns the same number for the same input' do
      v1 = @noisy.raw_noise_2d(@check_x, @check_y)
      v2 = @noisy.raw_noise_2d(@check_x, @check_y)
      v1.should == v2
    end
  end

  describe '#smooth_noise' do
    it 'return a number not drastically different from near noise values' do

      threshold = 0.6

      v1 = @noisy.smooth_noise(@check_x - 1)
      v2 = @noisy.smooth_noise(@check_x)
      v3 = @noisy.smooth_noise(@check_x + 1)

      v2.should be_within(threshold).of(v1)
      v2.should be_within(threshold).of(v3)
    end
  end

  describe 'interpolation' do
    before(:each) do
      @a, @b, @x = 0.0, 5.0, 0.5
    end

    describe '#linear_interpolate' do
      it 'return a value between a and b' do
        n = @noisy.linear_interpolate(@a, @b, @x)
        n.should >= @a
        n.should <= @b
      end

      it 'return a when x is 0' do
        @noisy.linear_interpolate(@a, @b, 0.0).should == @a
      end

      it 'return b when x is 1' do
        @noisy.linear_interpolate(@a, @b, 1.0).should == @b
      end
    end

    describe '#cosine_interpolate' do
      it 'return a value between a and b' do
        n = @noisy.cosine_interpolate(@a, @b, @x)
        n.should >= @a
        n.should <= @b
      end

      it 'return a when x is 0' do
        @noisy.cosine_interpolate(@a, @b, 0.0).should == @a
      end

      it 'return b when x is 1' do
        @noisy.linear_interpolate(@a, @b, 1.0).should == @b
      end
    end
  end

  describe '#interpolate_noise' do
    it 'returns a number from -1.0 to 1.0' do
      @noisy.interpolate_noise(@check_x).should be_within(1.0).of(0.0)
    end

    it 'returns the same number for the same input' do
      v1 = @noisy.interpolate_noise(@check_x)
      v2 = @noisy.interpolate_noise(@check_x)
      v1.should == v2
    end
  end

  describe '#perlin_noise' do
    it 'returns a number from -1.0 to 1.0' do
      @noisy.perlin_noise(@check_x).should be_within(1.0).of(0.0)
    end

    it 'returns the same number for the same input' do
      v1 = @noisy.perlin_noise(@check_x)
      v2 = @noisy.perlin_noise(@check_x)
      v1.should == v2
    end
  end

  describe '#perlin_noise_2d' do
    it 'returns a number from -1.0 to 1.0' do
      @noisy.perlin_noise_2d(@check_x, @check_y).should be_within(1.0).of(0.0)
    end

    it 'returns the same number for the same input' do
      v1 = @noisy.perlin_noise_2d(@check_x, @check_y)
      v2 = @noisy.perlin_noise_2d(@check_x, @check_y)
      v1.should == v2
    end
  end

  describe '#perlin_noise_map' do
    it 'returns a multidimensional array with perlin noise values for [x, y]' do
      a = @noisy.perlin_noise_map(5, 5)
      a.count.should == a.first.count
    end
  end

  describe '#generate_plot' do
    it 'generates an image representing one dimensional perlin noise plotted on an x,y graph' do
      fileName = 'test-plot-' + (1 + rand(100)).to_s + '.png'
      @noisy.generate_plot(10, 10, fileName)
      File.exist?(fileName).should == true
      File.delete(fileName) if File.exist?(fileName)
    end
  end

  describe '#generate_map' do
    it 'generates an image representing two dimensional perlin noise plotted on an x,y graph' do
      fileName = 'test-plot-' + (1 + rand(100)).to_s + '.png'
      @noisy.generate_map(10, 10, fileName)
      File.exist?(fileName).should == true
      File.delete(fileName) if File.exist?(fileName)
    end
  end


end
