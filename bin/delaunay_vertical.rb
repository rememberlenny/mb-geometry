#!/usr/bin/env ruby
# A tall vertical line with a single point away from it.

require 'bundler/setup'

require 'pry'
require 'pry-byebug'

require 'benchmark'

require 'json'

$:.unshift(File.join(__dir__, '..', 'lib'))
require 'mb/delaunay'

# TODO: Add to specs as well
count = ARGV[0]&.to_i || 100
points = -100.upto(100).map { |y|
  [-1, y * 0.01]
}

points << [1, 0]

t = nil

begin
  t = MB::Delaunay.new(points)
rescue => e
  puts "\n\n\e[31mError in triangulation: \e[1m#{e}\e[0m"

  filename = File.join(__dir__, '..', 'test_data', Time.now.strftime("%Y-%m-%d_%H-%M-%S_bad_bench.json"))
  puts "Saving problematic points to \e[1m#{filename}\e[0m\n\n"

  File.write(filename, JSON.pretty_generate(points.sort.map { |p| { x: p[0], y: p[1] } }))

  raise
end

File.write('/tmp/delaunay_vertical.json', JSON.pretty_generate(t.to_h))
