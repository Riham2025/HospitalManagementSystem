
CREATE DATABASE HospitalManagementSystem ;

use HospitalManagementSystem 


------CREATE TABLES
CREATE TABLE Patients (
    PID INT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    PDOB DATE NOT NULL,
    PhoneN VARCHAR(15) UNIQUE NOT NULL,
    Pemail VARCHAR(100) UNIQUE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')) NOT NULL
);
ALTER TABLE Patients
ALTER COLUMN PhoneN VARCHAR(100) NOT NULL;



CREATE TABLE Doctors (
    DoID INT PRIMARY KEY,
    Dname VARCHAR(100) NOT NULL,
    Dgender CHAR(1) CHECK (Dgender IN ('M', 'F')) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    DPhoneN VARCHAR(15) UNIQUE NOT NULL,
    Demail VARCHAR(100) UNIQUE NOT NULL
);
ALTER TABLE Doctors
ALTER COLUMN DPhoneN VARCHAR(30) NOT NULL;


CREATE TABLE Departments (
    DiD INT PRIMARY KEY,
    DName VARCHAR(100) NOT NULL,
    DPhone VARCHAR(15),
    DoID INT,
    SID INT,
    FOREIGN KEY (DoID) REFERENCES Doctors(DoID),
    FOREIGN KEY (SID) REFERENCES Staff(SID)
);
ALTER TABLE Departments
ALTER COLUMN DPhone VARCHAR(100) NOT NULL;

CREATE TABLE Appointments (
    ATime TIME NOT NULL,
    ADate DATE NOT NULL,
    Status VARCHAR(20),
    PID INT,
    DoID INT,
    PRIMARY KEY (PID, DoID, ADate, ATime),
    FOREIGN KEY (PID) REFERENCES Patients(PID),
    FOREIGN KEY (DoID) REFERENCES Doctors(DoID)
);

CREATE TABLE Admissions (
    AdID INT PRIMARY KEY,
    PID INT NOT NULL,
    RoID INT NOT NULL,
    DateIn DATE NOT NULL,
    DateOut DATE,
    FOREIGN KEY (PID) REFERENCES Patients(PID),
    FOREIGN KEY (RoID) REFERENCES Rooms(RoID)
);

CREATE TABLE Rooms (
    RoID INT PRIMARY KEY,
    Available BIT DEFAULT 1,
    NAvailable INT CHECK (NAvailable >= 0),
    Type VARCHAR(20) CHECK (Type IN ('ICU', 'General')),
    ICU BIT DEFAULT 0,
    General BIT DEFAULT 1
);

CREATE TABLE MedicalRecords (
    RID INT PRIMARY KEY,
    RDate DATE NOT NULL,
    RNote TEXT,
    Diagnosis VARCHAR(255),
    TPlane TEXT,
    PID INT,
    DoID INT,
    FOREIGN KEY (PID) REFERENCES Patients(PID),
    FOREIGN KEY (DoID) REFERENCES Doctors(DoID)
);

CREATE TABLE Billing (
    BID INT PRIMARY KEY,
    BDate DATE NOT NULL,
    TotalCost DECIMAL(10,2),
    Services TEXT,
    PID INT,
    FOREIGN KEY (PID) REFERENCES Patients(PID)
);

CREATE TABLE Staff (
    SID INT PRIMARY KEY,
    Sname VARCHAR(100),
    Sgender CHAR(1) CHECK (Sgender IN ('M', 'F')),
    PhoneN VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    Address VARCHAR(255),
    SDOB DATE,
    Srole VARCHAR(50)
);
ALTER TABLE Staff
ALTER COLUMN PhoneN VARCHAR(50);


CREATE TABLE Users (
    UserN VARCHAR(50) PRIMARY KEY,
    PassW VARCHAR(50) NOT NULL,
    SID INT,
    DoID INT,
    FOREIGN KEY (SID) REFERENCES Staff(SID),
    FOREIGN KEY (DoID) REFERENCES Doctors(DoID)
);


--------INSERT DATA
select * from Patients ; 
INSERT INTO Patients (PID, Fname, Lname, PDOB, PhoneN, Pemail, gender) VALUES
(1, 'Jeremy', 'Pena', '1966-08-06', '848.399.1156x7705', 'martinjacqueline@hotmail.com', 'M'),
(2, 'William', 'Bryant', '1987-10-25', '+1-043-212-2912x4474', 'patricia93@henderson.info', 'F'),
(3, 'Renee', 'Zimmerman', '1955-01-29', '(759)090-8646', 'ocruz@zavala.net', 'F'),
(4, 'Vanessa', 'Preston', '1961-06-07', '+1-805-705-9405x43958', 'katherinemckinney@yahoo.com', 'F'),
(5, 'Christopher', 'Thompson', '2000-07-21', '460.552.0297x810', 'ariaszachary@hill.com', 'F'),
(6, 'Douglas', 'Mccoy', '1984-12-31', '654.297.3679x9808', 'fbecker@hotmail.com', 'M'),
(7, 'Diana', 'Rose', '1967-10-04', '(315)305-4952x6852', 'amy98@skinner.com', 'F'),
(8, 'Daniel', 'Ray', '1980-08-29', '776-247-2950x24395', 'dayandrew@cameron.com', 'F'),
(9, 'Sara', 'Holland', '2001-07-05', '267.781.6062x408', 'moorecynthia@hotmail.com', 'M'),
(10, 'Kevin', 'Wilcox', '2004-07-20', '469-086-4674x52311', 'corey96@wood.com', 'M');


select * from Doctors ; 
INSERT INTO Doctors (DoID, Dname, Dgender, specialization, DPhoneN, Demail) VALUES
(1, 'Jennifer Grant', 'F', 'Orthopedics', '898-625-4459', 'adonaldson@hotmail.com'),
(2, 'William Jensen', 'M', 'Pediatrics', '+1-453-934-0468x66421', 'sandra99@bishop-smith.com'),
(3, 'Rose Ford', 'F', 'Orthopedics', '(655)724-0318', 'dlee@marshall.org'),
(4, 'Dustin Weaver', 'M', 'Dermatology', '(215)091-0180x61085', 'grandolph@gmail.com'),
(5, 'Stacy Brock', 'F', 'Dermatology', '+1-316-787-3706x10577', 'jstephenson@williams-obrien.info'),
(6, 'Evelyn Brown MD', 'M', 'Dermatology', '988-234-0345x216', 'ashleypruitt@hotmail.com'),
(7, 'Lindsey Maldonado', 'F', 'Cardiology', '001-757-317-3948x03221', 'bfisher@gmail.com'),
(8, 'Ann Clark', 'F', 'Cardiology', '026-586-2735x489', 'whitneyrodriguez@hotmail.com'),
(9, 'Lawrence Miranda', 'F', 'Neurology', '(066)686-8754x7189', 'gballard@nichols.org'),
(10, 'Norma Gray', 'M', 'Cardiology', '(122)516-2904x80563', 'kristineevans@navarro.com');


select * from Staff ;
INSERT INTO Staff (SID, Sname, Sgender, PhoneN, email, Address, SDOB, Srole) VALUES
(1, 'Michael Owens', 'F', '+1-758-985-8185x9353', 'nconner@yahoo.com', '15272 Gary Forges Apt. 450 South Stephanieborough, MI 94713', '1987-11-03', 'Technician'),
(2, 'Scott Martinez', 'M', '+1-978-276-7730x668', 'scottrobert@yahoo.com', '2333 Russell Burgs Keyside, VA 10290', '1993-05-16', 'Technician'),
(3, 'Deborah Rogers', 'M', '+1-560-386-2480x9481', 'dakota54@stafford.com', '912 Timothy Junctions Suite 985 West Donald, NJ 02116', '1979-02-03', 'Admin'),
(4, 'Robert Wilson', 'M', '(231)926-3028x0813', 'wthomas@gmail.com', '673 Justin Unions Port Donna, NV 01902', '2002-01-29', 'Nurse'),
(5, 'Jennifer Patterson', 'F', '037.349.7054', 'qreese@hotmail.com', '1491 David Divide Apt. 375 Coffeyton, RI 95578', '1993-08-30', 'Nurse'),
(6, 'Dustin Robles', 'F', '346-111-6971x49446', 'randysmith@yahoo.com', '120 Avery Squares Suite 154 Port Shari, MD 37513', '1975-02-24', 'Admin'),
(7, 'Zachary Turner', 'F', '121.992.5077', 'kristopher56@thomas.com', 'Unit 8202 Box 8286 DPO AE 89045', '1980-05-22', 'Admin'),
(8, 'Nathan Bautista', 'M', '269.856.4753', 'ashleygraham@yahoo.com', '36009 Dustin Ridges North Emily, NJ 30631', '1977-10-25', 'Nurse'),
(9, 'Catherine Gonzalez', 'F', '+1-573-869-7239x43648', 'colemanedwin@calderon-ferguson.com', 'USNV Scott FPO AP 59671', '1987-01-03', 'Nurse'),
(10, 'Michael Mullins', 'M', '+1-021-570-2555x7514', 'gonzalezedward@yahoo.com', '101 James Port Port Brendaview, RI 22265', '1995-06-24', 'Nurse');


select * from Departments ;
INSERT INTO Departments (DiD, DName, DPhone, DoID, SID) VALUES
(1, 'Radiology Dept', '001-789-904-6427x76980', 1, 1),
(2, 'Radiology Dept', '605-472-4425', 2, 2),
(3, 'Pediatrics Dept', '(005)258-3490x293', 3, 3),
(4, 'Neurology Dept', '4569439340', 4, 4),
(5, 'Radiology Dept', '001-692-789-3487x526', 5, 5),
(6, 'Radiology Dept', '+1-377-075-6618x19150', 6, 6),
(7, 'Radiology Dept', '9410624713', 7, 7),
(8, 'Radiology Dept', '(646)312-2390x914', 8, 8),
(9, 'Pediatrics Dept', '334.084.2332x692', 9, 9),
(10, 'Oncology Dept', '+1-541-379-3449x9281', 10, 10);


select * from Rooms ;
INSERT INTO Rooms (RoID, Available, NAvailable, Type, ICU, General) VALUES
(1, 0, 3, 'ICU', 1, 0),
(2, 1, 1, 'ICU', 1, 0),
(3, 0, 3, 'General', 0, 1),
(4, 1, 2, 'General', 0, 1),
(5, 1, 0, 'General', 0, 1),
(6, 0, 0, 'General', 0, 1),
(7, 0, 0, 'ICU', 1, 0),
(8, 0, 1, 'ICU', 1, 0),
(9, 1, 0, 'General', 0, 1),
(10, 0, 0, 'ICU', 1, 0);


select * from Users ;
INSERT INTO Users (UserN, PassW, SID, DoID) VALUES
('jenniferclark1', '@%a8PGlKl%', 1, 1),
('gonzalezadam2', '@+s8IDfp#t', 2, 2),
('michaelallen3', '^S9%Zv(znc', 3, 3),
('sharpdanielle4', '(0T1fqNVbW', 4, 4),
('tanyathompson5', '$%58_(Kq^o', 5, 5),
('svasquez6', '(9!E4Ec)n$', 6, 6),
('munozjonathan7', 'm_3EHWneta', 7, 7),
('melanieparker8', '@o#(6F0bqV', 8, 8),
('robin769', 'GHRRcq&I%2', 9, 9),
('erin0510', 'v&0ZwbYweU', 10, 10);


select * from Admissions ;
INSERT INTO Admissions (AdID, PID, RoID, DateIn, DateOut) VALUES
(1, 1, 1, '2023-10-19', '2023-10-26'),
(2, 2, 2, '2023-12-21', '2023-12-26'),
(3, 3, 3, '2023-12-11', '2023-12-16'),
(4, 4, 4, '2023-12-29', '2024-01-05'),
(5, 5, 5, '2023-10-18', '2023-10-23'),
(6, 6, 6, '2024-02-14', '2024-02-23'),
(7, 7, 7, '2023-07-08', '2023-07-16'),
(8, 8, 8, '2023-11-02', '2023-11-03'),
(9, 9, 9, '2023-07-02', '2023-07-03'),
(10, 10, 10, '2024-03-18', '2024-03-28');


select * from Billing  ;
INSERT INTO Billing (BID, BDate, TotalCost, Services, PID) VALUES
(1, '2025-03-07', 939.35, 'Anything series try industry win range.', 1),
(2, '2024-07-06', 461.62, 'Future speak see.', 2),
(3, '2024-11-10', 593.24, 'According far note music teacher blood.', 3),
(4, '2024-12-25', 228.19, 'Now none doctor same kitchen head.', 4),
(5, '2025-01-21', 685.50, 'Candidate finish against into.', 5),
(6, '2024-10-15', 377.45, 'Nearly great front state.', 6),
(7, '2025-06-24', 162.53, 'Early event name heart issue animal.', 7),
(8, '2024-12-17', 695.27, 'Compare good walk analysis no agency.', 8),
(9, '2024-09-27', 439.03, 'Say conference threat teacher realize happen.', 9),
(10, '2024-08-24', 537.93, 'End play question simply score piece.', 10);


select * from Appointments  ;
INSERT INTO Appointments (ATime, ADate, Status, PID, DoID) VALUES
('22:58:46', '2025-02-09', 'Cancelled', 1, 1),
('18:07:54', '2025-04-19', 'Cancelled', 2, 2),
('19:33:22', '2025-03-09', 'Completed', 3, 3),
('09:21:54', '2025-01-12', 'Cancelled', 4, 4),
('20:44:04', '2025-06-26', 'Cancelled', 5, 5),
('07:30:58', '2024-07-17', 'Cancelled', 6, 6),
('19:39:34', '2025-03-26', 'Completed', 7, 7),
('11:03:46', '2025-06-11', 'Completed', 8, 8),
('00:53:27', '2025-01-06', 'Cancelled', 9, 9),
('19:25:04', '2025-02-13', 'Completed', 10, 10);


select * from MedicalRecords  ;
INSERT INTO MedicalRecords (RID, RDate, RNote, Diagnosis, TPlane, PID, DoID) VALUES
(1, '2025-04-19', 'Consider because instead place lawyer seem article. Example analysis health forward left leg.', 'Flu', 'Hear quality feel much them hospital.', 1, 1),
(2, '2025-05-08', 'Writer fact next take part seven recently. Prepare stage every practice research including offer.', 'Fracture', 'Central accept skin.', 2, 2),
(3, '2024-10-10', 'See win rock pull between modern kind. Between bill teach image according opportunity cell.', 'Flu', 'If act nature stay century want everybody.', 3, 3),
(4, '2025-02-23', 'Camera thing bad worry seat result. Brother real head finally usually.', 'Cold', 'Technology western election start man.', 4, 4),
(5, '2024-11-30', 'Call particularly attack lose always.', 'Fracture', 'Believe push free growth speech American.', 5, 5),
(6, '2024-11-14', 'Cover world drop argue drive. Measure second operation special.', 'Hypertension', 'Wife health region beautiful gun population try above.', 6, 6),
(7, '2024-08-08', 'Mention general prepare manage picture next relationship. Probably ok call same.', 'Flu', 'Next movement send yard.', 7, 7),
(8, '2025-04-04', 'Suddenly physical reduce main quality budget. Modern common senior kitchen bank product first.', 'Flu', 'Near century than laugh face heavy.', 8, 8),
(9, '2024-07-26', 'Need pretty both add option right lay. Plant international hard task number structure their learn.', 'Fracture', 'Big order according prevent establish.', 9, 9),
(10, '2024-12-31', 'Green TV similar from kid happen crime sound. Ago door spring president arm.', 'Cold', 'Front blood arrive create low.', 10, 10);
