  
   ## SQL Database Project:  Hospital Management System

    Step 1: Create the Tables (DDL)


   1.Patients Table

   ![](image/1.png)

   2. Doctors Table
   
   ![](image/2.png) 

   3. Departments Table
   
   ![](image/3.png)

   4. Appointments Table
   
   ![](image/4.png)

   
   5. Admissions Table

   ![](image/5.png)

   6. Rooms Table

   ![](image/6.png)

  7. MedicalRecords Table

   ![](image/7.png)

   8. Billing Table

   ![](image/8.png)

   9. Staff Table

   ![](image/9.png)

   10. Users Table

   ![](image/10.png)


  ** Step 2: Insert the Tables (DML)

   1.Insert Patients Table

   ![](image/11.png)


  2.Insert Doctors Table
  
  ![](image/12.png)

  3.Insert Staff Table

  ![](image/13.png)

  4.Insert Departments Table

  ![](image/14.png)

  5.Insert Rooms Table

  ![](image/15.png)

  6.Insert Users Table

  ![](image/16.png)


  7.Insert  Admissions  Table

  ![](image/17.png)


  8.Insert Billing Table

  ![](image/18.png)


  9.Insert Appointments  Table

  ![](image/19.png)

  10.Insert MedicalRecords Table

  ![](image/20.png)


  **  Setp 3  SQL Queries: (DQL) 

  --List all patients with their appointments and doctor names

  ![](image/21.png)

  --List available rooms by type

  ![](image/22.png)

  --Show billing history of each patient

  ![](image/23.png)

  --Get all admitted patients with room type and admission dates

  ![](image/24.png)


  --List doctors with their department names

  ![](image/25.png)

  ---Get number of appointments per doctor 

  ![](image/26.png)


**Phase 4 – Functions & Stored Procedures

1. SCALAR FUNCTION - calculate a patient’s age from DOB
 
![](image/27.png)

2.  STORED PROCEDURE  – Admit a patient
 
 ![](image/28.png)
 
3.  STORED PROCEDURE  – Generate an invoice
 
![](image/29.png)

 4.  STORED PROCEDURE  – Assign a doctor to a department and record their shift
  
  ![](image/30.png)


 << How to test 
  ![](image/31.png)



  *** TRIGGER 1
  AFTER INSERT ON Appointments
  → Automatically create a stub record in MedicalRecords

  ![](image/32.png)


  TRIGGER 2
  INSTEAD OF DELETE ON Patients
  → Block deletion if the patient still has ANY billing rows

  ![](image/33.png)


  TRIGGER 3
  AFTER UPDATE ON Rooms
  → Ensure no two *active* patients occupy the same room
      (counts Admissions where DateOut IS NULL)

   ![](image/34.png)


   1. Insert a dummy appointment → should auto-create a medical record */
    
   ![](image/35.png) 

   /* 2. Simulate two open admissions in the same room to test occupancy rule */

   ![](image/36.png)
 


 **Phase 5 – Security (DCL)

   1.  Create two database roles
    
   ![](image/37.png)

  2.  Grant / deny permissions

  2-A  DoctorUser  → read-only on two tables

   ![](image/38.png)


   3.  (Optional) add real database users to the roles
      – Replace the sample LOGIN names with your own
  -------------------------------------------------------------*/
-- Example doctor login / user
    
 ![](image/39.png)
   

 Transactions (TCL) 

 ![](image/40.png)


**  Views 
1. Shows upcoming appointments per doctor (future dates only)
1. 
   ![](image/41.png)
  
   
  
2. Patient details + latest appointment + diagnosis if exists

![](image/42.png)

3. Shows number of doctors and patients per department
 
   ![](image/43.png)

