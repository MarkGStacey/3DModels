require 'sketchup.rb'

# Define parameters for the gyroid lattice
lattice_size = 100.mm
box_size = 200.mm
cell_size = 10.mm
thickness = 1.mm
resolution = 2

# Gyroid function
def gyroid(x, y, z, cell_size)
  Math.sin(x/cell_size) * Math.cos(y/cell_size) + Math.sin(y/cell_size) * Math.cos(z/cell_size) + Math.sin(z/cell_size) * Math.cos(x/cell_size)
end

# Create a new group for the gyroid heat exchanger
model = Sketchup.active_model
entities = model.active_entities
gyroid_group = entities.add_group
gyroid_entities = gyroid_group.entities

# Generate the gyroid lattice
(-lattice_size..lattice_size).step(cell_size/resolution) do |x|
  (-lattice_size..lattice_size).step(cell_size/resolution) do |y|
    (-lattice_size..lattice_size).step(cell_size/resolution) do |z|
      value = gyroid(x, y, z, cell_size)

      if value.abs < thickness
        pt1 = [x - cell_size/(2 * resolution), y - cell_size/(2 * resolution), z - cell_size/(2 * resolution)]
        pt2 = [x + cell_size/(2 * resolution), y - cell_size/(2 * resolution), z - cell_size/(2 * resolution)]
        pt3 = [x + cell_size/(2 * resolution), y + cell_size/(2 * resolution), z - cell_size/(2 * resolution)]
        pt4 = [x - cell_size/(2 * resolution), y + cell_size/(2 * resolution), z - cell_size/(2 * resolution)]

        pt5 = [x - cell_size/(2 * resolution), y - cell_size/(2 * resolution), z + cell_size/(2 * resolution)]
        pt6 = [x + cell_size/(2 * resolution), y - cell_size/(2 * resolution), z + cell_size/(2 * resolution)]
        pt7 = [x + cell_size/(2 * resolution), y + cell_size/(2 * resolution), z + cell_size/(2 * resolution)]
        pt8 = [x - cell_size/(2 * resolution), y + cell_size/(2 * resolution), z + cell_size/(2 * resolution)]

        new_face = gyroid_entities.add_face(pt1, pt2, pt3, pt4)
        new_face.pushpull(-cell_size/(2 * resolution))
        new_face = gyroid_entities.add_face(pt5, pt6, pt7, pt8)
        new_face.pushpull(-cell_size/(2 * resolution))
      end
    end
  end
end

# Close the sides of the heat exchanger
bounding_box = Geom::BoundingBox.new
gyroid_group.bounds.each { |pt| bounding_box.add(pt) }

base_face = gyroid_entities.add_face(bounding_box.corner(0), bounding_box.corner(1), bounding_box.corner(2), bounding_box.corner(3))
base_face.reverse!
base_face.pushpull(box_size)

top_face = gyroid_entities.add_face(bounding_box.cor
