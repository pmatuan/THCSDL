-- create patient
create table patient(
	pid	   varchar(50) not null unique,
	patient_name varchar(50),
	gender varchar(1) check (gender = 'M' or gender = 'F'),
	dob  Date,
	phone int, 
	insurance varchar(1) check (insurance = 'Y' or insurance = 'N'),
	email varchar(50),
	address varchar(50),
	primary key (pid)
);

-- create location
create table test_location(
	service_id varchar(50) not null unique,
	room_id varchar(50),
	building varchar(50),
	primary key (service_id)
);

-- create doctor
create table doctor(
	did varchar(50) NOT NULL unique,
	service_id varchar(50) not null,
	doctor_name varchar(50),
	specialization varchar(50),
	primary key (did),
	foreign key (service_id) references test_location(service_id)
);

-- create training
create table training(
	did varchar(50) not null,
	certificate varchar(50),
	certification_date Date,
	certification_expire Date,
	primary key(did),
	foreign key (did) references doctor(did)
);

-- create visit
create table visit(
	pid varchar(50) not null,
	visit_id varchar(50) not null unique,
	symptom varchar(200),
	visit_date Date,
	primary key(visit_id),
	foreign key (pid) references patient(pid)
);

-- create feedback
create table feedback(
	visit_id varchar(50) not null,
	attitude varchar(200),
	equiment varchar(200),
	test_time varchar(200),
	price varchar(200),
	other varchar(200),
	primary key(visit_id),
	foreign key (visit_id) references visit(visit_id)
);

--create bill
create table bill(
	visit_id varchar(50) not null,
	total_cost int, 
	discount int default 0, 
	loan int,
	service_fee int,
	drug_fee int,
	primary key (visit_id),
	foreign key (visit_id) references visit(visit_id)
);

--create final form
create table final_form(
	did varchar(50) not null,
	visit_id varchar(50) not null,
	final_result varchar(200),
	final_diagnosis varchar(200),
	final_drug varchar(200),
	advice varchar(200),
	constraint pk_form primary key (did, visit_id),
	foreign key (did) references doctor(did),
	foreign key (visit_id) references visit(visit_id)
);

--create package
create table package(
	visit_id varchar(50) not null,
	pack_id varchar(50) not null, 
	package_name varchar(50),
	constraint pk_package primary key (visit_id, pack_id),
	foreign key (visit_id) references visit(visit_id)
);

--create service
create table service(
	visit_id varchar(50) not null,
	pack_id varchar(50) not null,
	service_id varchar(50) not null,
	service_name varchar(50),
	price int,
	constraint pk_service primary key (visit_id, pack_id, service_id),
	foreign key (visit_id, pack_id) references package(visit_id, pack_id) 
);

--create drug
create table drug(
	did varchar(50) not null,
	visit_id varchar(50) not null,
	pack_id varchar(50) not null,
	service_id varchar(50) not null,
	drug_name varchar(70),
	dose varchar(70),
	price int,
	constraint pk_drug primary key (did, visit_id, pack_id, service_id),
	foreign key (did) references doctor(did),
	foreign key (visit_id, pack_id, service_id) references service(visit_id, pack_id, service_id)
);

--create test
create table test(
	did varchar(50) not null,
	visit_id varchar(50) not null,
	pack_id varchar(50) not null,
	service_id varchar(50) not null,
	test_result varchar(200),
	diagnosis varchar(200),
	constraint pk_test primary key (did, visit_id, pack_id, service_id),
	foreign key (did) references doctor(did),
	foreign key (visit_id, pack_id, service_id) references service(visit_id, pack_id, service_id)
);