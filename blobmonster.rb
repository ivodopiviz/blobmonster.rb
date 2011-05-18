require 'rubygems' rescue nil
require 'chingu'
include Gosu

class Point
    attr_accessor :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end
end

class BlobMonster
    def initialize(x, y, image)
        @x = x
        @y = y
        @image = image

        @speed = 1
        @segments = 10

        @tail = [] # of Points
        @time = 0

        for i in (0..@segments - 1)
            @tail[i] = Point.new(x, y)
        end
    end

    def update
        @time += @speed
        #y = (15 * Cos(time * -6)) + (240 + (180 * Sin(time * 1.3)))
	#x = (15 * Sin(time * -6)) + (320 + (200 * Cos(time / 1.5)))

        #@y = (15 * Math.cos(@time * -6)) + (240 + (180 * Math.sin(@time * 1.3)))
	#@x = (15 * Math.sin(@time * -6)) + (320 + (200 * Math.cos(@time / 1.5)))

	@x = $window.mouse_x
	@y = $window.mouse_y

	@tail[0].x = @x
	@tail[0].y = @y

	for i in (1..@segments - 1)
            distX = (@tail[i - 1].x - @tail[i].x)
            distY = (@tail[i - 1].y - @tail[i].y)
            dist = Math.sqrt(distX * distX + distY * distY)

            if dist > 7 then
                @tail[i].x = @tail[i].x + (distX * (0.3))
            	@tail[i].y = @tail[i].y + (distY * (0.3))
            end
	end
    end

    def calculate_angle(x1, y1, x2, y2)
        theX = x1-x2
	theY = y1-y2
	theAngle = -Math.atan2(theX, theY)

        return theAngle
    end

    def draw
        for i in (0..@segments - 1)
            #puts("Drawing @ #{@tail[i].x} , #{@tail[i].y}")
            @image.draw_rot(@tail[i].x, @tail[i].y, 0, 0, 0.5, 0.5, 1 + (0.5 * Math.sin(i * 35)), 1 + (0.5 * Math.sin(i * 35)), 0x26ffffff, :additive)
            @image.draw_rot(@tail[i].x, @tail[i].y, 0, 0, 0.5, 0.5, 0.1, 0.1, 0xccffffff, :additive)
        end
    end
end

class Game < Chingu::Window
    def initialize
        super(800, 600, false)
        self.input = { :escape => :exit}

        #@player = Player.create(:x => 200, :y => 200, :image => Image["blob.png"])
        #@player.input = { :holding_left => :move_left, :holding_right => :move_right,
        #                  :holding_up => :move_up, :holding_down => :move_down }

        @monster = BlobMonster.new(10, 10, Image["blob.png"])
    end

    def update
        super
        self.caption = "FPS: #{self.fps}"

        @monster.update
    end

    def draw
        @monster.draw
    end
end

class Player < Chingu::GameObject
    def move_left; @x -= 3; end
    def move_right; @x += 3; end
    def move_up; @y -= 3; end
    def move_down; @y += 3; end
end

Game.new.show
