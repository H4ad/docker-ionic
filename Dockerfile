#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM beevelop/ionic:v4.8.0

MAINTAINER Vinícius Lourenço

# Start as root
USER root

###########################################################################
# Ionic four non-root user:
###########################################################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

# always run apt update when start and after add new source list, then clean up at end.
RUN apt-get update -yqq && \
    groupadd -g ${PGID} ionic && \
    useradd -u ${PUID} -g ionic -m ionic && \
    usermod -p "*" ionic

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# ZSH
###########################################################################

RUN apt-get install -y zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

USER ionic

COPY install.sh /home/ionic/install.sh

RUN bash ~/install.sh && \
    rm ~/install.sh

###########################################################################
# End configs
###########################################################################

# Start as root
USER root

RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.0" \
    "platforms;android-27" \
    "platform-tools"

RUN apt-get update && \
    apt-get install -y usbutils

# Set default work directory
WORKDIR /var/www
