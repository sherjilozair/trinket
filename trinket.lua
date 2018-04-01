local trinket = {_version = "0.1"}

local
function load_model(name)
    local buf, stride, normals_offset, tex_offset = am.load_obj(name)
    local verts = buf:view("vec3", 0, stride)
    local normals = buf:view("vec3", normals_offset, stride)
    return 
        am.bind{
            pos = verts,
            normal = normals,
        }
        ^am.draw[[triangles]]
end


function trinket.object(fname)
    local vshader = [[
    precision mediump float;
    attribute vec3 pos;
    attribute vec3 normal;
    uniform mat4 MV;
    uniform vec3 light;
    uniform mat4 P;
    varying vec3 v_color;
    void main() {
        vec3 nlight = normalize(light);
        vec3 nm = normalize((MV * vec4(normal, 0.0)).xyz);
        v_color = vec3(max(0.1, dot(nlight, nm))); // TODO: 0.1 isn't clear
        gl_Position = P * MV * vec4(pos, 1.0);
    }
    ]]

    local fshader = [[
    precision mediump float;
    varying vec3 v_color;
    void main() {
        gl_FragColor = vec4(v_color, 1.0); // TODO: alpha should also be supported
    }
    ]]

    local shader = am.program(vshader, fshader)

    local obj = load_model(fname)
    return am.use_program(shader) ^ am.bind{light=trinket._light} ^ obj
end


function trinket.light(light)
    trinket._light = light
end

return trinket