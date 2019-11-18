#!/bin/bash

# Esse é um shell script para facilitar o uso da imagem

# Para executar, tenha certeza que esse arquivo possui as permissões necessárias:
# chmod 755 docker-ionic.sh


# prints colored text
print_style () {

    if [ "$2" == "info" ] ; then
        COLOR="96m"
    elif [ "$2" == "success" ] ; then
        COLOR="92m"
    elif [ "$2" == "warning" ] ; then
        COLOR="93m"
    elif [ "$2" == "danger" ] ; then
        COLOR="91m"
    else #default color
        COLOR="0m"
    fi

    STARTCOLOR="\e[$COLOR"
    ENDCOLOR="\e[0m"

    printf "$STARTCOLOR%b$ENDCOLOR" "$1"
}

display_options () {
    printf "Opções disponiveis:\n";
    print_style "   install [version]" "success"; printf "\t\t\t\t Realiza a instalação de uma versão da imagem h4ad/ionic.\n"
    print_style "   create [version] [local of your projects]" "success"; printf "\t Cria um container com uma determinada versão da imagem h4ad/ionic.\n"
    print_style "   enter [version]" "info"; printf "\t\t\t\t Entra em um container previamente criado com a versão do Ionic entra dentro dele automaticamente.\n"
    print_style "   stop [version]" "info"; printf "\t\t\t\t Para um container que está sendo executado com uma versão da imagem h4ad/ionic.\n"
    print_style "   rm [version]" "danger"; printf "\t\t\t\t\t Remove um container com a versão do Ionic.\n"
    print_style "   clean" "danger"; printf "\t\t\t\t\t Remove todos os containers com as versões do Ionic.\n"
    print_style "   image rm [version]" "danger"; printf "\t\t\t\t Remove uma certa versão das imagens h4ad/ionic.\n"
}

if [[ $# -eq 0 ]] ; then
    print_style "\n\nNão há argumentos.\n\n" "danger"
    display_options
    exit 1
fi

if [ "$1" == "install" ] ; then
    print_style "Iniciando o download da imagem h4ad/ionic:$2\n" "info"
    docker pull h4ad/ionic:$2

elif [ "$1" == "create" ]; then
    print_style "A inicialização do container ( e download da image caso não tenha feito a instalação ) está começando.\n" "info"
    print_style "Após a inicialização, use o comando enter para entrar no container.\n" "info"
    docker run -itd --privileged --name ionic-$2 -p 5073:5073 -p 8000-8020:8000-8020 -p 35700-35720:35700-35720 -p 53700-53720:53700-53720 -v /dev/bus/usb:/deb/bus/usb -v $3:/var/www -w /var/www --user ionic h4ad/ionic:$2 zsh

elif [ "$1" == "enter" ]; then
    if [ "$2" == "3" ] ; then
        docker start -i ionic-v3.20.0
    elif [ "$2" == "4" ]; then
        docker start -i ionic-v4.8.0
    else
        docker start -i ionic-$2
    fi

elif [ "$1" == "stop" ]; then
    if [ "$2" == "3" ] ; then
        docker stop ionic-v3.20.0
    elif [ "$2" == "4" ]; then
        docker stop ionic-v4.8.0
    else
        docker stop ionic-$2
    fi

elif [ "$1" == "rm" ]; then
    if [ "$2" == "3" ] ; then
        docker rm ionic-v3.20.0
    elif [ "$2" == "4" ]; then
        docker rm ionic-v4.8.0
    else
        docker rm ionic-$2
    fi

elif [ "$1" == "clean" ]; then
    print_style "Removendo todas os containers com a imagem base h4ad/ionic." "info"
    docker rm $(docker ps -q -a -f name=ionic-v)

elif [ "$1" == "image" && $2 == "rm" ]; then
    print_style "Deletando a imagem h4ad/ionic:$3" "info"
    docker image rm h4ad/ionic:$3

else
    print_style "Argumentos inválidos\n" "danger"
    display_options
    exit 1
fi
