FROM ubuntu
 
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
 
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.lis
 
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-10 
 
USER postgres
 
RUN psql --command "CREATE USER postgresondocker WITH SUPERUSER PASSWORD 'postgresondocker';" &&\
    createdb -O postgresondocker postgresondocker
 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf
 
# And add ``listen_addresses`` to ``/etc/postgresql/10/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf
 
# Expose the PostgreSQL port
EXPOSE 5432
 
# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
 
# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/10/bin/postgres", "-D", "/var/lib/postgresql/10/main", "-c", "config_file=/etc/postgresql/10/main/postgresql.conf"]
