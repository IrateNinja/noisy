module Noisy
  class Noisy
    def initialize(seed = 1, octaves = 4, persistence = 0.25)
      @seed = seed
      @octaves = octaves
      @persistence = persistence
    end

    def raw_noise(x)
      n = (x.to_i << 13) ^ x.to_i
      (1.0 - ((n * (n * n * 15731 * @seed + 789221 * @seed) + 1376312589 * @seed) & 0x7fffffff) / 1073741824.0)
    end

    def raw_noise_2d(x, y)
      n = (x + y * 57).to_i
      n = (n << 13) ^ n
      (1.0 - ((n * (n * n * 15731 * @seed + 789221 * @seed) + 1376312589 * @seed) & 0x7fffffff) / 1073741824.0)
    end

    def smooth_noise(x)
      left = raw_noise(x - 1.0)
      right = raw_noise(x + 1.0)
      raw_noise(x)/2.0 + left/4.0 + right/4.0
    end

    def smooth_noise_2d(x, y)
      corners = raw_noise_2d(x - 1, y - 1) + raw_noise_2d(x - 1, y + 1) + raw_noise_2d(x + 1, y - 1) + raw_noise_2d(x + 1, y + 1)
      sides = raw_noise_2d(x, y - 1) + raw_noise_2d(x, y + 1) + raw_noise_2d(x - 1, y) + raw_noise_2d(x + 1, y)
      center = raw_noise_2d(x, y)

      center / 4 + sides / 8 + corners / 16
    end

    def linear_interpolate(a, b, x)
      a * (1 - x) + b * x
    end

    def cosine_interpolate(a, b, x)
      f = (1 - Math.cos(x * Math::PI)) / 2
      a * (1 - f) + b * f
    end

    # alias interpolate linear_interpolate
    alias interpolate cosine_interpolate

    def interpolate_noise(x)
      interpolate(smooth_noise(x.floor), smooth_noise(x.floor + 1), x - x.floor)
    end

    def interpolate_noise_2d(x, y)
      a = interpolate(smooth_noise_2d(x.floor, y.floor), smooth_noise_2d(x.floor + 1, y.floor), x - x.floor)
      b = interpolate(smooth_noise_2d(x.floor, y.floor + 1), smooth_noise_2d(x.floor + 1, y.floor + 1), x - x.floor)
      interpolate(a, b, y - y.floor)
    end

    def perlin_noise(x)
      total = 0.0
      (0...@octaves).each do |i|
        frequency = 2.0 ** i
        amplitude = @persistence ** i
        total += interpolate_noise(x * frequency) * amplitude
      end
      total
    end

    def perlin_noise_2d(x, y)
      total = 0.0
      (0...@octaves).each do |i|
        frequency = 2.0 ** i
        amplitude = @persistence ** i
        total += interpolate_noise_2d(x * frequency, y * frequency) * amplitude
      end
      total
    end

    def perlin_noise_map(width, height)
      noise = Array.new(width)
      noise.map! { Array.new(height) }
      (0...width).each do |x|
        (0...height).each do |y|
          noise[x][y] = perlin_noise_2d(x, y)
        end
      end
      noise
    end
  end
end
