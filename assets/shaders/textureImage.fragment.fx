precision highp float;

// Samplers
varying vec2 vUV;
uniform sampler2D textureSampler;
uniform sampler2D customTextureSampler;

// Parameters
uniform vec2 bottomLeft, topRight;
uniform float width, height;
uniform vec4 backgroundColor;

vec3 mask = normalize(vec3(0.2, 0.4, 0.8));

float insideBox(vec2 v) {
    vec2 s = step(bottomLeft, v) - step(topRight, v);
    return s.x * s.y;
}

void main(void)
{
    float x = (vUV.x - bottomLeft.x) / width;
    float y = ((vUV.y - topRight.y) / height) + 1.0;

    vec4 orgPixel = texture2D(textureSampler, vUV);
    if(dot(normalize(orgPixel.xyz * insideBox(vUV)), mask) > 0.99){
        vec4 pixel = texture2D(customTextureSampler, vec2(x, y));
        gl_FragColor = pixel + backgroundColor * (1.0 - pixel.w);
    } else {
        gl_FragColor = orgPixel;
    }
}