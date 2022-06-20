CREATE DATABASE QLKH
USE QLKH
CREATE TABLE Lecturers(
  LID char(4) NOT NULL,
  FullName nchar(30) NOT NULL,
  Address nvarchar(50) NOT NULL,
  DOB date NOT NULL,
  CONSTRAINT pkLecturers PRIMARY KEY (LID)
)

CREATE TABLE Projects(
  PID char(4) NOT NULL,
  Title nvarchar(50) NOT NULL,
  Level nchar(12) NOT NULL,
  Cost integer,
  CONSTRAINT pkProjects PRIMARY KEY (PID	)
)

CREATE TABLE Participation(
  LID char(4) NOT NULL,
  PID char(4) NOT NULL,
  Duration smallint,
  CONSTRAINT pkParticipation PRIMARY KEY (LID, PID),
  CONSTRAINT fk1 FOREIGN KEY (LID) REFERENCES Lecturers (LID),
  CONSTRAINT fk2 FOREIGN KEY (PID) REFERENCES Projects (PID) 
)


INSERT INTO Lecturers VALUES('GV01',N'Vũ Tuyết Trinh',N'Hoàng Mai, Hà Nội','1975/10/10'),
('GV02',N'Nguyễn Nhật Quang',N'Hai Bà Trưng, Hà Nội','1976/11/03'),
('GV03',N'Trần Đức Khánh',N'Đống Đa, Hà Nội','1977/06/04'),
('GV04',N'Nguyễn Hồng Phương',N'Tây Hồ, Hà Nội','1983/12/10'),
('GV05',N'Lê Thanh Hương',N'Hai Bà Trưng, Hà Nội','1976/10/10')


INSERT INTO Projects VALUES ('DT01',N'Tính toán lưới',N'Nhà nước','700'),
('DT02',N'Phát hiện tri thức',N'Bộ','300'),
('DT03',N'Phân loại văn bản',N'Bộ','270'),
('DT04',N'Dịch tự động Anh Việt',N'Trường','30')


INSERT INTO Participation VALUES ('GV01','DT01','100'),
('GV01','DT02','80'),
('GV01','DT03','80'),
('GV02','DT01','120'),
('GV02','DT03','140'),
('GV03','DT03','150'),
('GV04','DT04','180')

SELECT * FROM Lecturers
SELECT * FROM Projects
SELECT * FROM Participation

--1
SELECT * FROM Lecturers
WHERE Address LIKE N'Hai Bà Trưng%'
ORDER BY FullName DESC

--2
SELECT Fullname, Address, DOB FROM Lecturers 
WHERE LID IN(
SELECT LID FROM Participation
WHERE PID IN (
SELECT PID FROM Projects 
WHERE Title = N'Tính toán lưới'))

SELECT Fullname, Address, DOB FROM Lecturers L, Projects P, Participation Par
WHERE P.Title = N'Tính toán lưới' AND P.PID = Par.PID AND L.LID = Par.LID

--3
SELECT Fullname, Address, DOB FROM Lecturers L, Projects P, Participation Par
WHERE (P.Title IN (N'Tính toán lưới', N'Dịch tự động Anh Việt')) AND P.PID = Par.PID AND L.LID = Par.LID

--4
SELECT * FROM Lecturers
WHERE LID IN(
    SELECT LID FROM Participation
    GROUP BY LID HAVING COUNT(PID) >=2
)
--5

SELECT Fullname FROM Lecturers
WHERE LID = (
  SELECT LID FROM Participation
  GROUP BY LID HAVING COUNT(PID) >= ALL(
    SELECT COUNT(PID) FROM Participation
    GROUP BY LID
  )
)
--6
SELECT * FROM Projects
WHERE Cost <= ALL (
  SELECT Cost FROM Projects
)


--7
SELECT L.Fullname, L.DOB, P.Title FROM Lecturers L, Projects P, Participation Par
WHERE L.Address = N'Tây Hồ, Hà Nội' AND L.LID = Par.LID AND Par.PID = P.PID
--8
SELECT L.FullName FROM Lecturers L, Projects P, Participation Par
WHERE L.DOB < '1980' AND P.title = N'Phân loại văn bản' AND P.PID = Par.PID AND Par.LID = L.LID
--9
SELECT L.Fullname, Par.LID, SUM(Par.Duration) 
FROM Participation Par LEFT JOIN Lecturers L
ON L.LID = Par.LID
GROUP BY Par.LID, L.FullName
--10
INSERT INTO Lecturers
VALUES ('GV06', 'Ngo Tuan Phong', 'Dong Da, Hanoi', '1986/09/08')
--11
UPDATE Lecturers
SET Address = N'Tay Ho, Hanoi'
WHERE FullName = N'Vũ Tuyết Trinh'