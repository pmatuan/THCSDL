-----------------------------------------------------------------------------------------------------------------------
--#                                                           Function                                                                                 #
-----------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------
--#                                                              Patient View                                                                        #
-----------------------------------------------------------------------------------------------------------------------
--find patient follow all name
create or replace function FindPatientFollowName(_Name character varying)
returns table (pid character varying, patient_name character varying, gender character varying, dob date, phone integer, insurance character varying, email character varying, address character varying)
as
$func$
begin
	return query
	select pa.*
	from patient as pa
	where pa.patient_name = _Name;
end
$func$ language plpgsql;

--select * from FindPatientFollowName('Nguyen Van Chang');
---------------------------------------------------------------------------------------------------------------------
--find all patient follow a part of name
create or replace function FindPatientFollowPartName(_Name character varying)
returns table (pid character varying, patient_name character varying, gender character varying, dob date, phone integer, insurance character varying, email character varying, address character varying)
as
$func$
begin
	return query
	select pa.*
	from patient as pa
	where pa.patient_name like _Name;
end
$func$ language plpgsql;

--select * from FindPatientFollowPartName('%Nguyen%');
---------------------------------------------------------------------------------------------------------------------
--find all final result from all time patient visited follow pid
create or replace function ReturnFinalResultFollowPid(_pid character varying)
returns table (visit_id character varying, did character varying, final_result character varying, final_diagnosis character varying, final_drug character varying, advice character varying)
as
$func$
begin
	return query
	select f.visit_id, f.did, f.final_result, f.final_diagnosis, f.final_drug, f.advice
	from final_form as f
	where f.visit_id in (
		select v.visit_id
		from visit as v
		where (v.pid = _pid)
	);
end
$func$ language plpgsql;

select * from ReturnFinalResultFollowPid('DHBKHN1');

----------------------------------------------------------------------------------------------------------------------
create or replace function ReturnFinalResultFollowPid(_pid character varying)
returns table (visit_id character varying, did character varying, final_result character varying, final_diagnosis character varying, final_drug character varying, advice character varying)
as
$func$
begin
	return query
	select f.visit_id, f.did, f.final_result, f.final_diagnosis, f.final_drug, f.advice
	from final_form as f
	join visit as v
	on (f.visit_id = v.visit_id)
	where v.pid = _pid;
end
$func$ language plpgsql;

select * from ReturnFinalResultFollowPid('DHBKHN1');
------------------------------------------------------------------------------------------------------------------------
--function to return all bill of a patient
create or replace function ReturnBill(_pid character varying)
returns table (visit_id character varying, total_cost integer, discount integer, loan integer, service_fee integer, drug_fee integer)
as
$func$
begin
	return query
	select b.visit_id, b.total_cost, b.discount, b.loan, b.service_fee, b.drug_fee
	from bill as b
	join visit as v
	on (b.visit_id=v.visit_id)
	where v.pid = _pid;
end
$func$ language plpgsql;

--select * from ReturnBill('DHBKHN1');
-------------------------------------------------------------------------------------------------------------------
--process of a service
create or replace function ReturnResultService(_pid character varying, _serviceID character varying)
returns table(did character varying, visit_id character varying, pack_id character varying, test_result character varying, diagnosis character varying)
as
$func$
begin
	return query
	select te.did, te.visit_id, te.pack_id, te.test_result, te.diagnosis
	from test as te
	join visit as v
	on (te.visit_id = v.visit_id)
	where (v.pid = _pid and te.service_id = _serviceID);
end
$func$ language plpgsql;

--select * from ReturnResultService('DHBKHN1', 'TM2');
--------------------------------------------------------------------------------------------------------------------
--#                                                              Doctor View                                                                   #
--------------------------------------------------------------------------------------------------------------------
--find all patient doctor’ ve tested follow did
create or replace function FindAllPatientFollowDid(_did character varying)
returns table (pid character varying, patient_name character varying, gender character varying, dob date, insurance character varying)
as
$func$
begin
	return query
	select pa.pid, pa.patient_name, pa.gender, pa.dob, pa.insurance
	from patient as pa
	where pa.pid in(
		select v.pid
		from visit as v
		where v.visit_id in (
			select pack.visit_id
			from package as pack
			where (pack.visit_id, pack.pack_id) in (
				select s.visit_id, s.pack_id
				from service as s
				where (s.visit_id, s.pack_id, s.service_id) in (
					select te.visit_id, te.pack_id, te.service_id
					from test as te
					where te.did = _did
				)
			)
		)
	);
end
$func$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------
--find all patient in a day
create or replace function FindAllPatientFollowDate(_input_date date)
returns table (visit_id character varying, pid character varying, patient_name character varying, gender character varying, dob date, phone int, insurance character varying, email character varying, address character varying)
as
$func$
begin
	return query
	select v.visit_id, pa.pid, pa.patient_name, pa.gender, pa.dob, pa.phone, pa.insurance, pa.email, pa.address
	from visit as v
	join patient as pa
	on (v.pid = pa.pid)
	where v.visit_date = _input_date;
end
$func$ language plpgsql;

select * from FindAllPatientFollowDate('2020-06-16');
------------------------------------------------------------------------------------------------------------------------
--#                                                             System View                                                                          #
------------------------------------------------------------------------------------------------------------------------
--compute loan in a day
create or replace function SumOfLoanDay(_input_date date)
returns table (total_loan bigint)
as
$func$
begin
	return query
	select sum(b.loan)
	from visit as v
	join bill as b
	on (v.visit_id=b.visit_id)
	where v.visit_date = _input_date;
end
$func$ language plpgsql;

select * from SumOfLoanDay('2020-06-16');
------------------------------------------------------------------------------------------------------------------------
--compute drug_fee
create or replace function ComputeDrugFee(_pid character varying)
returns table (visit_id character varying, drug_fee bigint)
as
$func$
begin
	return query
	select d.visit_id, sum(d.price)
	from drug as d
	join visit as v
	on (d.visit_id = v.visit_id)
	where v.pid = _pid
	group by (d.visit_id);
end
$func$ language plpgsql;

--select ComputeDrugFee('DHBKHN1');
------------------------------------------------------------------------------------------------------------------------
--compute service fee
create or replace function ComputeServiceFee(_pid character varying)
returns table (visit_id character varying, service_fee bigint)
as
$func$
begin
	return query
	select s.visit_id, sum(s.price)
	from service as s
	join visit as v
	on (s.visit_id = v.visit_id)
	where v.pid = _pid
	group by (s.visit_id);
end
$func$ language plpgsql;

--select ComputeServiceFee('DHBKHN1');
------------------------------------------------------------------------------------------------------------------------
--update total cost
update bill set total_cost = service_fee + drug_fee
where (bill.visit_id in (select visit_id
				  from visit
				  where visit.pid = 'DHBKHN1'));

--update discount
update bill set discount = 0.5*total_cost
where (bill.visit_id in (select visit_id
						from visit
						where visit.pid in (select pid
										   from patient
										   where patient.pid = 'DHBKHN1' and patient.insurance = 'Y')));

--update loan
update bill set loan = total_cost - discount
where (bill.visit_id in (select visit_id
						from visit
						where visit.pid = 'DHBKHN1'));
------------------------------------------------------------------------------------------------------------------------
