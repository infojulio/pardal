# language: pt
Funcionalidade: Usuário deve poder se increver no site

  Cenario: Acessar tela de registro de usuário
    Dado que eu esteja na página de login
    Quando eu clicar em "Registrar Usuário para acessar o sistema"
    Então eu deveria ver "Número de Matrícula"
    E deveria ver "Número de Identidade (RG/RNE)"
    E deveria ver "E-mail"
