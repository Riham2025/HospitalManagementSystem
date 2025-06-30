

USE HospitalManagementSystem;
GO

-- Sample inputs
DECLARE @AdID INT = 101;
DECLARE @PID INT = 1;
DECLARE @RoID INT = 5;
DECLARE @DateIn DATE = GETDATE();
DECLARE @DateOut DATE = NULL;

DECLARE @BID INT = 101;
DECLARE @BDate DATE = GETDATE();
DECLARE @TotalCost DECIMAL(10,2) = 750.00;


BEGIN TRY
    BEGIN TRANSACTION;

--select* from Admissions;

    -- 1️⃣ Insert into Admissions
    INSERT INTO Admissions (AdID, PID, RoID, DateIn, DateOut)
    VALUES (@AdID, @PID, @RoID, @DateIn, @DateOut);

    -- 2️⃣ Update Room availability (mark unavailable)
    UPDATE Rooms
    SET Available = 0
    WHERE RoID = @RoID;

    -- 3️⃣ Insert Billing record
    INSERT INTO Billing (BID, BDate, TotalCost, PID)
    VALUES (@BID, @BDate, @TotalCost, @PID);

    --  All steps succeeded
    COMMIT;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    --  An error occurred — rollback everything
    ROLLBACK;
    PRINT 'Transaction failed. Rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
