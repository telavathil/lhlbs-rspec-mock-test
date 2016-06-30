class Battery < Item

  def initialize(name,weight)
    super(name,weight)
  end

  def charge(robot)

    robot.shields = 50
  end
end
