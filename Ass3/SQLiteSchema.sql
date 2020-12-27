--Luee Akasha 207951773
--Muhammed Orabi 208035824
--WithTooMuchLove

--Q1
SELECT DISTINCT result.FirstName,result.SalaryPerDay,result.Name,result.Description
FROM(
(SELECT ConstructorEmployeeInfo.EID ,ConstructorEmployeeInfo.FirstName,ConstructorEmployeeInfo.SalaryPerDay
FROM (
ConstructorEmployee
JOIN
Employee
ON ConstructorEmployee.EID=Employee.EID
) AS ConstructorEmployeeInfo) AS A
JOIN
(SELECT ProjectEmployeeInfo.EID,ProjectEmployeeInfo.Name,ProjectEmployeeInfo.Description
FROM(
ProjectConstructorEmployee
JOIN
Project
ON ProjectConstructorEmployee.PID=Project.PID
) AS ProjectEmployeeInfo) AS B
ON A.EID=B.EID
) AS result;

--Q2
SELECT DISTINCT *
FROM(
SELECT *
FROM
(
Employee
JOIN
(
SELECT EID, Name AS 'Department/Project'
FROM(
OfficialEmployee
JOIN
Department
ON OfficialEmployee.Department=Department.DID
)
) AS x
ON Employee.EID = x.EID
)
UNION
SELECT *
FROM
(
Employee
JOIN
(
SELECT DISTINCT ConstructorEmployeeInfo.EID, ConstructorEmployeeInfo.Name AS 'Department/Project'
FROM(
(SELECT EmployeeInProject.EID,EmployeeInProject.PID,Max(EmployeeInProject.EndWorkingDate) AS 'EndWorkingDate'
FROM(
ConstructorEmployee
JOIN
ProjectConstructorEmployee
ON ConstructorEmployee.EID=ProjectConstructorEmployee.EID
) AS EmployeeInProject
GROUP By EmployeeInProject.EID) AS p
JOIN
Project
ON p.PID=Project.PID
) AS ConstructorEmployeeInfo
) AS y
ON Employee.EID = y.EID
)
);
--Q3

SELECT DISTINCT result.Name,result.NumberOfApartments
FROM(
 Neighborhood
JOIN
(SELECT apartments.NID,count(NID) AS 'NumberOfApartments'
FROM(
Apartment
) AS apartments
GROUP BY NID
) AS x 
ON x.NID = Neighborhood.NID
) AS result
GROUP BY result.NID
ORDER BY result.NumberOfApartments DESC;



--Q4
SELECT DISTINCT result.StreetName,result.Number,result.Door,result.LastName,result.FirstName
FROM(
(SELECT Apartment.StreetName,Apartment.Number,Apartment.Door
FROM Apartment) AS Address
LEFT OUTER JOIN
(SELECT Resident.StreetName,Resident.Number,Resident.Door,Resident.FirstName,Resident.LastName
FROM Resident) AS NameAndAddress
ON Address.StreetName=NameAndAddress.StreetName AND Address.Number=NameAndAddress.Number AND Address.Door=NameAndAddress.Door
)AS result;

--Q5
SELECT DISTINCT AID,Name,PricePerHour,MaxPricePerDay,NID
FROM(
ParkingArea
JOIN
(SELECT min(ParkingArea.MaxPricePerDay) AS minimum
FROM ParkingArea) AS parkingAreas
ON ParkingArea.MaxPricePerDay=parkingAreas.minimum
);

--Q6
SELECT DISTINCT result.CID,result.ID
FROM(
(SELECT DISTINCT CID
FROM(
(SELECT AID
FROM(
(SELECT min(MaxPricePerDay) AS 'minimumPrice'
FROM ParkingArea) AS minimum
JOIN
ParkingArea
ON ParkingArea.MaxPricePerDay=minimum.minimumPrice
))AS minimumAreas
JOIN
CarParking
ON CarParking.AID=minimumAreas.AID
))AS parkingInmin
JOIN
Cars
ON Cars.CID=parkingInmin.CID
)AS result;

--Q7
SELECT DISTINCT *
FROM(
SELECT DISTINCT LastName,FirstName,ID
FROM ((SELECT DISTINCT s.FirstName,s.LastName,s.RID AS 'ID', s.source,s.at
FROM( 
(SELECT z.FirstName,z.LastName,z.RID,z.NID AS 'source'
FROM(Resident JOIN Apartment
ON Resident.StreetName=Apartment.StreetName AND Resident.Number=Apartment.Number AND Resident.Door=Apartment.Door
) AS z )AS ResidentAndNeighborhood
JOIN
(SELECT DISTINCT y.ID AS 'RID',y.NID AS 'at'
FROM ((SELECT DISTINCT x.ID,x.AID
FROM (Cars JOIN CarParking 
ON Cars.CID=CarParking.CID) AS x) AS ParkerAndPark JOIN ParkingArea
ON ParkerAndPark.AID=ParkingArea.AID ) AS y) AS ParkerAndNeighborhood
ON ResidentAndNeighborhood.RID=ParkerAndNeighborhood.RID
) AS s ) AS allParkers)
EXCEPT
SELECT DISTINCT LastName,FirstName,ID
FROM(
(SELECT *
FROM((SELECT DISTINCT s.FirstName,s.LastName,s.RID AS 'ID', s.source,s.at
FROM( 
(SELECT z.FirstName,z.LastName,z.RID,z.NID AS 'source'
FROM(Resident JOIN Apartment
ON Resident.StreetName=Apartment.StreetName AND Resident.Number=Apartment.Number AND Resident.Door=Apartment.Door
) AS z )AS ResidentAndNeighborhood
JOIN
(SELECT DISTINCT y.ID AS 'RID',y.NID AS 'at'
FROM ((SELECT DISTINCT x.ID,x.AID
FROM (Cars JOIN CarParking 
ON Cars.CID=CarParking.CID) AS x) AS ParkerAndPark JOIN ParkingArea
ON ParkerAndPark.AID=ParkingArea.AID ) AS y) AS ParkerAndNeighborhood
ON ResidentAndNeighborhood.RID=ParkerAndNeighborhood.RID
) AS s ) AS allParkers) AS t
WHERE t.source<>t.at ) AS outsideParkers)
) AS result;

--Q8
SELECT FirstName,LastName,Resident.RID AS 'ID'
FROM(
(SELECT ID AS 'RID'
FROM (
(SELECT CID
FROM(
SELECT CID, count(AID) AS 'numberOFAreas'
FROM(
SELECT DISTINCT  CID , AID
FROM CarParking
)
GROUP BY CID
)
WHERE numberOFAreas=(SELECT count(AID)
FROM ParkingArea)) AS Car
JOIN
Cars
ON Cars.CID = Car.CID
)) AS parkerID
JOIN
Resident
ON Resident.RID=parkerID.RID
);

--Q9
CREATE VIEW IF NOT EXISTS r_ngbrhd AS 
SELECT *
FROM Neighborhood
WHERE Neighborhood.Name like 'r%' OR Neighborhood.Name like 'R%';

