require 'pry'

class RobotError < StandardError
end

class RobotAlreadyDeadError < RobotError
end

class UnattackableEnemy < RobotError
end

class Robot
    attr_reader :position, :items
    attr_accessor :health, :equipped_weapon, :shields

    @@robots =[]

    def initialize
        @position = [0, 0]
        @items = []
        @health = 100
        @equipped_weapon = nil
        @shields = 50
        @@robots << self
    end

    def self.robots
      @@robots
    end

    def self.in_position(x, y)
      @@robots.select {|robot| robot.position[0] == x && robot.position[1] == y}
    end

    def self.dump_robots
      @@robots = []
    end

    def scanning
      self.position[0],self.position[1]
    end

    def move_left
        @position[0] -= 1
    end

    def move_right
        @position[0] += 1
    end

    def move_up
        @position[1] += 1
    end

    def move_down
        @position[1] -= 1
    end

    def pick_up(item)
        if item.class == BoxOfBolts && health < 81
            # binding.pry
            item.feed(self)
        end
        items << item if items_weight < 250
        @equipped_weapon = item if item.class <= Weapon
    end

    def items_weight
        if items == []
            0
        else
            items.inject(0) { |sum, item| sum + item.weight }
        end
    end

    def wound(damage)
        if ((@shields - damage) < 0)
            if damage < @health
                @health -= (@shields - damage).abs
                @shields = 0
            else
                @health = 0
            end
        else
            @shields -= damage
        end
      end

        def heal(healing)
            if (healing + @health) > 100
                @health = 100
            else
                @health += healing
            end
        end

        def attack(robot)
            # if robot is more than one space away, no attack occurs
            weapon_range = equipped_weapon.nil? ? 0 : equipped_weapon.range
            pos_greater_than_range = []
            robot.position.each_index do |index|
                pos_greater_than_range <<
                    ((robot.position[index] - @position[index]).abs > weapon_range)
            end

            unless pos_greater_than_range.include? true

                if @equipped_weapon.nil?
                    robot.wound(5)
                else
                    equipped_weapon.hit(robot)
                    self.equipped_weapon = nil if equipped_weapon.name == 'Grenade'
                end
            end
          end

        def heal!(healing)
            if (healing + @health) > 100
                @health = 100
            elsif @health < 1
                raise RobotAlreadyDeadError, 'Robot is dead'
                return
            else
                @health += healing
            end
        end

        def attack!(robot)
            if robot.class != Robot
                raise UnattackableEnemy, 'Robots only attack other robots'
                return
            end
            if @equipped_weapon.nil?
                robot.wound(5)
            else
                equipped_weapon.hit(robot)
            end
        end
end
