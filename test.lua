local tr = require('trinket')

local win = am.window{depth_buffer = true, msaa_samples = 8}

win.projection = math.perspective(math.rad(85), 1, 1, 1000)

local rotator = 
    am.rotate(quat(0))
        :action(coroutine.create(function(node)
            while true do
                local angle = math.random() * 2 * math.pi
                local axis = math.normalize(vec3(math.random(), math.random(), math.random()) - 0.5)
                am.wait(am.tween(3, {rotation = quat(angle, axis)},
                    am.ease.inout(am.ease.cubic)), node)
                am.wait(am.delay(0.1))
            end
        end))

tr.light(vec3(1.0, 1.0, 1.0))

local scene = am.translate(vec3(0, 0, -10)) 
              ^ rotator
              ^ tr.object("cube.obj")

print(scene.value)
win.scene = scene