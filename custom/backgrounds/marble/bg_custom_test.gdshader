shader_type canvas_item;

uniform sampler2D tex0;

uniform vec2 res = vec2(400,300);
uniform vec4 windowRect = vec4(100,100, 100,100);
uniform vec2 windowCenterFollow = vec2(100,100);
global uniform float GAME_TIME = 0.0;

void fragment() {
	vec2 px = UV*res;
	vec2 gx = px - (windowRect.xy + windowRect.zw/2.0);
	
	vec3 col = vec3(0.0);
	
	float t = 0.3*GAME_TIME;
	vec2 move = windowCenterFollow*t*0.00005;
	
	float n1 = texture(tex0, mod((px + windowCenterFollow + move)/2500.0, vec2(1.0))).r;
	float n2 = texture(tex0, mod((px - windowCenterFollow + move)/3000.0, vec2(1.0))).r;
	vec2 dir = 8.0*(vec2(n1, n2)/5.0-0.5);
	dir -= 2.0*vec2(sin(t/15.0), cos(t/15.0+0.5));
	float n3 = texture(tex0, mod(-dir*(400.0+px + windowCenterFollow + move)/4000.0, vec2(1.0))).r;
	
	float v = pow(n1,1);
	float v2 = pow(n3,1);
	
	col = vec3(0.7*v*v2-0.6*pow(n2,2), 0.0, 0.2*v*v2+0.2*pow(n2,1.5));
	
	COLOR = vec4(col, 1.0);
}
