extends Node2D


const Signals = Function.Skills.Signals


onready var skill01 = $Skill01



func _ready():
	# 连接节点信号
	for _signal in Signals.values():
		skill01.connect(_signal, self, '_skill_emited_signal', [_signal])


func _physics_process(delta):
	# 按下空格进行操控施放技能
	if Input.is_action_just_pressed("ui_accept"):
		skill01.control()


# 在下面连接信号的方法里写入功能
# 如果是操控了角色，则可以写入播放对应的动画的逻辑
func _skill_emited_signal(_signal: String):
	print(' --> ', _signal)
	
	match _signal:
		Signals.ReadyExecute:
			print("开始准备执行技能")
		Signals.ExecuteDuration:
			print('执行持续技能')
		Signals.Executed:
			print("执行技能结束，开始播放结束动作")
		Signals.ExecuteFinished:
			print("动作结束，技能过程全部结束")
		Signals.StatusRefreshed:
			print('技能刷新，可再次使用')
		Signals.Interrupted:
			print('技能被中断')

