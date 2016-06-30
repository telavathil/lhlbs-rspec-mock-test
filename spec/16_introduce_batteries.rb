require_relative 'spec_helper'

describe Battery do
  before :each do
    @battery = Battery.new("Battery",25)
  end

  it "should be an item" do
    expect(@battery).to be_an(Item)
  end

  it "should have name 'Battery'" do
    expect(@battery.name).to eq("Battery")
  end

  it "should have weight 25" do
    expect(@battery.weight).to eq(25)
  end

  describe "#charge" do
    before :each do
      @robot = Robot.new
    end

    it "recharges the robots shields to full" do
      @robot.shields = 0
      @battery.charge(@robot)
      expect(@robot.shields).to eq(50)

    end
  end
end
