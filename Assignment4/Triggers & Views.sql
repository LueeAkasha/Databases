CREATE VIEW ConstructorEmployeeOverFifty AS
SELECT Employee.EID, FirstName, LastName, BirthDate, Door, Number, StreetName, City, CompanyName, SalaryPerDay
FROM(
	Employee
	JOIN
	ConstructorEmployee
	ON Employee.EID=ConstructorEmployee.EID
)
WHERE (strftime('%Y', 'now') - strftime('%Y', BirthDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', BirthDate)) >=50;


CREATE VIEW ApartmentNumberInNeighborhood AS
SELECT  Neighborhood.NID, count(*)as 'ApartmentNumber'
FROM(
Neighborhood
LEFT OUTER JOIN
Apartment
ON Neighborhood.NID=Apartment.NID
) 
GROUP BY Neighborhood.NID;


CREATE TRIGGER project_deletion
BEFORE DELETE ON Project
FOR EACH ROW
BEGIN
DELETE FROM ProjectConstructorEmployee WHERE PID=OLD.PID;
DELETE FROM Employee WHERE(
 Employee.EID IN (SELECT EID FROM ConstructorEmployee)
 AND Employee.EID NOT IN (SELECT EID FROM OfficialEmployee)
 AND Employee.EID NOT IN (SELECT EID FROM ProjectConstructorEmployee)
);
END;

CREATE TRIGGER insertion_manager_check
BEFORE INSERT ON Department
FOR EACH ROW
BEGIN
SELECT CASE
 WHEN
 (SELECT * FROM (SELECT count(Department.DID)
FROM Department
WHERE ManagerID = NEW.ManagerID
GROUP BY ManagerID)) >=2
THEN
RAISE(ABORT,'this Employee manages max number of departments')
END;
END;



CREATE TRIGGER update_manager_check
BEFORE UPDATE ON Department
FOR EACH ROW
BEGIN
SELECT CASE
 WHEN
 (SELECT * FROM (SELECT count(Department.DID)
FROM Department
WHERE ManagerID = NEW.ManagerID
GROUP BY ManagerID)) >=2
THEN
RAISE(ABORT,'this Employee manages max number of departments')
END;
END;


