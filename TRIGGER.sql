USE HospitalManagementSystem;
GO
/*==============================================================
   Helper: a sequence to generate unique MedicalRecord IDs
   (only needed because RID is an INT PK without IDENTITY)
  ==============================================================*/
IF OBJECT_ID('dbo.Seq_MedRecID','SO') IS NULL
    CREATE SEQUENCE dbo.Seq_MedRecID START WITH 1000 INCREMENT BY 1;
GO
/*==============================================================
  TRIGGER 1
  AFTER INSERT ON Appointments
  → Automatically create a stub record in MedicalRecords
  ==============================================================*/
IF OBJECT_ID('dbo.trg_AfterInsert_Appointments','TR') IS NOT NULL
    DROP TRIGGER dbo.trg_AfterInsert_Appointments;
GO
CREATE TRIGGER dbo.trg_AfterInsert_Appointments
ON dbo.Appointments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    /* For every new appointment, add a “visit created” note */
    INSERT INTO dbo.MedicalRecords (RID, RDate, RNote, Diagnosis, TPlane, PID, DoID)
    SELECT
        NEXT VALUE FOR dbo.Seq_MedRecID        AS RID,
        CAST(ADate AS DATE)                    AS RDate,
        'Auto-log: appointment created'        AS RNote,
        NULL                                   AS Diagnosis,
        NULL                                   AS TPlane,
        i.PID,
        i.DoID
    FROM inserted i;
END;
GO
/*==============================================================
  TRIGGER 2
  INSTEAD OF DELETE ON Patients
  → Block deletion if the patient still has ANY billing rows
  ==============================================================*/
IF OBJECT_ID('dbo.trg_PreventDelete_PatientWithBills','TR') IS NOT NULL
    DROP TRIGGER dbo.trg_PreventDelete_PatientWithBills;
GO
CREATE TRIGGER dbo.trg_PreventDelete_PatientWithBills
ON dbo.Patients
INSTEAD OF DELETE
AS
BEGIN
    /* 1️⃣  If a deleted PID exists in Billing, stop the delete */
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.Billing b ON b.PID = d.PID
    )
    BEGIN
        RAISERROR ('Cannot delete patient – pending billing records exist.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    /* 2️⃣  Safe to delete – cascade manually (or rely on FKs) */
    DELETE FROM dbo.Patients
    WHERE PID IN (SELECT PID FROM deleted);
END;
GO
/*==============================================================
  TRIGGER 3
  AFTER UPDATE ON Rooms
  → Ensure no two *active* patients occupy the same room
      (counts Admissions where DateOut IS NULL)
  ==============================================================*/
IF OBJECT_ID('dbo.trg_CheckRoomOccupancy','TR') IS NOT NULL
    DROP TRIGGER dbo.trg_CheckRoomOccupancy;
GO
CREATE TRIGGER dbo.trg_CheckRoomOccupancy
ON dbo.Rooms
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    /* Check each room that was just updated */
    IF EXISTS (
        SELECT 1
        FROM inserted i
        CROSS APPLY (
            SELECT COUNT(*) AS CurrentOccupancy
            FROM dbo.Admissions a
            WHERE a.RoID = i.RoID
              AND a.DateOut IS NULL        -- active stay
        ) c
        WHERE i.Available = 0              -- room marked occupied
          AND c.CurrentOccupancy > 1       -- more than one occupant
    )
    BEGIN
        RAISERROR ('Room already has an active patient – update cancelled.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
/*==============================================================
  ✅  Triggers created:
      • trg_AfterInsert_Appointments
      • trg_PreventDelete_PatientWithBills
      • trg_CheckRoomOccupancy
==============================================================*/


/* 1. Insert a dummy appointment → should auto-create a medical record */
INSERT INTO Appointments (ATime, ADate, Status, PID, DoID)
VALUES ('10:00','2025-07-01','Scheduled',1,1);
SELECT TOP 1 * FROM MedicalRecords ORDER BY RID DESC;   -- verify new row


/* 3. Simulate two open admissions in the same room to test occupancy rule */
INSERT INTO Admissions (AdID, PID, RoID, DateIn) VALUES (999, 2, 1, '2025-07-01');  -- same RoID 1
UPDATE Rooms SET Available = 0 WHERE RoID = 1;    -- should rollback with trigger error
