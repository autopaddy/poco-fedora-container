FROM fedora:35

# Increase parallel downloads for dnf
RUN echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf

# Install Git
RUN dnf update -y && dnf install -y git

# Install GNU build tools
RUN dnf group install -y "C Development Tools and Libraries"

# Install build utils (required during poco build bash scripts)
RUN dnf install -y hostname findutils

# Install Poco dependencies
RUN dnf install -y openssl-devel mysql-devel libiodbc-devel unixODBC-devel postgresql-devel

# Install Poco Libraries
ARG __POCO_CHECKOUT_DIR__=/poco
ARG __POCO_VERSION__=1.11.1
ARG __POCO_EXTENDED__=-all
ARG __POGO_CONF_FLAGS__="--no-tests --no-samples --everything --include-path=/usr/include --library-path=/usr/lib64"

RUN curl https://pocoproject.org/releases/poco-${__POCO_VERSION__}/poco-${__POCO_VERSION__}${__POCO_EXTENDED__}.tar.gz -o ${__POCO_CHECKOUT_DIR__}.tar.gz
RUN tar xzf ${__POCO_CHECKOUT_DIR__}.tar.gz \
    && cd poco-${__POCO_VERSION__}${__POCO_EXTENDED__} \
    && ./configure ${__POCO_CONF_FLAGS__} \
    && gmake -s -j$(nproc) \
    && gmake -s install
