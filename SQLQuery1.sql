create database TARge25

--db valimine
use master

--db kustutamine
drop database TARge25

--tabeli tegemine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male'),
(1, 'Female'),
(3, 'Unknown')

--tabeli sisu vaatamine
select * from Gender

--tehke tabel nimega Person
--id int, not null, primary key
--Name nvarchar 30
--Email nvarchar 30
--GenderId int

create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'cat@cat.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--soovime näha Person tabeli sisu
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid aj ei ole sisestanud genderId alla väärtust, siis
--see automaatselt sisestab sellele reale väärtuse 3 e mis meil on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email, GenderId)
values (7, 'Flash', 'f@f.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Plack Panther', 'p@p.com')

select * from Person

--kustutada DF_Persons_GenderId piirang koodiga
alter table Person
drop constraint DF_Persons_GenderId

--lisamine koodiga veeru
alter table Person
add Age nvarchar(10)

--lisamine nr piirangu vanuse sisestamisel
alter table Person 
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kui sa tead veergude järjekorda peast, siis ei pea neid sisestama
insert into Person 
values (10, 'Green Arrow', 'g@g.com', 2, 154)

--constrainti kustutamine
alter table Person
drop constraint CK_Person_Age

alter table Person 
add constraint CK_Person_Age check (Age > 0 and Age < 130)

--kustutame rea
delete from Person where Id = 10

--kuidas uuendada andmeid koodiga
--Id 3 uus vanus on 50
update Person
set Age = 50 
where Id = 3

select * from Person

--lisame Person tabelisse veeru City ja nvarchar 50
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--kõik, kes ei ela Gothamis
select * from Person where not City = 'Gotham'
select * from Person where not City <> 'Gotham' 
select * from Person where not City != 'Gotham'

--näitab teatud vanusega inimesi
--35,42,23
select * from Person where Age in (35, 42, 23)
select * from Person where Age = 35 or Age = 42 or Age = 23

--näitab teatud vanusevahemikus olevaid isikuid 22 kuni 39
select * from Person where Age between 22 and 39
select * from Person where Age >=22 and Age <=39

--wildcardi kasutamine
--näitab kõik g-tähega algavad linnad
select * from Person where City like 'g%'
--email, kus on @ märk sees
select * from Person where Email like '%@%'

--näitab kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

--kõik, kellel on nimes esimene täht W, A, S
select * from Person where Name like 'w%' or Name like 'A%' or Name like 'S%'
select * from Person where Name like '[^WAS]%'
select * from Person where Name like '[WAS]%'

--kes elavad Gothamis ja New Yorkis
select * from Person where City like 'Gotham' or City like 'New York'
select * from Person where (City = 'Gotham' or City = 'New York')

--kes elavad Gothamis ja New Yorkis ja on vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >=30

--3 tund
--10.03.26

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name ASC
--kuvab vastupidises järjestuses nimed
select * from Person order by Name DESC

--võtab kolm esimest rida person tabelist
select top 3 * from Person

--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person order by CAST(Age as int)

--näita esimesed 50% tabelist
select top 50 PERCENT * from Person

--kõikide isikute koondvanus
select SUM(cast(Age as int)) as Koondvanus from Person

--näitab kõige nooremat isikut
select MIN(cast(Age as int)) as NoorematIsikut from Person

--näitab kõige vanem isik
select MAX(cast(Age as int)) as VanemIsik from Person

--muudame Age veeru int andmetüübiks
alter table Person alter column Age INT

--näeme konkreetsetes linnades olevate isikute koondvanust
select City, SUM(Age) as TotalAge from Person group by City
--kuvab esimeses reas välja toodud järjestuses ja kuvab Age TotalAge-ks
--järjestab City-S olevate nimede järgi ja siis GenderId järgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab, et mitu rida on selles tabelis
select * from Person
select COUNT(Id) as ColumnCount from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnades
--arvutab vanuse kokku konkreetses linnas
select GenderID, City, SUM(age) as 'TotalAge', COUNT(Name) as 'TotalPersons' 
from Person 
where (GenderId = 2) group by city, GenderId

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab soo järgi
select GenderID, City, SUM(age) as 'TotalAge', COUNT(Name) as 'TotalPersons'
from Person 
group by GenderId, City having SUM(Age) > 41

--loome tabelid Employees ja Department
create table Employees
(
Id int not null primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int,
)

create table Department
(
Id int not null primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50),
)

alter table Employees
add City nvarchar(50)

insert into Employees (Id, Name, Gender, Salary, DepartmentId, City)
values(1, 'Tom', 'Male', '4000', 1,  'London'),
(2, 'Pam', 'Female', '3000', 3, 'New York'),
(3, 'John', 'Male', '3500', 1, 'London'),
(4, 'Sam', 'Male', '4500', 2, 'London'),
(5, 'Todd', 'Male', '2800', 2, 'Sydney'),
(6, 'Ben', 'Male', '7000', 1, 'New York'),
(7, 'Sara', 'Female', '4800', 3, 'Sydney'),
(8, 'Valarie', 'Female', '5500', 1, 'New York'),
(9, 'James', 'Male', '6500', NULL, 'London'),
(10, 'Russell', 'Male', '8800', NULL, 'London')


select * from Employees

insert into Department (Id, DepartmentName, Location, DepartmentHead )
values(1, 'It', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department

--
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutame kõikide palgad kokku
select sum(cast(Salary as int)) as SalaryTotal from Employees
--min palga saaja
select MIN(cast(Salary as int)) as MinimalSalary from Employees