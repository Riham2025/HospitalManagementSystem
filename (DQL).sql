
-----List all patients with their appointments and doctor names
SELECT 
    P.PID, P.Fname, P.Lname, A.ADate, A.ATime, A.Status,
    D.Dname AS DoctorName
FROM Appointments A
JOIN Patients P ON A.PID = P.PID
JOIN Doctors D ON A.DoID = D.DoID;


------List available rooms by type
SELECT RoID, Type, NAvailable
FROM Rooms
WHERE Available = 1;


----Show billing history of each patient
SELECT 
    B.BID, B.BDate, B.TotalCost, B.Services, 
    P.Fname + ' ' + P.Lname AS PatientName
FROM Billing B
JOIN Patients P ON B.PID = P.PID;


---Get all admitted patients with room type and admission dates
SELECT 
    A.AdID, P.Fname, P.Lname, R.Type, A.DateIn, A.DateOut
FROM Admissions A
JOIN Patients P ON A.PID = P.PID
JOIN Rooms R ON A.RoID = R.RoID;


---List doctors with their department names
SELECT 
    D.DoID, D.Dname, DP.DName AS Department
FROM Doctors D
JOIN Departments DP ON D.DoID = DP.DoID;


---Get number of appointments per doctor
SELECT 
    D.Dname, COUNT(*) AS AppointmentCount
FROM Appointments A
JOIN Doctors D ON A.DoID = D.DoID
GROUP BY D.Dname;


