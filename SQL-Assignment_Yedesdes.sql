--1.0 Setting up Oracle Chinook
--In this section you will begin the process of working with the Oracle Chinook database
--Task – Open the Chinook_Oracle.sql file and execute the scripts within.

--2.0 SQL Queries
--In this section you will be performing various queries against the Oracle Chinook database.

--2.1 SELECT
--Task – Select all records from the Employee table.

SELECT * FROM Employee;

--Task – Select all records from the Employee table where last name is King.

SELECT * From Employee WHERE lastname = 'King;

--Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.

SELECT* From Employee WHERE FirstName ='Andrew' AND "REPORTSTO" IS NULL;
--2.2 ORDER BY
--Task – Select all albums in Album table and sort result set in descending order by title.

SELECT * FROM ALBUM ORDER BY ALBUM.TITLE DESC;

--Task – Select first name from Customer and sort result set in ascending order by city

SELECT FIRSTNAME FROM CUSTOMER ORDER BY CITY DESC;
--2.3 INSERT INTO
--Task – Insert two new records into Genre table

INSERT INTO GENRE (GENREID, NAME) VALUES (26, 'Romantic Comedy');
--Task – Insert two new records into Employee table

INSERT INTO Employee (EMPLOYEEID, FIRSTNAME, LASTNAME) VALUES (9, 'Walter', 'White');

INSERT INTO Employee (EMPLOYEEID, FIRSTNAME, LASTNAME) VALUES (10, 'Chuck', 'Norris');

--Task – Insert two new records into Customer table

Insert into customer(customerid,firstname,lastname,email,supportrepid) values(777777777,'MUDESSir','Yedesdes','yedesdes77@gmail.com',3)
Insert into customer(customerid,firstname,lastname,email,supportrepid) values(999999999,'Kedir','Hamdu','hassen31@gmail.com',5)

INSERT INTO CUSTOMER VALUES ( 60 , 'Yedesdes','Mudessir' ,REVATURE);

--2.4 UPDATE
--Task – Update Aaron Mitchell in Customer table to Robert Walter

update customer set firstname = 'Robert', lastname = 'Walter'

where firstname='Aaron' and lastname = 'Mitchell'

--Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
update artist set name = 'CCR' where name = 'Creedence Clearwater Revival'

--2.5 LIKE
--Task – Select all invoices with a billing address like “T%”

SELECT * FROM invoice where billingaddress like 'T%'

--2.6 BETWEEN
--Task – Select all invoices that have a total between 15 and 50

select * from invoice where total between 15 and 50

--Task – Select all employees hired between 1st of June 2003 and 1st of March 2004

select * from employee where hiredate between '01-JUN-03' and '01-MAR-04'


--2.7 DELETE
--Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them)

Delete from customer where firstname = 'Robert' and lastname = 'Walter';
--
--3.0 SQL Functions
--In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database


--3.1 System Defined Functions
--Task – Create a function that returns the current time.

create or replace function getSysdate
return date is l_sysdate date;
begin
 select sysdate into l_sysdate
from dual; return l_sysdate;

end;


--Task – create a function that returns the length of a mediatype from the mediatype table

CREATE OR REPLACE FUNCTION getLength (name Varchar2)
RETURN length as
    Begin
        Select * INTO Length;
        return Length;
        END;

--3.2 System Defined Aggregate Functions
--Task – Create a function that returns the average total of all invoices
 create or replace function INVOICELINE_TOTAL
  (invoice_id in number)
  return number
is

  tNumber number := 0;
  cursor t1 is

  select unitprice,quantity

    from invoiceline

    where invoiceid = invoice_id;

begin
  for invoice_rec in t1
  loop tNumber := invoice_rec.unitprice * invoice_rec.quantity + tNumber;

  end loop;
return tNumber;

end;

--Task – Create a function that returns the most expensive track

Create or replace function mostExpensiveTrack()
returns text as $$
begin

return (select name from track where unitprice = (select max(unitprice) from track));
 end;

$$ language plpgsql;
select mostExpensiveTrack();

--3.3 User Defined Scalar Functions
--Task – Create a function that returns the average price of invoiceline items in the invoiceline table

create or replace function averageInvoicePrice()

returns float as $$

begin

return (select avg(unitprice) from invoiceline);

 end;

$$ language plpgsql;



select averageInvoicePrice();

--3.4 User Defined Table Valued Functions
--Task – Create a function that returns all employees who are born after 1968.
SELECT * FROM EMPLOYEE WHERE BIRTHDATE > date '1968-01-01';
--4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
--4.1 Basic Stored Procedure
--Task – Create a stored procedure that selects the first and last names of all the employees.


--4.2 Stored Procedure Input Parameters
--Task – Create a stored procedure that updates the personal information of an employee.

CREATE OR REPLACE PROCEDURE employeeUpdate (updateLastName IN varchar2, updateFirstName IN varchar2,updateBirthDate IN date, 
                                            updateAddress IN varchar2, updateCity IN varchar2, updateState IN varchar2, 
                                            updateCounty IN varchar2, updateZip IN varchar2, updatePhone IN varchar2, 
                                            updatFax IN varchar2, updateEmail IN varchar2)
    as
    begin 
    insert into employee (lastname, firstname, birthdate, address, city, 
                        state, county, postalcode, phone, fax, email)
            
            VALUES(updateLastName, updateFirstName, updateBirthDate, updateAddress, updateCity, updateState, 
            updateCounty, updateZip, updatePhone, updatFax, updateEmail);
    
    end;
--Task – Create a stored procedure that returns the managers of an employee.

CREATE OR REPLACE PROCEDURE returnManager(employeeName in varchar2, manager OUT varchar2)
        is
        begin
        select reportsto from employee where name = employeeName;
        select name from employee where reportsto = employeeid;
        return name = manager;
        end;

--4.3 Stored Procedure Output Parameters

--Task – Create a stored procedure that returns the name and company of a customer.
create or replace function customerSearch(c_id int)

returns table (customer_fname varchar, customer_lname varchar, customer_company varchar) as $$

begin

	return query (select firstname, lastname, company from customer where customerid = c_id);

end;

$$ language plpgsql;



select * from customerSearch(10);


--6.0 Triggers
--In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.


--6.1 AFTER/FOR


--Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.

create trigger employee_insert

    after insert on employee

    for each row

    execute procedure example_function();


--Task – Create an after update trigger on the album table that fires after a row is inserted in the table

create trigger customer_update

    after update on customer

    for each row

    execute procedure example_function();


--Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
create trigger customer_delete

    after delete on customer

    for each row

    execute procedure example_function();


--Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.
create trigger customer delete

    ON Invoice table
    FOR DELETE
AS
    DELETE FROM Invoice table
    WHERE unitprice >= 50 AND ID IN(SELECT deleted.id FROM deleted)
GO

--7.0 JOINS
--In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.


--7.1 INNER
--Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.


select firstname, lastname, invoiceid from customer inner join invoice on customer.customerid = invoice.customerid;
--7.2 OUTER
--Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.

select customer.customerid, firstname, lastname, invoiceid, total from customer full outer join invoice on customer.customerid = invoice.customerid;

--7.3 RIGHT
--Task – Create a right join that joins album and artist specifying artist name and title.
select name, title from album right join artist on album.artistid = artist.artistid;


--7.4 CROSS
--Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.

select name as artist, title as album from artist 

cross join album where artist.artistid = album.artistid 

order by artist.name asc;

--7.5 SELF
--Task – Perform a self-join on the employee table, joining on the reportsto column.

select A.firstname as firstname, A.lastname as lastname, A.title, B.lastname as reportsto from employee A, employee B where A.reportsto = B.employeeid;
--
