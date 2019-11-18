# Docker Ionic

Com este repositório, você consegue criar e gerenciar facilmente um container com Ionic.

# Uso

Para facilitar o uso diário desse container, baixe o arquivo chamado docker-ionic.sh, e o coloque em alguma pasta, e adicione o seguinte alias em ~/.bashrc ou ~/.zshrc:

~~~
alias dionic="cd {LOCAL_ONDE_ESTÁ_O_DOCKER-IONIC.SH} && bash docker-ionic.sh"
~~~

Dessa forma, basta digitar "dionic" no terminal que você conseguirá manipular as imagens de h4ad/ionic. 

# Para evitar problemas

Quando entrar na imagem pela primeira vez, execute os seguintes comandos para evitar problemas com licensa das imagens do android ao compilar o aplicativo:

~~~~
echo yes | $ANDROID_HOME/tools/bin/sdkmanager --update
yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses || true
~~~~

# ADB

Caso não esteja localizando seu celular ao usar "adb devices" dentro do docker, saia dele, e execute o comando:

~~~~
adb kill-server
~~~~

Após isso, volte e execute novamente "adb devices".

# Portas

Caso haja algum problema de portas ao executar "ionic-serve", vá no arquivo "docker-ionic.sh" e edite as portas para que fiquem no range correto.