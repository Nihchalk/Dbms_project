SET SERVEROUTPUT ON;

CREATE TABLE Citizen (
    Citizen_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Gender VARCHAR2(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    Category VARCHAR2(30),
    DOB DATE,
    Income NUMBER CHECK (Income >= 0),
    Aadhaar_No VARCHAR2(20) UNIQUE NOT NULL,
    Region VARCHAR2(50)
);

CREATE TABLE System_User (
    Login_ID NUMBER PRIMARY KEY,
    Citizen_ID NUMBER UNIQUE,
    Username VARCHAR2(50) UNIQUE NOT NULL,
    Password VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE,
    Phone_No VARCHAR2(15),
    Role VARCHAR2(20) CHECK (Role IN ('Admin', 'Officer', 'Citizen')),

    CONSTRAINT fk_user_citizen
    FOREIGN KEY (Citizen_ID)
    REFERENCES Citizen(Citizen_ID)
);

CREATE TABLE Department (
    Dept_ID NUMBER PRIMARY KEY,
    Dept_Name VARCHAR2(100) NOT NULL,
    HOD_Name VARCHAR2(50),
    Budget_Allocated NUMBER CHECK (Budget_Allocated >= 0)
);

CREATE TABLE Scheme (
    Scheme_ID NUMBER PRIMARY KEY,
    Dept_ID NUMBER,
    Title VARCHAR2(100) NOT NULL,
    Min_Age NUMBER,
    Max_Age NUMBER,
    Max_Income NUMBER,
    Benefit_Amount NUMBER CHECK (Benefit_Amount > 0),

    CONSTRAINT fk_scheme_department
    FOREIGN KEY (Dept_ID)
    REFERENCES Department(Dept_ID)
);

CREATE TABLE Application (
    App_ID NUMBER PRIMARY KEY,
    Citizen_ID NUMBER,
    Scheme_ID NUMBER,
    Status VARCHAR2(20)
        CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    Apply_Date DATE,

    CONSTRAINT fk_app_citizen
    FOREIGN KEY (Citizen_ID)
    REFERENCES Citizen(Citizen_ID),

    CONSTRAINT fk_app_scheme
    FOREIGN KEY (Scheme_ID)
    REFERENCES Scheme(Scheme_ID)
);

CREATE TABLE Document (
    Doc_ID NUMBER PRIMARY KEY,
    Citizen_ID NUMBER,
    Doc_Type VARCHAR2(50),
    Verification_Status VARCHAR2(20)
        CHECK (Verification_Status IN ('Verified', 'Pending', 'Rejected')),
    Upload_Date DATE,

    CONSTRAINT fk_doc_citizen
    FOREIGN KEY (Citizen_ID)
    REFERENCES Citizen(Citizen_ID)
);

CREATE TABLE Audit_Log (
    Log_ID NUMBER PRIMARY KEY,
    Action_Type VARCHAR2(100),
    Action_Time DATE,
    Performed_By VARCHAR2(50),
    Remarks VARCHAR2(200)
);

CREATE TABLE Payment (
    Txn_ID NUMBER PRIMARY KEY,
    App_ID NUMBER UNIQUE,
    Amount NUMBER CHECK (Amount > 0),
    Pay_Date DATE,
    Payment_Mode VARCHAR2(30),

    CONSTRAINT fk_payment_application
    FOREIGN KEY (App_ID)
    REFERENCES Application(App_ID)
);

ALTER TABLE Citizen
ADD Occupation VARCHAR2(50);

ALTER TABLE Audit_Log
MODIFY Remarks VARCHAR2(500);

ALTER TABLE Department
ADD CONSTRAINT unique_dept_name
UNIQUE (Dept_Name);

INSERT INTO Citizen VALUES
(1, 'Rahul Sharma', 'Male', 'General',
TO_DATE('2002-05-14','YYYY-MM-DD'),
250000, '123456789012', 'Patiala', 'Student');

INSERT INTO Citizen VALUES
(2, 'Priya Verma', 'Female', 'OBC',
TO_DATE('2001-08-21','YYYY-MM-DD'),
180000, '234567890123', 'Ludhiana', 'Teacher');

INSERT INTO Citizen VALUES
(3, 'Amanpreet Singh', 'Male', 'SC',
TO_DATE('1999-11-10','YYYY-MM-DD'),
120000, '345678901234', 'Amritsar', 'Farmer');

INSERT INTO Citizen VALUES
(4, 'Simran Kaur', 'Female', 'General',
TO_DATE('2000-03-18','YYYY-MM-DD'),
150000, '456789012345', 'Jalandhar', 'Nurse');

INSERT INTO Citizen VALUES
(5, 'Harpreet Singh', 'Male', 'OBC',
TO_DATE('1998-07-09','YYYY-MM-DD'),
90000, '567890123456', 'Bathinda', 'Labourer');

INSERT INTO Citizen VALUES
(6, 'Neha Gupta', 'Female', 'General',
TO_DATE('2003-01-25','YYYY-MM-DD'),
320000, '678901234567', 'Chandigarh', 'Student');

INSERT INTO System_User VALUES
(101, 1, 'rahul01', 'pass123',
'rahul@gmail.com', '9876543210', 'Citizen');

INSERT INTO System_User VALUES
(102, NULL, 'officer01', 'admin123',
'officer@gov.in', '9876500000', 'Officer');

INSERT INTO System_User VALUES
(103, NULL, 'admin01', 'root123',
'admin@gov.in', '9999999999', 'Admin');



INSERT INTO Department VALUES
(10, 'Social Welfare', 'R.K. Mehta', 5000000);

INSERT INTO Department VALUES
(20, 'Education', 'Pooja Sharma', 3000000);

INSERT INTO Department VALUES
(30, 'Health Department', 'Dr. S. Arora', 4000000);

INSERT INTO Department VALUES
(40, 'Women Welfare', 'Anita Kapoor', 3500000);

INSERT INTO Scheme VALUES
(201, 10, 'Old Age Pension', 60, 100, 200000, 5000);

INSERT INTO Scheme VALUES
(202, 20, 'Scholarship Scheme', 18, 30, 300000, 10000);

INSERT INTO Scheme VALUES
(203, 30, 'Health Support Scheme', 18, 65, 250000, 15000);

INSERT INTO Scheme VALUES
(204, 40, 'Widow Pension Scheme', 25, 60, 200000, 7000);

INSERT INTO Scheme VALUES
(205, 10, 'Farmer Support Scheme', 21, 60, 180000, 12000);

INSERT INTO Application VALUES
(301, 1, 202, 'Pending',
TO_DATE('2026-04-10','YYYY-MM-DD'));

INSERT INTO Application VALUES
(302, 2, 202, 'Approved',
TO_DATE('2026-04-12','YYYY-MM-DD'));

INSERT INTO Application VALUES
(303, 3, 201, 'Pending',
TO_DATE('2026-04-15','YYYY-MM-DD'));

INSERT INTO Application VALUES
(304, 4, 203, 'Approved',
TO_DATE('2026-04-18','YYYY-MM-DD'));

INSERT INTO Application VALUES
(305, 5, 205, 'Pending',
TO_DATE('2026-04-19','YYYY-MM-DD'));

INSERT INTO Application VALUES
(306, 6, 202, 'Approved',
TO_DATE('2026-04-20','YYYY-MM-DD'));

INSERT INTO Application VALUES
(307, 2, 204, 'Approved',
TO_DATE('2026-04-21','YYYY-MM-DD'));

INSERT INTO Payment VALUES
(401, 302, 10000,
TO_DATE('2026-04-20','YYYY-MM-DD'),
'Bank Transfer');

INSERT INTO Payment VALUES
(402, 304, 15000,
TO_DATE('2026-04-25','YYYY-MM-DD'),
'Bank Transfer');

INSERT INTO Payment VALUES
(403, 306, 10000,
TO_DATE('2026-04-26','YYYY-MM-DD'),
'UPI');

INSERT INTO Payment VALUES
(404, 307, 7000,
TO_DATE('2026-04-27','YYYY-MM-DD'),
'Bank Transfer');

INSERT INTO Document VALUES
(501, 1, 'Income Certificate',
'Verified',
TO_DATE('2026-04-05','YYYY-MM-DD'));

INSERT INTO Document VALUES
(502, 2, 'Caste Certificate',
'Verified',
TO_DATE('2026-04-06','YYYY-MM-DD'));

INSERT INTO Audit_Log VALUES
(601, 'Application Submitted',
SYSDATE,
'rahul01',
'Scholarship Scheme application submitted');

COMMIT;

UPDATE Citizen
SET Income = 275000
WHERE Citizen_ID = 1;

UPDATE Application
SET Status = 'Approved'
WHERE App_ID = 301;

UPDATE Department
SET Budget_Allocated = 5500000
WHERE Dept_ID = 10;

DELETE FROM Document
WHERE Doc_ID = 502;

DELETE FROM Audit_Log
WHERE Log_ID = 601;

COMMIT;

--Query 1: Citizens and Their Applied Schemes (JOIN)

SELECT 
    c.Citizen_ID,
    c.Name,
    c.Category,
    s.Title AS Scheme_Name,
    a.Status
FROM Citizen c
JOIN Application a
    ON c.Citizen_ID = a.Citizen_ID
JOIN Scheme s
    ON a.Scheme_ID = s.Scheme_ID;
    
--    Query 2: Approved Applications with Payment Details (Multiple JOIN)

SELECT
    a.App_ID,
    c.Name,
    s.Title AS Scheme_Name,
    p.Amount,
    p.Pay_Date,
    p.Payment_Mode
FROM Application a
JOIN Citizen c
    ON a.Citizen_ID = c.Citizen_ID
JOIN Scheme s
    ON a.Scheme_ID = s.Scheme_ID
JOIN Payment p
    ON a.App_ID = p.App_ID
WHERE a.Status = 'Approved';


--Query 3: Total Applications per Scheme (GROUP BY)

SELECT
    s.Title AS Scheme_Name,
    COUNT(a.App_ID) AS Total_Applications
FROM Scheme s
LEFT JOIN Application a
    ON s.Scheme_ID = a.Scheme_ID
GROUP BY s.Title;

--Query 4: Schemes Having More Than One Application (HAVING)

SELECT
    s.Title AS Scheme_Name,
    COUNT(a.App_ID) AS Total_Applications
FROM Scheme s
JOIN Application a
    ON s.Scheme_ID = a.Scheme_ID
GROUP BY s.Title
HAVING COUNT(a.App_ID) > 1;


--Query 5: Citizens Below Average Income (SUBQUERY)

SELECT
    Citizen_ID,
    Name,
    Income
FROM Citizen
WHERE Income < (
    SELECT AVG(Income)
    FROM Citizen
);

--Query 6: Create a View for Approved Applications (VIEW)

CREATE VIEW Approved_Applications AS
SELECT
    a.App_ID,
    c.Name,
    s.Title AS Scheme_Name,
    a.Status
FROM Application a
JOIN Citizen c
    ON a.Citizen_ID = c.Citizen_ID
JOIN Scheme s
    ON a.Scheme_ID = s.Scheme_ID
WHERE a.Status = 'Approved';

SELECT * FROM Approved_Applications;



CREATE OR REPLACE FUNCTION Check_Eligibility (
    p_Citizen_ID IN NUMBER,
    p_Scheme_ID IN NUMBER
)
RETURN VARCHAR2
IS
    v_income Citizen.Income%TYPE;
    v_max_income Scheme.Max_Income%TYPE;
BEGIN
    -- Fetch citizen income
    SELECT Income
    INTO v_income
    FROM Citizen
    WHERE Citizen_ID = p_Citizen_ID;

    -- Fetch scheme max income limit
    SELECT Max_Income
    INTO v_max_income
    FROM Scheme
    WHERE Scheme_ID = p_Scheme_ID;

    -- Eligibility check
    IF v_income <= v_max_income THEN
        RETURN 'Eligible';
    ELSE
        RETURN 'Not Eligible';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Invalid Citizen or Scheme ID';

    WHEN OTHERS THEN
        RETURN 'Error Occurred';
END;
/


SELECT Check_Eligibility(1, 202)
FROM dual;


CREATE OR REPLACE TRIGGER trg_check_eligibility
BEFORE INSERT ON Application
FOR EACH ROW
DECLARE
    v_result VARCHAR2(30);
BEGIN
    -- Call function to check eligibility
    v_result := Check_Eligibility(:NEW.Citizen_ID, :NEW.Scheme_ID);

    -- If not eligible, stop insertion
    IF v_result <> 'Eligible' THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Citizen is not eligible for this scheme.'
        );
    END IF;
END;
/




INSERT INTO Application VALUES
(308, 6, 205, 'Pending',
TO_DATE('2026-05-01','YYYY-MM-DD'));



CREATE SEQUENCE Payment_seq
START WITH 500
INCREMENT BY 1;


CREATE OR REPLACE PROCEDURE Approve_Application (
    p_App_ID IN NUMBER,
    p_Amount IN NUMBER,
    p_Mode IN VARCHAR2
)
IS
BEGIN
    -- Step 1: Update application status
    UPDATE Application
    SET Status = 'Approved'
    WHERE App_ID = p_App_ID;

    -- Step 2: Insert payment record
    INSERT INTO Payment (
        Txn_ID,
        App_ID,
        Amount,
        Pay_Date,
        Payment_Mode
    )
    VALUES (
        Payment_seq.NEXTVAL,
        p_App_ID,
        p_Amount,
        SYSDATE,
        p_Mode
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
    Approve_Application(
        303,
        5000,
        'UPI'
    );
END;
/

DECLARE
    -- Variables to store fetched values
    v_App_ID Application.App_ID%TYPE;
    v_Citizen_ID Application.Citizen_ID%TYPE;
    v_Scheme_ID Application.Scheme_ID%TYPE;
    v_Status Application.Status%TYPE;

    -- Cursor declaration
    CURSOR pending_apps IS
        SELECT App_ID, Citizen_ID, Scheme_ID, Status
        FROM Application
        WHERE Status = 'Pending';

BEGIN
    OPEN pending_apps;

    LOOP
        FETCH pending_apps
        INTO v_App_ID, v_Citizen_ID, v_Scheme_ID, v_Status;

        EXIT WHEN pending_apps%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'App ID: ' || v_App_ID ||
            ' | Citizen ID: ' || v_Citizen_ID ||
            ' | Scheme ID: ' || v_Scheme_ID ||
            ' | Status: ' || v_Status
        );
    END LOOP;

    CLOSE pending_apps;
END;
/

DECLARE
    v_name Citizen.Name%TYPE;
BEGIN
    -- Try to fetch citizen name
    SELECT Name
    INTO v_name
    FROM Citizen
    WHERE Citizen_ID = 999;

    DBMS_OUTPUT.PUT_LINE(
        'Citizen Name: ' || v_name
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'No citizen found with given ID.'
        );

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Multiple records found.'
        );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: ' || SQLERRM
        );
END;
/



