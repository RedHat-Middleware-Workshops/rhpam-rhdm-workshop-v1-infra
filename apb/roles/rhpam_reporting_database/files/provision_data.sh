#!/bin/sh
# Export the password so psql does not prompt for it.
export PGPASSWORD=$POSTGRESQL_PASSWORD
# Create tables if they do not exist

DATABASE=postgres

echo "Provisioning database with demo data."
echo "Creating tables"

psql -h $POSTGRESQL_HOSTNAME -U $POSTGRESQL_USER -w -d $DATABASE --command \
  "CREATE TYPE taskstatus AS ENUM ('created', 'active', 'resolved'); \
   CREATE TABLE IF NOT EXISTS \
    public.task(id SERIAL PRIMARY KEY, \
                  processid character varying(255), \
                  name character varying(255), \
                  createdon timestamp without time zone, \
                  deploymentid character varying(255), \
                  description character varying(255), \
                  duedate timestamp without time zone, \
                  status taskstatus, \
                  lastmodificationdate timestamp without time zone, \
                  createdby character varying(255), \
                  actualowner character varying(255), \
                  activationtime timestamp without time zone) \
    WITH (OIDS=FALSE); \
  ALTER TABLE public.task OWNER TO \"$POSTGRESQL_USER\";"

psql -h $POSTGRESQL_HOSTNAME -U $POSTGRESQL_USER -w -d $DATABASE --command \
  "CREATE TABLE IF NOT EXISTS \
    public.customer_satisfaction(id SERIAL PRIMARY KEY, \
                                customerid character varying(255), \
                                caseid character varying(255), \
                                satisfactionscore integer, \
                                remark character varying(255), \
                                phonenumber character varying(255)) \
    WITH (OIDS=FALSE); \
  ALTER TABLE public.customer_satisfaction OWNER TO \"$POSTGRESQL_USER\";"

echo "Provision test data"
psql -h $POSTGRESQL_HOSTNAME -U $POSTGRESQL_USER -w -d $DATABASE -f /tmp/config-files/provision_test_data.sql
