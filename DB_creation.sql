-- CREATE A TABLE OF USERS WHERE CONTAINED FIRT NAME, LAST NAME, EMAIL AND AGE OF A PERSON
CREATE TABLE testing_table_1(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL,
	lastname VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	age INTEGER NOT NULL,
	phone_number VARCHAR(11)
);

-- CREATE A TABLE OF POSSIBLE WORKPLACES
CREATE TABLE workplaces(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	workplace_name VARCHAR(100) NOT NULL,
	salary INT NOT NULL
);

CREATE TABLE testing_table_2(
	id INT NOT NULL IDENTITY(1,2) PRIMARY KEY,
	users_id INT FOREIGN KEY REFERENCES testing_table_1(id),
	workplace_id INT FOREIGN KEY REFERENCES workplaces(id),
);

ALTER TABLE testing_table_2 ADD hours_per_week INT;


INSERT INTO testing_table_1 (firstname, lastname, email, age, phone_number) VALUES ('Alexander', 'Babaev', 'albabaev@mail.ru', 33, '89573958423');
INSERT INTO testing_table_1 (firstname, lastname, email, age, phone_number) VALUES ('Maxim', 'Lavrentev', 'malavrentev@mail.ru', 23, '89238765678');
INSERT INTO testing_table_1 (firstname, lastname, email, age, phone_number) VALUES ('John', 'Kirby', 'jokirby@mail.ru', 28, '89125672451');
INSERT INTO testing_table_1 (firstname, lastname, email, age, phone_number) VALUES ('Dmitry', 'Ivanov', 'dmivanov@mail.ru', 37, '89876544523');
INSERT INTO testing_table_1 (firstname, lastname, email, age, phone_number) VALUES ('Georgy', 'Chapoev', 'gechapoev@mail.ru', 43, '89587432456');

INSERT INTO workplaces (workplace_name, salary) VALUES ('QA', 3000);
INSERT INTO workplaces (workplace_name, salary) VALUES ('Junior Developer', 1700);
INSERT INTO workplaces (workplace_name, salary) VALUES ('Middle Developer', 3200);
INSERT INTO workplaces (workplace_name, salary) VALUES ('Senior Developer', 4500);
INSERT INTO workplaces (workplace_name, salary) VALUES ('Project Manager', 4000);

INSERT INTO testing_table_2 (users_id, workplace_id, hours_per_week) VALUES (1, 2, 30);
INSERT INTO testing_table_2 (users_id, workplace_id, hours_per_week) VALUES (2, 3, 40);
INSERT INTO testing_table_2 (users_id, workplace_id, hours_per_week) VALUES (3, 4, 20);
INSERT INTO testing_table_2 (users_id, workplace_id, hours_per_week) VALUES (4, 5, 30);
INSERT INTO testing_table_2 (users_id, workplace_id, hours_per_week) VALUES (5, 1, 40);