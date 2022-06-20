CREATE DATABASE lop
USE lop
CREATE TABLE Supplier(
    sid char(2),
    sname varchar(50),
    size int,
    city varchar(50)
)
CREATE TABLE Product(
    pid char(2),
    pname varchar(50),
    colour varchar(50)
)
CREATE TABLE SupplyProduct(
    sid char(2),
    pid char(2),
    quantity int
)

INSERT INTO Supplier (sid, sname, size, city)
VALUES ('S1', 'Dustin', 100, 'London'), ('S2', 'Rusty', 70, 'Paris'), ('S3', 'Lubber', 120, 'London')

INSERT INTO Product (pid, pname, colour)
VALUES ('P1', 'Screw', 'red'), ('P2', 'Screw', 'green'), ('P3', 'Nut', 'red'), ('P4', 'Bolt', 'blue')

INSERT INTO SupplyProduct (sid, pid, quantity)
VALUES ('S1', 'P1', 500), ('S1', 'P2', 400), ('S1', 'P3', 100), ('S2', 'P2', 200), ('S3', 'P4', 100), ('S2', 'P3', 155)


SELECT SP.sid FROM SupplyProduct SP
WHERE SP.pid IN (SELECT pid FROM Product P WHERE P.colour = 'red')
GROUP BY SP.sid 
HAVING COUNT(DISTINCT SP.pid) = (SELECT COUNT(pid) FROM Product P WHERE P.colour = 'red')

SELECT * FROM Supplier
SELECT * FROM Product
SELECT * FROM SupplyProduct


SELECT DISTINCT sname FROM Supplier S, Product P, SupplyProduct SP
WHERE P.colour IN ('red', 'green', 'blue') AND P.pid = SP.pid AND SP.SID = S.SID


SELECT DISTINCT S.sid FROM Supplier S
EXCEPT
SELECT DISTINCT SP.sid FROM SupplyProduct SP



SELECT sid FROM Supplier
EXCEPT
SELECT sid FROM SupplyProduct






SELECT sname FROM Supplier
WHERE sid in (
    SELECT sid FROM SupplyProduct
    WHERE pid = 'P3'
)

SELECT sname FROM Supplier S, SupplyProduct SP
WHERE SP.pid = 'P3' AND SP.sid = S.sid

--10 Tổng số lượng mặt hàng được cung cấp bởi S1

--11 CHo biết mã hãng cung ứng mà có tổng số lượng mặt hàng bằng nhau 
--12 Hãng nào cung ứng nhiều loại mặt hàng nhất 
--13 Cho biết mã hãng có số luợng trung bình mặt hàng là ít nhất trong tất cả các hãng
--14 Hãng S1 tăng trưởng số lượng nhân viên gấp đôi, hãy cập nhật thông tin này
--15 Thêm một hàng mới có mã là S4 tên là louis, số nhân viên là 1300 ở hanoi
--16 Hãy xóa tất cả các thông tin liên quan đến hãng có mã S3
--10
SELECT sid, SUM(quantity) FROM SupplyProduct SP
WHERE sid = 'S1'
GROUP BY sid


--11



--12
SELECT sid FROM SupplyProduct SP
GROUP BY sid HAVING COUNT(pid) >= ALL(
    SELECT COUNT(pid) FROM SupplyProduct SP
    GROUP BY sid
)
--13
SELECT sid FROM SupplyProduct SP
GROUP BY sid HAVING AVG(quantity) <= ALL(
    SELECT AVG(quantity) FROM SupplyProduct SP
    GROUP BY sid
)

UPDATE Supplier
SET size = size*2
WHERE sid = 'S1'

INSERT INTO Supplier
VALUES ('S4', 'Louis', 1300, 'Hanoi')

DELETE FROM SupplyProduct
WHERE sid LIKE 'S3'
DELETE FROM Supplier
WHERE sid LIKE 'S3'



CREATE TABLE Student(
	StudentID char(8) Primary key,
	Name varchar(255),
	Address varchar(255)
)
CREATE TABLE Subject(
	SubjectCode char(6) Primary key,
	Name varchar(255),
	Faculty varchar(255)
)
CREATE TABLE Take(
	SubjectID char(8) Foreign key references Student(StudentID),
	SubjectCode  char(6) Foreign key references Subject(SubjectCode),
    CONSTRAINT PS PRIMARY KEY (SubjectID, SubjectCode)
)
DROP TABLE Student
DROP TABLE Subject
DROP TABLE Take