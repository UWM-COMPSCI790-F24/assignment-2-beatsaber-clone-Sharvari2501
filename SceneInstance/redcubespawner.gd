extends Node3D

@export var cube_scene: PackedScene  # Reference to the cube scene (assign in the editor)
@export var spawn_interval: float = 1.0  # Time in seconds between spawns
@export var z_position: float = 10.0  # Initial Z position of the spawned cubes
@export var y_min: float = 0.4  # Minimum Y position for spawning
@export var y_max: float = 2.0  # Maximum Y position for spawning
@export var x_range: float = 2.0  # Range for X position spawning
@export var move_speed: float = 2.0  # Speed at which cubes move towards the player

var timer: float = 0.0
var cubes = []

func _ready():
	# Check if cube_scene is assigned
	if cube_scene == null:
		print("Cube scene is not assigned!")
		return

	set_process(true)  # Start processing

func _process(delta):
	# Update timer and spawn cubes at intervals
	timer += delta
	if timer >= spawn_interval:
		spawn_cube()
		timer = 0.0  # Reset the timer

	# Move and remove cubes if they pass the maximum allowed distance
	for cube in cubes:
		# Move the cube towards the -Z direction
		cube.translate(Vector3(0, 0, -move_speed * delta))

		# Check if the cube has moved 10 meters behind the user's position
		if cube.transform.origin.z < -10.0:
			destroy_cube(cube)

func spawn_cube():
	# Instance a new cube from the PackedScene
	var new_cube = cube_scene.instantiate()
	if new_cube == null:
		print("Failed to instantiate cube!")
		return

	# Set random position within the specified range
	var x_position = randf_range(-x_range, x_range)
	var y_position = randf_range(y_min, y_max)
	new_cube.transform.origin = Vector3(x_position, y_position, z_position)
	var collision_shape = new_cube.get_node("CollisionShape3D")  # Adjust path if necessary
	if collision_shape != null:
		collision_shape.set_collision_layer(1 << 7)  # Layer 7 for red cubes
		collision_shape.set_collision_mask(1 << 7)
	# Add the new cube to the scene
	add_child(new_cube)
	cubes.append(new_cube)

	print("Spawned a new cube at position: ", new_cube.transform.origin)

func destroy_cube(cube):
	# Remove the cube from the scene and the list
	cubes.erase(cube)
	cube.queue_free()

	print("Cube destroyed")
