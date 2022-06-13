require_relative 'movable'
require_relative 'steerable'
require_relative 'direction'

module Toy
  class Robot

    include Toy::Movable
    include Toy::Steerable

    attr_reader :direction, :x_coordinate, :y_coordinate

    COMMAND_REGEX=/^(move|right|left|report|(place [0-5],[0-5],(north|west|east|south)))$/i

    def initialize
      @x_coordinate = -1
      @y_coordinate = -1
    end

    def report
      p position_valid? ? current_post : 'Robot is not on the table yet.'
    end

    def execute(command_line)
      if valid_command?(command_line)
        ca = command_line.split(' ')
        send(ca.first.strip.downcase, *ca.fetch(1, '').split(','))
      end
    end

    def valid_command?(command)
      !(command =~ COMMAND_REGEX).nil?
    end

    def to_s
      [x_coordinate, y_coordinate, direction.to_s].join(',')
    end

    def position_valid?(x = x_coordinate, y = y_coordinate)
      x_range.include?(x.to_i) && y_range.include?(y.to_i)
    end

    def place(x, y, f)
      if position_valid?(x, y)
        @x_coordinate = x.to_i
        @y_coordinate = y.to_i
        @direction = Direction.new(f.upcase.to_sym)
      end
    end

    def step
      1
    end

    def range
      (0..5)
    end

    alias current_post to_s
    alias x_range range
    alias y_range range

  end
end
