CREATE TABLE "Salesperson" (
  "sales_person_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Mechanic" (
  "mechanic_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Customer" (
  "customer_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Invoice" (
  "invoice_id" SERIAL PRIMARY KEY,
  "car_cost" NUMERIC(10,2),
  "service_cost" NUMERIC(10,2),
  "payment_type" VARCHAR(100),
  "VIN_no" VARCHAR(100),
  "customer_id" INTEGER,
  "car_id" INTEGER,
  "sales_person_id" INTEGER,
	FOREIGN KEY("customer_id") REFERENCES "Customer",
	FOREIGN KEY ("car_id") REFERENCES "Cars",
	FOREIGN KEY ("sales_person_id") REFERENCES "Salesperson"
);

CREATE TABLE "Cars" (
  "car_id" SERIAL PRIMARY KEY,
  "make" VARCHAR(100),
  "model" VARCHAR(100),
  "year" INTEGER,
  "price" NUMERIC (10,2),
  "color" VARCHAR(100),
  "is_new" BOOLEAN,
  "VIN_no" VARCHAR(100)
);

CREATE TABLE "Service" (
  "service_id" SERIAL PRIMARY KEY,
  "service_cost" NUMERIC(10,2),
  "service_type" VARCHAR(100),
  "VIN_no" VARCHAR(100),
  "mechanic_id" INTEGER,
  "invoice_id" INTEGER,
	FOREIGN KEY ("mechanic_id") REFERENCES "Mechanic",
	FOREIGN KEY ("invoice_id") REFERENCES "Invoice"
);

SELECT *
FROM "Invoice"
