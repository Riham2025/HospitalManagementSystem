

/*=============================================================
   Phase 5 – Security (DCL)
   • DoctorUser  ↔ doctors / clinicians
   • AdminUser   ↔ administrators
   • DoctorUser:  ONLY SELECT on Patients & Appointments
   • AdminUser :  INSERT + UPDATE on every table
   • REVOKE (or DENY) any DELETE from DoctorUser
  ==============================================================*/
USE HospitalManagementSystem;
GO
/*-------------------------------------------------------------
  1.  Create two database roles
  -------------------------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'DoctorUser')
    CREATE ROLE DoctorUser;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AdminUser')
    CREATE ROLE AdminUser;
GO
/*-------------------------------------------------------------
  2.  Grant / deny permissions
  -------------------------------------------------------------*/
-- 2-A  DoctorUser  → read-only on two tables
GRANT SELECT ON dbo.Patients     TO DoctorUser;
GRANT SELECT ON dbo.Appointments TO DoctorUser;

--  (optional but explicit) remove any delete rights just in case
REVOKE DELETE ON SCHEMA::dbo FROM DoctorUser;   -- removes if granted earlier
DENY   DELETE ON SCHEMA::dbo TO   DoctorUser;   -- prevents future grants
GO
--
/*-------------------------------------------------------------
  3.  (Optional) add real database users to the roles
      – Replace the sample LOGIN names with your own
  -------------------------------------------------------------*/
-- Example doctor login / user
CREATE LOGIN DrJennifer WITH PASSWORD = 'StrongPwd123!';
CREATE USER  DrJennifer FOR LOGIN DrJennifer;
EXEC sp_addrolemember 'DoctorUser', 'DrJennifer';


/*=============================================================
  ✅  Security configuration complete
     • DoctorUser  → SELECT-only on Patients & Appointments,
                     cannot DELETE anything
     
=============================================================*/
