extends Main

#TODO: Add curves. Play with radius, x, y, etc
#Animates Godot in a circle using cos/x, sin/y and radius around a center_x,center_y 
#This draws a cos and sin wave.
#At the moment SineWave is just a Line2D node.
#This will probably stay like this until https://github.com/godot-rust/gdextension/issues/55
#is resolved. Then all this code will be moved into
#a rust gdextension; that it is  modular and scalable.
var sin_wave = SineWave2D.new();
var cos_wave = Line2D.new();

var y_axis = Line2D.new();
var x_axis = Line2D.new();	

var Origin = Vector2(300,200);

var obj = Sprite2D.new()

var current_sinusoidal_output_val = 0
var current_cos_output_val = 0
var sin_step = 0.05  #radians/spped/rate
var current_sin_input_val = 0
var output_scale = 50

var sin_output_offset = Origin.y  # Added to sin_output
var sin_label = Label.new()
var cos_label = Label.new()

var center_x = Origin.x
var center_y = Origin.y

var speed_spinner = SpinBox.new()
var speed_label = Label.new()

var current_angle = 0

var radius = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var image = Image.load_from_file("res://assets/arrow-png-images-3.png")
	var texture = ImageTexture.create_from_image(image)
	
	obj.texture = texture
	obj.position = Origin
	
#	Rotate the asset rather than in code
#	obj.rotate(PI)
	image = Image.load_from_file("res://assets/arrow-png-images-3.png")
	texture = ImageTexture.create_from_image(image)
	
	obj.scale = Vector2(0.05,0.05)
	
	y_axis.default_color = Color(Color.YELLOW)
	y_axis.default_color.a = 0.25
	
	y_axis.points = [Vector2(Origin.x, Origin.y-100), Vector2(Origin.x, Origin.y+300)]
	
	x_axis.default_color = Color(Color.YELLOW)
	x_axis.default_color.a = 0.25
	
	x_axis.points = [Vector2(Origin.x-100, Origin.y), Vector2(Origin.x+300, Origin.y)]
	
	sin_wave.default_color = Color.PURPLE
	super.new_game()
	sin_wave.points = get_sin_full_circle_2dvectors(30, 50, 2)
	sin_wave.position = Origin

	cos_wave.points = get_cos_full_circle_2dvectors(30, 50, 2)
	cos_wave.position = Origin
	
	sin_label.text = "Sin"
	cos_label.text = "Cos"
	cos_label.position.y += 25
	sin_label.add_theme_color_override("font_color", sin_wave.default_color)
	
	speed_spinner.position.y += 50
	speed_spinner.step = .01
	
	speed_label.text = "Speed/Angle(Radians):"
	
	speed_label.position.y = speed_spinner.position.y
	
	speed_spinner.position.x += 175
	
	speed_spinner.value_changed.connect(update_sin_step)	
	speed_spinner.value = sin_step
	add_child(sin_wave)
	add_child(cos_wave)
	add_child(y_axis)
	add_child(x_axis)
	add_child(obj)

	add_child(sin_label)
	add_child(cos_label)
	add_child(speed_spinner)
	add_child(speed_label)

func get_sin_full_circle_2dvectors(degrees_delta: int, scale: int, number_of_phases: int) -> Array:
	var points = []
	var i = 0;
	while i < number_of_phases * (2 * PI):
		var x = sin(i)
		points.append(Vector2(i*scale, x*scale))
		i += deg_to_rad(degrees_delta)
	return points

func get_cos_full_circle_2dvectors(degrees_delta: int, scale: int, number_of_phases: int ) -> Array:
	var points = []
	var i = 0;
	while i < number_of_phases * (2 * PI):
		var x = cos(i)
		points.append(Vector2(i*scale, x*scale))
		i += deg_to_rad(degrees_delta)
	return points


#In this case our curve is just a simple "circle". No fancy curves yet.
func calc_curve(speed_agle: float):
	pass

func update_sin_step(value: float):
	sin_step = value

func _physics_process(delta):
	var prev_rotation = current_sin_input_val;
	current_sinusoidal_output_val = sin(current_sin_input_val) 
	current_cos_output_val = cos(current_sin_input_val) 
	
	obj.position.x = center_x
	obj.position.y = center_y
	obj.position.y += (radius * current_sinusoidal_output_val)  
	obj.position.x += (radius * current_cos_output_val)  
	
	current_sin_input_val += sin_step
	var tan_x = obj.position.x - center_x
	var tan_y = obj.position.y - center_y
	current_angle  = atan2(tan_y, tan_x)
	obj.rotation = current_angle
	
func _process(delta):
	pass
