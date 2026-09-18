shader_type canvas_item;

// Captura tudo o que está renderizado atrás do ColorRect
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Parâmetros de customização (Painel Inspector)
uniform float sepia_amount : hint_range(0.0, 1.0) = 0.85;
uniform float grain_amount : hint_range(0.0, 0.3) = 0.05;
uniform float flicker_speed : hint_range(0.0, 50.0) = 25.0;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.4;

// Novos controles para os riscos e sujeira
uniform float scratch_amount : hint_range(0.0, 1.0) = 0.3; // Quantidade/Frequência de riscos
uniform float scratch_speed : hint_range(0.0, 10.0) = 4.0; // Velocidade com que mudam de posição

// Função para gerar ruído pseudo-aleatório
float pseudo_noise(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // 1. Pega a cor e o alfa originais da tela
    vec4 original_pixel = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 mixed_color = original_pixel.rgb;
    
    // 2. Efeito Sépia / Preto e Branco
    float gray = dot(mixed_color, vec3(0.299, 0.587, 0.114));
    vec3 sepia_color = vec3(gray) * vec3(1.2, 1.0, 0.8);
    mixed_color = mix(mixed_color, sepia_color, sepia_amount);
    
    // 3. Granulação de película (Noise)
    float noise = pseudo_noise(SCREEN_UV * TIME);
    mixed_color += (noise - 0.5) * grain_amount;
    
    // 4. Riscos Verticais de Filme Antigo (Scratches)
    // Criamos colunas verticais que mudam de posição de acordo com o tempo trincado
    float time_step = floor(TIME * scratch_speed);
    float scratch_x = pseudo_noise(vec2(time_step, 13.0));
    
    // Distância do pixel atual para a linha do risco vertical sorteada
    float dist_to_scratch = abs(SCREEN_UV.x - scratch_x);
    
    // Se estiver muito perto da linha e passar no teste de probabilidade, desenha o risco
    if (dist_to_scratch < 0.0015 && pseudo_noise(vec2(time_step, 45.0)) < scratch_amount) {
        // Gera falhas verticais no risco para ele não ser uma linha reta perfeita de cima a baixo
        float scratch_fade = pseudo_noise(vec2(SCREEN_UV.y * 5.0, time_step));
        if (scratch_fade > 0.2) {
            mixed_color *= 0.4; // Escurece o pixel para simular o risco na película
        }
    }
    
    // 5. Oscilação rápida da luz do projetor
    float flicker = sin(TIME * flicker_speed) * 0.03 + 0.97;
    mixed_color *= flicker;
    
    // 6. Vinheta (bordas escuras)
    vec2 uv = SCREEN_UV - 0.5;
    float vignette = 1.0 - dot(uv, uv) * vignette_intensity;
    mixed_color *= clamp(vignette, 0.0, 1.0);
    
    COLOR = vec4(mixed_color, original_pixel.a);
}
