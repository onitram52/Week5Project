INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Steve',
	'Buschemi'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Todd',
	'Rundgren'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'James',
	'Yancey'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Piero',
	'Umiliani'
);

SELECT *
FROM "Customer"

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Ford',
	'Escape',
	'2008',
	'12000.00',
	'Blue',
	False,
	'12345'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Subaru',
	'Outback',
	'2000',
	'3200.00',
	'Green',
	False,
	'12346'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Kia',
	'Sorento',
	'2023',
	'31000.00',
	'Silver',
	True,
	'12347'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Lincoln',
	'Contintental',
	'1978',
	'40000.00',
	'White',
	False,
	'12348'
);

SELECT *
FROM "Cars"
WHERE "price" > '10000';

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Ryuichi',
	'Sakamoto'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Ryo',
	'Fukui'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Hiroshi',
	'Sato'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Yuji',
	'Ohno'
);

SELECT *
FROM "Salesperson"

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'James',
	'Taylor'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Jeff',
	'Foxworthy'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Niel',
	'Diamond'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Gilbert',
	'Gottfried'
);

SELECT *
FROM "Mechanic";

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	200.00,
	'Tire Replacement',
	'12345'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	100.00,
	'Oil Change',
	'12346'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	150.00,
	'Tire Rotation',
	'12347'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	220.00,
	'Break Replacement',
	'12348'
);

SELECT *
FROM "Service"

CREATE OR REPLACE FUNCTION add_customer(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR)
RETURNS TABLE(
	customer_id INTEGER,
	first_name VARCHAR,
	last_name VARCHAR
)
AS $MAIN$
BEGIN
	INSERT INTO "Customer"
	VALUES(_customer_id, _first_name, _last_name);
	RETURN QUERY SELECT *
	FROM "Customer"
	WHERE "Customer".customer_id = _customer_id;
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_customer(9, 'Jason', 'Bourne');

--Still need to do invoices and add is_serviced boolean to cars, and create a procedure to update said boolean

CREATE OR REPLACE FUNCTION add_invoice(invoice_id INTEGER, car_cost NUMERIC, service_cost NUMERIC, payment_type VARCHAR, VIN_no VARCHAR, customer_id INTEGER, car_id INTEGER, sales_person_id INTEGER)
RETURNS void
AS $$
BEGIN
	INSERT INTO "Invoice"
	VALUES(invoice_id, car_cost, service_cost, payment_type, VIN_no, customer_id, car_id, sales_person_id);
END;
$$
LANGUAGE plpgsql;

SELECT add_invoice('2', 0.00, 200.00, 'Cash', '12347', '2', '2', '2');

SELECT add_invoice('3', 40000.00, 0.00, 'Check', '12348', '3', '3', '3');

SELECT add_invoice('4', 12000.00, 0.00, 'Credit', '12345', '4', '1', '1');

SELECT *
FROM "Invoice";

ALTER TABLE "Cars"
ADD COLUMN is_serviced BOOLEAN;

CREATE OR REPLACE PROCEDURE is_serviced()
	LANGUAGE plpgsql
	AS $$
	BEGIN
		
		UPDATE "Cars"
		SET is_serviced = true
		WHERE car_id IN(
			SELECT car_id
			FROM "Invoice"
			GROUP BY "Invoice".car_id, "Invoice".service_cost
			HAVING "Invoice".service_cost > 0);
			
		UPDATE "Cars"
		SET is_serviced = false
		WHERE car_id IN(
			SELECT car_id
			FROM "Invoice"
			GROUP BY "Invoice".car_id, "Invoice".service_cost
			HAVING "Invoice".service_cost <= 0);
			
			COMMIT;
		END;
	$$

CALL is_serviced();

SELECT *
FROM "Cars";

SELECT add_invoice('6', 0.00, 200.00, 'Credit', '12345', '4', '4', '1');

CALL is_serviced();

SELECT *
FROM "Cars"
