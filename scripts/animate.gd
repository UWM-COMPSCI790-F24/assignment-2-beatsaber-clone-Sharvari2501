extends CSGSphere3D

# Variables to control the movement, rotation, and scaling
var start_position: Vector3
var end_position: Vector3
var speed: float = 1.0  # Speed of movement
var rotation_speed: float = 1.0  # Speed of rotation
var scale_factor: float = 0.1  # Scaling factor
var direction: int = 1  # Direction of movement (1 for forward, -1 for backward)
var time: float = 0.0

func _ready():
	# Set the start and end positions for the movement (customize as needed)
	start_position = global_transform.origin  # Current position as the starting point
	end_position = start_position + Vector3(5, 0, 0)  # Move 5 units along the X-axis

	# Optionally, set the initial scale of the object (customize as needed)
	scale = Vector3(1, 1, 1)

func _process(delta: float):
	# Update the time variable for smooth transitions
	time += speed * delta * direction

	# Ensure smooth cyclic movement between start and end positions
	var new_position = start_position.lerp(end_position, (sin(time) + 1) / 2)
	global_transform.origin = new_position

	# Add rotation over time (rotate around the Y-axis)
	rotate_y(rotation_speed * delta)

	# Add scaling effect (oscillates scale based on sine wave)
	var scale_value = 1 + (sin(time) * scale_factor)
	scale = Vector3(scale_value, scale_value, scale_value)

	# Reverse direction if time exceeds a full oscillation (TAU is 2π)
	if time > TAU:
		time = 0.0  # Reset time after a full cycle
