

/*=============================================================
  Phase 4 – Functions & Stored Procedures
  HospitalManagementSystem database must already exist
  ==============================================================*/
USE HospitalManagementSystem;
GO
/*-------------------------------------------------------------
  1.  SCALAR FUNCTION - calculate a patient’s age from DOB
  -------------------------------------------------------------*/
IF OBJECT_ID('dbo.ufn_GetPatientAge','FN') IS NOT NULL
    DROP FUNCTION dbo.ufn_GetPatientAge;
GO
CREATE FUNCTION dbo.ufn_GetPatientAge (@DOB DATE)
RETURNS INT
AS
BEGIN
    /*  Returns the exact age in years  */
    RETURN DATEDIFF(YEAR, @DOB, GETDATE())
         - CASE                                       -- subtract 1 if birthday hasn’t occurred yet this year
             WHEN (MONTH(@DOB)  >  MONTH(GETDATE()))
               OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
             THEN 1 ELSE 0 END;
END;
GO
/*-------------------------------------------------------------
  2.  STORED PROCEDURE  – Admit a patient
      • Adds a row to Admissions
      • Marks the room as unavailable
      • Wrapped in a single transaction
  -------------------------------------------------------------*/
IF OBJECT_ID('dbo.sp_AdmitPatient','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AdmitPatient;
GO
CREATE PROCEDURE dbo.sp_AdmitPatient
    @PID     INT,
    @RoID    INT,
    @DateIn  DATE,
    @ExpectedDateOut DATE = NULL    -- optional (NULL means unknown / open-ended stay)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        /* 1️⃣  make sure the room is free */
        IF EXISTS (SELECT 1 FROM Rooms WHERE RoID = @RoID AND Available = 0)
        BEGIN
            THROW 51000, 'Selected room is already occupied.', 1;
        END

        /* 2️⃣  insert admission record */
        INSERT INTO Admissions (PID, RoID, DateIn, DateOut)
        VALUES (@PID, @RoID, @DateIn, @ExpectedDateOut);

        /* 3️⃣  mark room unavailable */
        UPDATE Rooms SET Available = 0 WHERE RoID = @RoID;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;   -- bubble the original error up
    END CATCH
END;
GO
/*-------------------------------------------------------------
  3.  STORED PROCEDURE  – Generate an invoice
      • Creates a Billing row for a patient
      • Accepts a table-valued parameter of services
      • Calculates total cost automatically
  -------------------------------------------------------------*/
-- 3-A  FT table type for list of chargeable services
IF TYPE_ID('dbo.ServiceListTVP') IS NOT NULL
    DROP TYPE dbo.ServiceListTVP;
GO
CREATE TYPE dbo.ServiceListTVP AS TABLE
(
    ServiceDescription  VARCHAR(255) NOT NULL,
    ServiceCost         DECIMAL(10,2) NOT NULL
);
GO
-- 3-B  procedure
IF OBJECT_ID('dbo.sp_GenerateInvoice','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GenerateInvoice;
GO
CREATE PROCEDURE dbo.sp_GenerateInvoice
    @PID        INT,
    @BDate      DATE            = NULL,       -- defaults to today
    @Services   dbo.ServiceListTVP READONLY   -- TVP input
AS
BEGIN
    SET NOCOUNT ON;
    IF @BDate IS NULL SET @BDate = CAST(GETDATE() AS DATE);

    DECLARE @Total DECIMAL(10,2);
    SELECT @Total = SUM(ServiceCost) FROM @Services;

    -- Concatenate service descriptions into a single sentence
    DECLARE @SvcText VARCHAR(MAX);
    SELECT @SvcText = STRING_AGG(ServiceDescription, '; ')
    FROM @Services;

    INSERT INTO Billing (BDate, TotalCost, Services, PID)
    VALUES (@BDate, @Total, @SvcText, @PID);
END;
GO
/*-------------------------------------------------------------
  4.  STORED PROCEDURE  – Assign a doctor to a department
      and record their shift
      • Adds (or updates) a row in new helper table DoctorShift
  -------------------------------------------------------------*/
-- 4-A  helper table (1 doctor may cover multiple depts / shifts)
IF OBJECT_ID('dbo.DoctorShift','U') IS NULL
BEGIN
    CREATE TABLE dbo.DoctorShift
    (
        DoID   INT NOT NULL FOREIGN KEY REFERENCES Doctors(DoID),
        DiD    INT NOT NULL FOREIGN KEY REFERENCES Departments(DiD),
        Shift  VARCHAR(20) NOT NULL,              -- e.g. 'AM', 'PM', 'Night'
        PRIMARY KEY (DoID, DiD, Shift)
    );
END
GO
-- 4-B  procedure
IF OBJECT_ID('dbo.sp_AssignDoctorToDept','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AssignDoctorToDept;
GO
CREATE PROCEDURE dbo.sp_AssignDoctorToDept
    @DoID  INT,
    @DiD   INT,
    @Shift VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE dbo.DoctorShift AS tgt
    USING (SELECT @DoID AS DoID, @DiD AS DiD, @Shift AS Shift) AS src
    ON (tgt.DoID = src.DoID AND tgt.DiD = src.DiD AND tgt.Shift = src.Shift)
    WHEN MATCHED THEN
        UPDATE SET Shift = src.Shift           -- allow shift update if desired
    WHEN NOT MATCHED THEN
        INSERT (DoID, DiD, Shift) VALUES (src.DoID, src.DiD, src.Shift);
END;
GO
/*=============================================================
  ✅  Phase 4 objects created
  • dbo.ufn_GetPatientAge
  • dbo.sp_AdmitPatient
  • dbo.ServiceListTVP  +  dbo.sp_GenerateInvoice
  • dbo.DoctorShift     +  dbo.sp_AssignDoctorToDept
=============================================================*/
