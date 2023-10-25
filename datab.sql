create database GraphQl;

use GraphQl;

create table departmentDeliverables (
deliveryId int primary key,
deliveryDescription varchar(200)
);

//insertion
select * from departmentDeliverables
departmentDeliverablesINSERT INTO departmentDeliverables (deliveryId, deliveryDescription)
values (123, "Lecture Style");
DROP TABLE kpis;
create table KPIs (
kpiId int,
kpiDescription varchar(200),
objId int,
    PRIMARY KEY (kpiId),
    FOREIGN KEY (deliveryId) REFERENCES departmentDeliverables(deliveryId)
);

CREATE TABLE staff(
empID INT,
empPassword VARCHAR(50),
empName VARCHAR (50),
departmentSupervisor INT
);
INSERT INTO staff
VALUES(1238,'flah777','kahewa brinkmann',0);
     

CREATE TABLE KPI(
KpiName VARCHAR(100),
Metric VARCHAR(20),
KpiScore INT,
Grade INT,
ApprovalStatus VARCHAR(5),
empID INT
);
INSERT INTO KPI
VALUES
      ('lecture','percentage',70,2,'no',2233);

CREATE TABLE departmentSupervisor(
SuperID INT,
SuperPassword VARCHAR (50),
SuperVName   VARCHAR(100)

);

CREATE TABLE headOfDepartment(
headID INT PRIMARY KEY,
headPassword VARCHAR (50),
headName VARCHAR(50)

);

INSERT INTO headOfDepartment (headID,headPassword,headName)
VALUES (777000,'qwerty','grace shuuya');

SELECT * FROM headOfDepartment;
select * from departmentDeliverables;
select * from departmentSupervisor;
select * from headOfDepartment;
select * from KPI;
select * from staff;
INSERT INTO departmentSupervisor (`supsID`, `supsPassword`, `supsName`) VALUES ('273', 'qwerty', 'martin');
  UPDATE SUPERVISIOR
      SET  empID = 1238,
       supsGrade = 5
      WHERE supsID = 273;
UPDATE KPI SET 
           KpiName ="hg",
           Metric ="percentage",
           KpiScore =75
           WHERE empID = 1238
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

UPDATE KPI
SET KpiName ="hg",  Metric ="percentage",  KpiScore =75
WHERE empID = 1238 

Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  
To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.