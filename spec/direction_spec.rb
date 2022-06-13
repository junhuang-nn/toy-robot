require 'toy/direction'

module Toy
  RSpec.describe(Direction) do

    subject do
      described_class.new(:NORTH)
    end

    it 'initialize with facing' do
      expect(subject.facing).to eq(:NORTH)
    end

    describe 'degree' do
      it ' is O for EAST' do
        expect(described_class.new(:EAST).degree).to eq 0
      end

      it ' is 18O for WEST' do
        expect(described_class.new(:WEST).degree).to eq 180
      end

      it ' is 90 for NORTH' do
        expect(described_class.new(:NORTH).degree).to eq 90
      end

      it ' is 270 for SOUTH' do
        expect(described_class.new(:SOUTH).degree).to eq 270
      end
    end

    describe 'set degree' do
      it 'should not change facing if invalid degree is given' do
        subject.degree = 101
        expect(subject.facing).to eq(:NORTH)
      end

      it 'should handle negative value' do
        subject.degree = -90
        expect(subject.facing).to eq(:SOUTH)
      end

      it 'should handle value greater than 360' do
        subject.degree = 360 + 180
        expect(subject.facing).to eq(:WEST)
      end
    end

    describe 'to_s' do
      it 'uses facing string' do
        expect(subject.to_s).to eq('NORTH')
      end
    end
  end
end
