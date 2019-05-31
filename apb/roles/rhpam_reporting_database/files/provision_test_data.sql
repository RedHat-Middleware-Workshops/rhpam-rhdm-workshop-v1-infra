-- Define random functions
DROP FUNCTION IF EXISTS randomRangePicker(integer, integer);

CREATE FUNCTION randomRangePicker(minRange integer, maxRange integer) RETURNS integer
AS $$
DECLARE pick INT;
BEGIN
  pick := minRange + FLOOR(RANDOM() * (maxRange - minRange + 1));
  RETURN pick;
END;$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS randomDate(timestamp, timestamp);

CREATE FUNCTION randomDate(minDate timestamp, maxDate timestamp) RETURNS timestamp
AS $$
DECLARE randomDate timestamp;
BEGIN
  randomDate := minDate + random() * (maxDate - minDate);
  RETURN randomDate;

END;$$ LANGUAGE plpgsql;


-- Customer Satisfaction Table Mocks
DROP FUNCTION IF EXISTS generate_customer_satisfaction_mocks(integer);

CREATE FUNCTION generate_customer_satisfaction_mocks(records integer) RETURNS void
AS $$
DECLARE counter integer;

DECLARE customer_id varchar(255);
DECLARE case_id varchar(255);
DECLARE satisfaction_score integer;
DECLARE remark varchar(255);
DECLARE remark_code integer;
DECLARE phone_number varchar(255);
BEGIN
  counter := 0;

  WHILE (counter < records) LOOP
    counter := counter + 1;

    customer_id := 'customer_' || randomrangepicker(100000, 999999);
    case_id := 'case_' || randomrangepicker(100000,999999);
    satisfaction_score := randomrangepicker(70, 100);
    phone_number := '555-' || randomrangepicker(1000, 9999);

    -- Set the 'remark' text using a CASE construct.
    remark_code := randomrangepicker(1, 10);

    CASE
      WHEN remark_code <= 2 THEN
        remark := 'Awesome service.';
      WHEN remark_code > 2 AND remark_code <= 5 THEN
        remark := 'Took a long time to get dispute resolved.';
      WHEN remark_code > 5 AND remark_code <= 10 THEN
        remark := 'Helpdesk person could not find my details.';
      ELSE
        remark := 'N/a';
    END CASE;

    INSERT INTO customer_satisfaction (customerid, caseid, satisfactionscore, remark, phonenumber)
      VALUES (customer_id, case_id, satisfaction_score, remark, phone_number);
  END LOOP;
END;$$ LANGUAGE plpgsql;

DELETE FROM customer_satisfaction;

SELECT generate_customer_satisfaction_mocks(15000);

-- Task Table Mocks
DROP FUNCTION IF EXISTS generate_task_mocks(integer);

CREATE FUNCTION generate_task_mocks(records integer) RETURNS void
AS $$
DECLARE counter integer;

DECLARE process_id varchar(255);
DECLARE name varchar(255);
DECLARE created_on timestamp;
DECLARE deployment_id varchar(255);
DECLARE description varchar(255);
DECLARE due_date timestamp;
DECLARE status taskstatus;
DECLARE last_modification_date timestamp;
DECLARE created_by varchar(255);
DECLARE actual_owner varchar(255);
DECLARE activation_time timestamp;

DECLARE status_code integer;
DECLARE actual_owner_code integer;
BEGIN
  counter := 0;

  WHILE (counter < records) LOOP
    counter := counter + 1;

    process_id := 'process_' || randomrangepicker(100000, 999999);
    name := 'task_' || randomrangepicker(100000,999999);
    created_on := randomDate(timestamp '2014-01-01 00:00:00', timestamp '2018-12-31 23:59:59');
    deployment_id := 'deployment_' || randomrangepicker(100000, 999999);
    description := 'Credit card dispute';
    due_date := created_on + interval '2 day';
    -- Can be 'created, 'active' or 'resolved'
    status_code := randomrangepicker(1,3);
    CASE
      WHEN status_code <= 1 THEN
        status := 'created';
      WHEN status_code > 1 AND status_code <= 2 THEN
        status := 'active';
      WHEN status_code > 2 AND status_code <= 3 THEN
        status := 'resolved';
      ELSE
        status := 'created';
    END CASE;

    -- Set the 'remark' text using a CASE construct.
    last_modification_date := created_on + interval '1 day';
    created_by := 'customer_' || randomrangepicker(100000, 999999);

    actual_owner_code := randomrangepicker(1, 4);
    CASE
      WHEN actual_owner_code <= 1 THEN
        actual_owner := 'John';
      WHEN actual_owner_code > 1 AND actual_owner_code <= 2 THEN
        actual_owner := 'Paul';
      WHEN actual_owner_code > 2 AND actual_owner_code <= 3 THEN
        actual_owner := 'George';
      WHEN actual_owner_code > 3 AND actual_owner_code <= 4 THEN
        actual_owner := 'Ringo';
      ELSE
        actual_owner := 'John';
    END CASE;


    activation_time := created_on + interval '4 hour';

    INSERT INTO task (processid, name, createdon, deploymentid, description, duedate, status, lastmodificationdate, createdby, actualowner, activationtime)
      VALUES (process_id, name, created_on, deployment_id, description, due_date, status, last_modification_date, created_by, actual_owner, activation_time);
  END LOOP;
END;$$ LANGUAGE plpgsql;

DELETE FROM task;

SELECT generate_task_mocks(15000);
