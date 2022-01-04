#ifdef GL_ES
precision highp float;
precision highp int;
#endif

varying vec2 vUV;

uniform float time;
uniform float colorFactor;
uniform vec2 scaleFactor;
uniform sampler2D textureColor;
uniform sampler2D textureColorBlur;

float rand(vec2 n) {
    return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
    float total = 0.0, amplitude = 1.0;
    for (int i = 0; i < 3; i++) {
        total += noise(n) * amplitude;
        n += n;
        amplitude *= 0.65;
    }
    return total;
}

void main() {
    float t = time * 0.005;
    vec2 uv0 = vUV*scaleFactor;
    vec2 uv = vUV*scaleFactor;
    const vec3 c1 = vec3(0.8, 0.95, 0.7);
    const vec3 c2 = vec3(0.7, 0.75, 0.60);
    const vec3 c3 = vec3(0.5, 0.5, 0.2);
    const vec3 c4 = vec3(1.0, 1.0, 0.5);
    const vec3 c5 = vec3(0.9);
    const vec3 c6 = vec3(1.0);
    vec2 p = uv.xy * 2.0;

    float q = fbm(vec2(p - sin(t * 0.01)));
    vec2 r = vec2(fbm(p + q + t * 0.05 - p.x - p.y), fbm(p + q + sin(t*0.01)));
    vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
    vec4 fire = vec4(c, c.b);

    vec4 color1 = texture2D( textureColorBlur, uv0 + fire.rg * 0.1 );
    vec4 color = texture2D( textureColor, uv0 - color1.rg * 0.1) /*+ vec4(fire.rgb, 0.0)*/;
    vec4 temp = pow(color, vec4(colorFactor)) * pow(color1, vec4(colorFactor));

    gl_FragColor = temp;
}
