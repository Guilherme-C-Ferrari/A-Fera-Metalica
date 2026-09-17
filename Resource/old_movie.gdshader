shader_type canvas_item;

// Textura do jogo que está atrás
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Sua spritesheet com o vídeo de filme antigo convertido
uniform sampler2D textura_filme_antigo : filter_linear_mipmap;

// Configuração da animação da spritesheet
uniform int total_de_frames = 16;
uniform float velocidade_fps = 14.0;

void fragment() {
    // 1. Pega a cor do seu jogo
    vec4 cor_jogo = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // 2. Lógica para animar os frames da Spritesheet automaticamente
    float frame_atual = floor(mod(TIME * velocidade_fps, float(total_de_frames)));
    
    // Ajusta o UV para ler apenas o frame correto da folha de animação (Exemplo vertical)
    vec2 uv_animado = SCREEN_UV;
    uv_animado.y = (uv_animado.y + frame_atual) / float(total_de_frames);
    
    // Se a sua spritesheet for horizontal, use a linha abaixo no lugar da anterior:
    // uv_animado.x = (uv_animado.x + frame_atual) / float(total_de_frames);

    // 3. Pega a cor do efeito de filme antigo
    vec4 cor_efeito = texture(textura_filme_antigo, uv_animado);

    // 4. MODO DE MISTURA (Escolha UM dos dois abaixo apagando as barras '//'):
    
    // OPÇÃO A: Modo "Screen" (Ideal se o fundo do seu vídeo for PRETO)
    // Ele mantém o que é claro (os riscos brancos/poeira) e some com o fundo preto.
    vec3 resultado = 1.0 - ((1.0 - cor_jogo.rgb) * (1.0 - cor_efeito.rgb));
    
    // OPÇÃO B: Modo "Multiply" (Ideal se o fundo do seu vídeo for BRANCO)
    // Ele mantém os riscos escuros e some com o fundo branco.
    // vec3 resultado = cor_jogo.rgb * cor_efeito.rgb;

    // Retorna o resultado final mantendo o alfa original do seu jogo
    COLOR = vec4(resultado, cor_jogo.a);
}
