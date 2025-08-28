shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable;
global uniform float GAME_TIME = 0.0;

uniform vec2 playerPos = vec2(0.0,0.0);
uniform vec3 playerColor = vec3(1.0,1.0,1.0);

uniform float audioData[20];

varying vec2 PX;
varying vec2 SRES;
varying vec2 SPOS;
void vertex(){
	SPOS = inverse(MODEL_MATRIX)[3].xy - vec2(CANVAS_MATRIX[3].xy);
	SRES = 2.0*vec2(1.0/((SCREEN_MATRIX))[0].x, 1.0/((SCREEN_MATRIX))[1].y);
	PX = (CANVAS_MATRIX * vec4(VERTEX, 1.0, 0.0)).xy;
}

vec2 toWorld(vec2 suv, vec2 res, vec2 sres){
	return (((suv*sres) + SPOS))/res;
}

vec2 fromWorld(vec2 uv, vec2 res, vec2 sres){
	return (((uv*res) - SPOS))/sres;
}

void fragment() {
	vec2 px = PX;
	//vec2 sres = SX/SCREEN_UV;
	vec2 sres = SRES;
	vec2 sx = SCREEN_UV*sres;
	//vec2 sres = usres;
	vec2 res = PX/UV;
	//vec2 res = usres;
	//vec2 res = vec2(1200.0,800.0);
	vec2 scenter = sres/2.0;
	vec2 center = res/2.0;
	
	vec4 baseCol = texture(screen_texture, fromWorld(UV, res, sres));
	vec4 col = vec4(0.0);
	
	//vec2 vv = fromWorld(UV, res, sres);
	vec2 _sx = fromWorld(px/res, res, sres);
	//_sx.y += 0.01*cos(_sx.x*100.0);
	vec2 suvx = _sx*sres;
	vec2 vv = px - playerPos;
	vec2 aring = vec2((PI/2.0 + atan(vv.y/vv.x))/(PI/1.0), length(vv));
	float m = audioData[int(aring.x*20.0)];
	if(aring.y > 100.0 && aring.y < 100.0 + m*150.0){
		col.rgb = vec3(m, 0.0, 1.0);
		col.a = 1.0;
	}
	vec2 cdiff = playerPos - px;
	float cdist = length(cdiff);
	float ringAmp = smoothstep(0.5, 1.0, audioData[0]);
	float ring = max(0.0, (1.0 - cdist/(200.0+200.0*ringAmp)));
	if(aring.y < 100.0){
		ringAmp = 0.0;
	}
	col.rgb += playerColor * ring * ringAmp;
	
	float starAmp = (0.0+smoothstep(0.05, 0.5, min(audioData[12], audioData[16])));
	
	vec2 starPos = suvx - 2.0*(1.0+sin(suvx.yx*50.0));
	starPos += 2.0;
	float d = -3.0 + 30.0 * starAmp;
	float star = smoothstep(1.0, 0.5, abs(0.2-min(1.0, max(d - starPos.x, max(d - (sres.x-starPos.x), max(d - starPos.y, d - (sres.y-starPos.y)))))));
	
	col.rgb += vec3(0.3+starAmp, 0.0, 0.6) * 0.5 * star;

	col.rgb = vec3(0.0, 0.0, 0.5);
	
	COLOR.rgb = mix(col.rgb, baseCol.rgb, baseCol.a);

	//COLOR.rgb = baseCol.rgb;
}
