18 QUESTIONS  
 
--1. Write a program to interchange the salaries of employee 120 and 122. 
 
SELECT EMPLOYEE_ID,SALARY FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID IN (120,122) ; 
  
CREATE OR REPLACE PROCEDURE INTERCHANGE_SAL(EMP1 OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE,EMP2 OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) 
IS 
EMPLOYEE_NOT_FOUND EXCEPTION; 
E1 OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE; 
E2 OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE; 
BEGIN 
    SELECT EMPLOYEE_ID INTO E1 FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=EMP1; 
    SELECT EMPLOYEE_ID INTO E2 FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=EMP2; 
    UPDATE OEHR_EMPLOYEES SET SALARY= CASE WHEN EMPLOYEE_ID = E1 THEN (SELECT SALARY FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=E2)  
  
                                           WHEN EMPLOYEE_ID = E2 THEN (SELECT SALARY FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=E1)   
  
                                       END  
  
    WHERE EMPLOYEE_ID IN (E1,E2);  
  
    DBMS_OUTPUT.PUT_LINE('Salaries are interchanged successfully');  
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
 
  
BEGIN 
INTERCHANGE_SAL(120,122); 
END; 
  
--2.- Increase the salary of employee 115 based on the following conditions: If experience is more than 10 years, increase salary by 20% If experience is greater than 5 years, increase salary by 10% Otherwise 5% Case by Expression. 
 
SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID = 115; 
UPDATE OEHR_EMPLOYEES SET SALARY=3100  WHERE EMPLOYEE_ID=115; 
  
CREATE OR REPLACE PROCEDURE INCR_SAL(E OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) 
IS 
EXPE NUMBER; 
S VARCHAR2(100); 
BEGIN 
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) INTO EXPE FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=E; 
    UPDATE OEHR_EMPLOYEES SET SALARY=CASE WHEN EXPE>10 THEN SALARY*1.2 
                                          WHEN EXPE>5 THEN SALARY*1.1 
                                          ELSE SALARY*1.05 
                                     END  
                                     WHERE EMPLOYEE_ID=E; 
    S:=CASE WHEN EXPE > 10 THEN 'Salary increased by 20%' 
            WHEN EXPE > 5 THEN 'Salary increased by 10%' 
            ELSE 'Salary increased by 5%' 
       END; 
    DBMS_OUTPUT.PUT_LINE(S); 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
  
BEGIN 
INCR_SAL(115); 
END; 
  
--3. Change commission percentage as follows for employee with ID = 150. If salary is more than 10000 then commission is 0.4%, if Salary is less than 10000 but experience is more than 10 years then 0.35%, if salary is less than 3000 then commission is 0.25%. In the remaining cases commission is 0.15%. 
SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=150 
  
CREATE OR REPLACE PROCEDURE COMM_INCR(E OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) 
IS 
EXPE NUMBER; 
SAL OEHR_EMPLOYEES.SALARY%TYPE; 
S VARCHAR2(100); 
BEGIN 
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12),SALARY INTO EXPE,SAL FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=E; 
    UPDATE OEHR_EMPLOYEES SET COMMISSION_PCT=CASE WHEN SALARY>10000 THEN 0.4 
                                                  WHEN (SALARY<10000 AND EXPE>10) THEN 0.35 
                                                  WHEN SALARY<3000 THEN 0.25 
                                                  ELSE 0.15 
                                              END WHERE EMPLOYEE_ID=E; 
    S:=CASE WHEN SAL>10000 THEN 'Commission updated to 0.4%' 
            WHEN (SAL<10000 AND EXPE>10) THEN 'Commission updated to 0.35%' 
            WHEN SAL<3000 THEN 'Commission updated to 0.25%' 
            ELSE 'Commission updated to 0.15' 
        END; 
    DBMS_OUTPUT.PUT_LINE(S); 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
  
BEGIN 
COMM_INCR(150); 
END; 
 
--4. Find out the name of the employee and name of the department for the employee who is managing for employee 103. 
SELECT * FROM OEHR_DEPARTMENTS 
SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=102 
  
CREATE OR REPLACE PROCEDURE MANAGER_DETAILS(E OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) 
IS 
    EF OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    EL OEHR_EMPLOYEES.LAST_NAME%TYPE; 
    DEPT OEHR_DEPARTMENTS.DEPARTMENT_NAME%TYPE; 
BEGIN 
    SELECT M.FIRST_NAME,M.LAST_NAME,D.DEPARTMENT_NAME INTO EF,EL,DEPT 
    FROM OEHR_EMPLOYEES E  
    JOIN OEHR_EMPLOYEES M ON M.EMPLOYEE_ID=E.MANAGER_ID  
    JOIN OEHR_DEPARTMENTS D ON D.DEPARTMENT_ID=M.DEPARTMENT_ID  
    WHERE E.EMPLOYEE_ID=103; 
    DBMS_OUTPUT.PUT_LINE('Name: '||EF||' '||EL); 
    DBMS_OUTPUT.PUT_LINE('Department Name: '||DEPT); 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
  
BEGIN 
MANAGER_DETAILS(103); 
END; 
 
--5. Display missing employee IDs. 
SELECT * FROM EMPLOYEES 
  
DECLARE 
    TYPE NEST IS TABLE OF NUMBER; 
    EMP NEST:=NEST(); 
    MISSED_EMP NEST:=NEST(); 
    L NUMBER; 
BEGIN 
    SELECT ID BULK COLLECT INTO EMP FROM EMPLOYEES; 
    FOR I IN 1..EMP.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('employee ids: '||EMP(I)); 
    END LOOP; 
    FOR I IN 2..EMP.COUNT LOOP  
        IF EMP(I)-EMP(I-1)> 1 THEN  
            L:=EMP(I)-EMP(I-1)-1; 
            FOR J IN 1..L LOOP 
                MISSED_EMP.EXTEND(); 
                MISSED_EMP(MISSED_EMP.LAST):=EMP(I-1) + J; 
            END LOOP; 
        END IF; 
    END LOOP; 
    FOR I IN 1..MISSED_EMP.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('Missed employee id: '||MISSED_EMP(I)); 
    END LOOP; 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
END; 
  
INSERT INTO EMPLOYEES VALUES(11,'Jack','Smith',1234997890,3,1,600,to_date('12-01-2004','DD-MM-YYYY')); 
 
--6. Display the year in which maximum number of employees joined along with how many joined in each month in that year. 
  
DECLARE 
    Y1 NUMBER; 
BEGIN 
    SELECT Y INTO Y1  FROM (SELECT COUNT(*) AS C,TO_CHAR(HIRE_DATE,'YYYY') AS Y  
    FROM OEHR_EMPLOYEES  
    GROUP BY TO_CHAR(HIRE_DATE,'YYYY')  
    ORDER BY COUNT(*) DESC) 
    WHERE ROWNUM=1; 
  
    FOR I IN (SELECT TO_CHAR(HIRE_DATE,'MONTH') AS M,COUNT(*) AS C  
              FROM OEHR_EMPLOYEES  
              WHERE TO_CHAR(HIRE_DATE,'YYYY')=Y1 
              GROUP BY TO_CHAR(HIRE_DATE,'MONTH') ) 
    LOOP 
        DBMS_OUTPUT.PUT_LINE('MONTH: '||I.M||'COUNT: '||I.C); 
    END LOOP; 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
 
/*7. Change salary of employee 130 to the salary of the employee with first name ‘Joe’. If Joe is not found then take average salary of all employees.  
     If more than one employee with first name ‘Joe’ is found then take the least salary of the employees with first name Joe.*/ 
DECLARE 
EID EMPLOYEES.ID%TYPE:=1; 
SAL EMPLOYEES.SALARY%TYPE; 
A EMPLOYEES.SALARY%TYPE; 
BOOL BOOLEAN; 
BEGIN 
    SELECT AVG(SALARY) INTO A FROM EMPLOYEES; 
    FOR I IN (SELECT * FROM EMPLOYEES) LOOP 
        IF I.FNAME='Joe' THEN 
            IF SAL IS NULL THEN 
                SAL:=I.SALARY; 
                DBMS_OUTPUT.PUT_LINE('NULL SAL UPDATED'); 
                BOOL:=TRUE; 
            ELSIF SAL>I.SALARY THEN 
                SAL:=I.SALARY; 
                DBMS_OUTPUT.PUT_LINE('SALARY UPDATED TO LEAST SALARY'); 
            END IF; 
        ELSE 
            BOOL:=FALSE; 
        END IF; 
    END LOOP; 
    IF NOT BOOL THEN  
        SAL:=A; 
        DBMS_OUTPUT.PUT_LINE('SALARY UPDATED TO AVG OF ALL EMPLOYEES '); 
    END IF; 
    UPDATE EMPLOYEES SET SALARY=SAL WHERE ID=EID; 
END; 
  
SELECT * FROM EMPLOYEES WHERE FNAME='Joe' 
SELECT * FROM EMPLOYEES WHERE ID=1 
update employees set fname='Joe' where id in (5,11) 
  
------------------------------------------------------------------------------------------------------- 
  
DECLARE 
EID OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE:=130; 
SAL OEHR_EMPLOYEES.SALARY%TYPE; 
A OEHR_EMPLOYEES.SALARY%TYPE; 
BOOL BOOLEAN; 
BEGIN 
    SELECT AVG(SALARY) INTO A FROM OEHR_EMPLOYEES; 
    FOR I IN (SELECT * FROM OEHR_EMPLOYEES) LOOP 
        IF I.FIRST_NAME='Joe' THEN 
            IF SAL IS NULL THEN 
                SAL:=I.SALARY; 
                DBMS_OUTPUT.PUT_LINE('NULL SAL UPDATED'); 
                BOOL:=TRUE; 
            ELSIF SAL>I.SALARY THEN 
                SAL:=I.SALARY; 
                DBMS_OUTPUT.PUT_LINE('SALARY UPDATED TO LEAST SALARY'); 
            END IF; 
        ELSE 
            BOOL:=FALSE; 
        END IF; 
    END LOOP; 
    IF NOT BOOL THEN  
        SAL:=A; 
        DBMS_OUTPUT.PUT_LINE('SALARY UPDATED TO AVG OF ALL EMPLOYEES '); 
    END IF; 
    UPDATE OEHR_EMPLOYEES SET SALARY=TRUNC(SAL) WHERE EMPLOYEE_ID=EID; 
END; 
  
SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=130 
 
--8. Display Job Title and Name of the Employee who joined the job first day. 
DECLARE 
    F OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    L OEHR_EMPLOYEES.LAST_NAME%TYPE; 
    J OEHR_JOBS.JOB_TITLE%TYPE; 
BEGIN 
    SELECT FN,LN,JT INTO F,L,J  
    FROM (SELECT E.FIRST_NAME AS FN,E.LAST_NAME AS LN,J.JOB_TITLE AS JT  
          FROM OEHR_EMPLOYEES E  
          JOIN OEHR_JOBS J  
          ON E.JOB_ID=J.JOB_ID  
          ORDER BY E.HIRE_DATE ASC)  
    WHERE ROWNUM=1; 
    
    DBMS_OUTPUT.PUT_LINE('Name: '||F||' '||L); 
    DBMS_OUTPUT.PUT_LINE('Job Title: '||J); 
END; 
 
--9. Display 5th and 10th employees in Employees table. 
DECLARE 
    F1 OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    L1 OEHR_EMPLOYEES.LAST_NAME%TYPE; 
    F2 OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    L2 OEHR_EMPLOYEES.LAST_NAME%TYPE; 
BEGIN 
    SELECT F,L INTO F1,L1 FROM(SELECT FIRST_NAME AS F,LAST_NAME AS L,DENSE_RANK() OVER(ORDER BY EMPLOYEE_ID ASC) AS N FROM OEHR_EMPLOYEES) WHERE N=5; 
    SELECT F,L INTO F2,L2 FROM(SELECT FIRST_NAME AS F,LAST_NAME AS L,DENSE_RANK() OVER(ORDER BY EMPLOYEE_ID ASC) AS N FROM OEHR_EMPLOYEES) WHERE N=10; 
    DBMS_OUTPUT.PUT_LINE(F1||' '||L1||' is the fifth employee in table'); 
    DBMS_OUTPUT.PUT_LINE(F2||' '||L2||' is the tenth employee in table'); 
END; 
 
/*10. Update salary of an employee based on department and commission percentage. If department is 40 increase salary by 10%.  
If department is 70 then 15%, if commission is more than .3% then 5% otherwise 10%.*/ 
SELECT * FROM OEHR_EMPLOYEES; 
DECLARE 
    E OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    FOR I IN (SELECT * FROM OEHR_EMPLOYEES) LOOP 
        E:=I; 
        IF E.DEPARTMENT_ID=40 THEN 
            E.SALARY:=E.SALARY*1.1; 
        ELSIF E.DEPARTMENT_ID=70 THEN 
            E.SALARY:=E.SALARY*1.15; 
        END IF; 
        IF E.COMMISSION_PCT>0.3 THEN 
            E.COMMISSION_PCT:=0.05; 
        ELSE 
            E.COMMISSION_PCT:=0.1; 
        END IF;       
        --UPDATE 
        DBMS_OUTPUT.PUT_LINE('Name: '||E.FIRST_NAME||' '||E.LAST_NAME||' Salary: '||E.SALARY||' Commission: '||E.COMMISSION_PCT||' Department no: '||E.DEPARTMENT_ID); 
    END LOOP; 
END; 
 
--11. Create a function that takes department ID and returns the name of the manager of the department. 
SELECT * FROM OEHR_DEPARTMENTS 
SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=204; 
  
CREATE OR REPLACE FUNCTION DEPT_MANAGER(DID IN OEHR_DEPARTMENTS.DEPARTMENT_ID%TYPE) RETURN VARCHAR2 
IS 
    MFN OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    MLN OEHR_EMPLOYEES.LAST_NAME%TYPE; 
    NAME VARCHAR2(40); 
BEGIN 
    SELECT E.FIRST_NAME,E.LAST_NAME INTO MFN,MLN  
    FROM OEHR_EMPLOYEES E JOIN OEHR_DEPARTMENTS D  
    ON E.DEPARTMENT_ID=D.DEPARTMENT_ID AND E.EMPLOYEE_ID=D.MANAGER_ID  
    WHERE D.DEPARTMENT_ID=DID; 
  
    NAME:=MFN||' '||MLN; 
    RETURN NAME; 
END; 
  
BEGIN 
DBMS_OUTPUT.PUT_LINE(DEPT_MANAGER(70)); 
END; 
 
CREATE OR REPLACE FUNCTION JOB_COUNT(EID IN OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN NUMBER 
IS 
    TYPE NES IS TABLE OF OEHR_EMPLOYEES.JOB_ID%TYPE; 
    H NES; 
    C NUMBER:=0; 
BEGIN 
    SELECT JOB_ID BULK COLLECT INTO H FROM OEHR_JOB_HISTORY WHERE EMPLOYEE_ID=EID; 
    C:=H.COUNT; 
    RETURN C; 
END; 
  
DECLARE 
    ID OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE:=1; 
    H NUMBER; 
BEGIN 
    H:=JOB_COUNT(ID); 
    IF H>0 THEN 
        DBMS_OUTPUT.PUT_LINE('Job history count of employee with id '||id||' is '||H); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('No job history found'); 
    END IF; 
END; 
 
/*13. Create a procedure that takes department ID and changes the manager ID for the department to the employee 
in the department with highest salary. (Use Exceptions).*/ 
SELECT * FROM OEHR_DEPARTMENTS 
  
CREATE OR REPLACE PROCEDURE DEPT_MANAGER_CHANGE(DID IN OEHR_DEPARTMENTS.DEPARTMENT_ID%TYPE) 
IS 
EMP OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE; 
BEGIN 
    SELECT EMPLOYEE_ID INTO EMP  
    FROM (SELECT EMPLOYEE_ID, 
                 MAX(SALARY) OVER(PARTITION BY DEPARTMENT_ID),DEPARTMENT_ID  
          FROM OEHR_EMPLOYEES)  
    WHERE DEPARTMENT_ID=DID; 
    UPDATE OEHR_DEPARTMENTS SET MANAGER_ID=EMP WHERE DEPARTMENT_ID=DID; 
    DBMS_OUTPUT.PUT_LINE('Manager updated successfully'); 
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('More than one employee has maximum salary'); 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Employee with the department number not found OR department not found'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error occurred'); 
END; 
  
DROP PROCEDURE DEPT_MANAGER_CHANEGE 
update oehr_departments set manager_id=101 where department_id=10 
  
BEGIN 
DEPT_MANAGER_CHANGE(1); 
END; 
/*14. Create a function that takes a manager ID and return the names of employees who report to this manager.  
The names must be returned as a string with comma separating names.*/ 
  
CREATE OR REPLACE FUNCTION EMPS_UNDER_MANAGER(MID OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN SYS_REFCURSOR 
IS 
    C SYS_REFCURSOR; 
BEGIN 
    OPEN C FOR SELECT  DISTINCT FIRST_NAME,LAST_NAME FROM OEHR_EMPLOYEES WHERE MANAGER_ID=MID; 
    RETURN C; 
END; 
  
DECLARE 
    CUR SYS_REFCURSOR; 
    FN OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    LN OEHR_EMPLOYEES.LAST_NAME%TYPE; 
BEGIN 
    CUR:=EMPS_UNDER_MANAGER(100); 
    LOOP 
        FETCH CUR INTO FN,LN; 
        EXIT WHEN CUR%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE(FN||' '||LN); 
    END LOOP; 
    CLOSE CUR; 
END; 
 
--16. Create a Trigger to ensure the salary of the employee is not decreased. 
CREATE OR REPLACE TRIGGER SAL_DECREASE  
BEFORE UPDATE ON EMPLOYEES 
FOR EACH ROW 
BEGIN 
    IF :NEW.SALARY<:OLD.SALARY THEN 
        RAISE_APPLICATION_ERROR(-20200,'Salary of the employee can not be decreased'); 
    END IF; 
END; 
  
UPDATE EMPLOYEES SET SALARY=SALARY-1; 
 
--17.  Create a trigger to ensure the employee and manager belongs to the same department. 
CREATE OR REPLACE TRIGGER EMP_MGR_DEPT 
BEFORE INSERT OR UPDATE ON OEHR_EMPLOYEES 
FOR EACH ROW 
DECLARE 
    D NUMBER; 
BEGIN 
    SELECT DEPARTMENT_ID INTO D FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=:NEW.MANAGER_ID; 
    IF :NEW.DEPARTMENT_ID!=D THEN 
        RAISE_APPLICATION_ERROR(-20203,'EMPLOYEE AND MANAGER DEPARTMENTS ARE NOT SAME'); 
    END IF; 
END; 
 
/*18. Whenever the job is changed for an employee write the following details into job history.  
Employee ID, old job ID, old department ID, hire date of the employee for start date, system date for end date.  
But if a row is already present for employee job history then the start date should be the end date of that row +1.*/ 
SELECT * FROM OEHR_EMPLOYEES; 
SELECT * FROM OEHR_JOB_HISTORY; 
alter table oehr_employees DISable all triggers; 
  
UPDATE OEHR_EMPLOYEES SET JOB_ID='AD_ASST' WHERE EMPLOYEE_ID=200; 
DELETE FROM OEHR_JOB_HISTORY WHERE JOB_ID='AD_ASST' AND EMPLOYEE_ID=103 
  
CREATE OR REPLACE TRIGGER UPDATE_JOB_HISTORY 
BEFORE UPDATE OF JOB_ID ON OEHR_EMPLOYEES 
FOR EACH ROW 
DECLARE 
    S_DATE OEHR_EMPLOYEES.HIRE_DATE%TYPE; 
    C NUMBER:=0; 
BEGIN 
    IF :NEW.EMPLOYEE_ID IS NOT NULL THEN 
        SELECT COUNT(*) INTO C FROM OEHR_JOB_HISTORY WHERE JOB_ID=:NEW.JOB_ID; 
        IF  C>0 THEN 
            SELECT MAX(END_DATE)+1 INTO S_DATE FROM OEHR_JOB_HISTORY WHERE EMPLOYEE_ID=:NEW.EMPLOYEE_ID; 
        ELSE 
            S_DATE:=:OLD.HIRE_DATE; 
        END IF; 
        INSERT INTO OEHR_JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)  
        VALUES(:NEW.EMPLOYEE_ID,S_DATE,SYSDATE,:OLD.JOB_ID,:OLD.DEPARTMENT_ID); 
    END IF; 
END; 
 
--packages 
  
create or replace package calculator is 
    procedure multiply(x number,y number); 
    function addition(x number,y number) return number; 
    function division(x number,y number) return number; 
    procedure subtraction(x number,y number); 
end; 
  
create or replace package body calculator is 
    procedure multiply(x number,y number) is 
        begin 
            dbms_output.put_line(x*y); 
        end multiply; 
    /*procedure multiply(x number,y number,z number) is 
        begin 
            dbms_output.put_line(x*y*z); 
        end multiply;*/ 
    /*function addition(x number,y number,z number) return number is 
        begin 
            return x+y+z; 
        end;*/ 
    function addition(x number,y number) return number is 
        begin 
            return x+y; 
        end addition; 
    function modulus(x number,y number) return number is 
        begin 
            return mod(x,y); 
        end; 
    function division(x number,y number) return number is 
        k number; 
        begin 
            k := modulus(x,y); 
            dbms_output.put_line('mod of '||x||', '||y||' is '||k);        
            return x/y; 
        end; 
    procedure subtraction(x number,y number) is 
        begin 
            dbms_output.put_line(x-y); 
        end; 
end; 
  
  
begin 
    dbms_output.put_line(calculator.addition(234,8439)); 
    --dbms_output.put_line(calculator.addition(6,3,9)); 
    dbms_output.put_line(calculator.division(70,10)); 
    calculator.subtraction(6,5); 
    calculator.multiply(5,5); 
    --calculator.multiply(5,5,5); 
end; 
 
Dynamic SQL 
--BIND VARIABLE 
--VARIABLE :B VARCHAR(100); 
--EXEC :B :='HII'; 
DECLARE 
    B VARCHAR(30):=:B; 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(:B); 
END; 
  
--DYNAMIC SQL 
DECLARE 
    A VARCHAR2(100); 
BEGIN 
    A:='CREATE TABLE SAMPLE1(SNO NUMBER PRIMARY KEY, 
                             NAME VARCHAR(30))'; 
    EXECUTE IMMEDIATE A; 
END;                         
SELECT * FROM SAMPLE1 
  
DROP TABLE SAMPLE1 
  
DECLARE 
    A VARCHAR2(100); 
BEGIN 
    A:='CREATE TABLE SAMPLE1('||'SNO NUMBER,'|| 
                             'NAME VARCHAR(30),'|| 
                             'CONSTRAINT PR_K PRIMARY KEY(SNO)'|| 
                             ')'; 
    EXECUTE IMMEDIATE A; 
END;                    
 
DECLARE 
    D VARCHAR(100); 
BEGIN 
    D:='ALTER TABLE SAMPLE1 ADD HIREDATE DATE'; 
    EXECUTE IMMEDIATE D; 
END; 
  
DESC SAMPLE1 
  
DECLARE 
    D VARCHAR(100); 
    K VARCHAR(100); 
BEGIN 
    D:='INSERT INTO SAMPLE1(SNO,NAME,HIREDATE) VALUES(:A,:B,:C)'; 
    EXECUTE IMMEDIATE D USING 2,'VAMI','10-01-2023'; 
    IF SQL%ROWCOUNT>0 THEN 
        K:='UPDATE SAMPLE1 SET NAME=:NEW WHERE NAME=:OLD'; 
        EXECUTE IMMEDIATE K USING 'PRIYA','SONY';  
    END IF; 
END; 
  
DECLARE 
    TYPE NES IS TABLE OF VARCHAR(30); 
    NAM NES; 
    K VARCHAR(100); 
BEGIN 
    K:='SELECT NAME FROM SAMPLE1'; 
    EXECUTE IMMEDIATE K BULK COLLECT INTO NAM; 
    FOR I IN 1..NAM.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE(I||'-'||NAM(I)); 
    END LOOP; 
END; 
  
  
DECLARE 
    V VARCHAR2(400); 
BEGIN 
    V:='DECLARE 
            SNO SAMPLE1.SNO%TYPE; 
            NAM SAMPLE1.NAME%TYPE; 
            H SAMPLE1.HIREDATE%TYPE; 
        BEGIN 
            SELECT SNO,NAME,HIREDATE INTO SNO,NAM,H FROM SAMPLE1 WHERE SNO=1; 
            DBMS_OUTPUT.PUT_LINE(''EXECUTED SUCCESSFULLY''||SNO||'' ''||''NAME''||NAM||''-''||H); 
        END;'; 
        EXECUTE IMMEDIATE V; 
END; 
 
/*18. Whenever the job is changed for an employee write the following details into job history.  
Employee ID, old job ID, old department ID, hire date of the employee for start date, system date for end date.  
But if a row is already present for employee job history then the start date should be the end date of that row +1.*/ 
SELECT * FROM OEHR_EMPLOYEES; 
SELECT * FROM OEHR_JOB_HISTORY; 
alter table oehr_employees enable all triggers; 
  
CREATE OR REPLACE TRIGGER UPDATE_JOB_HISTORY 
FOR UPDATE OF JOB_ID ON OEHR_EMPLOYEES 
COMPOUND TRIGGER 
    S_DATE OEHR_EMPLOYEES.HIRE_DATE%TYPE; 
    C NUMBER; 
BEFORE EACH ROW IS 
BEGIN 
    IF :NEW.EMPLOYEE_ID IS NOT NULL THEN 
        SELECT COUNT(*) INTO C FROM OEHR_JOB_HISTORY WHERE JOB_ID=:NEW.JOB_ID; 
        IF  C>0 THEN 
            SELECT MAX(END_DATE)+1 INTO S_DATE FROM OEHR_JOB_HISTORY WHERE EMPLOYEE_ID=:NEW.EMPLOYEE_ID; 
        ELSE 
            S_DATE:=:OLD.HIRE_DATE; 
        END IF; 
    END IF; 
END BEFORE EACH ROW; 
  
AFTER EACH ROW IS 
BEGIN 
    IF :NEW.EMPLOYEE_ID IS NOT NULL THEN 
        INSERT INTO OEHR_JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)  
        VALUES(:NEW.EMPLOYEE_ID,S_DATE,SYSDATE,:OLD.JOB_ID,:OLD.DEPARTMENT_ID); 
    END IF; 
END AFTER EACH ROW; 
END UPDATE_JOB_HISTORY; 
  
UPDATE OEHR_EMPLOYEES SET JOB_ID='IT_PROG' WHERE EMPLOYEE_ID=101; 
 
Associate array, Varray, nested tables 
--FORALL IN VALUES OF 
DECLARE 
    TYPE NES IS TABLE OF NUMBER; 
    N NES:=NES(34,56,78,55,33,7,668,78,84,8); 
    TYPE ASO IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER; 
    A ASO; 
BEGIN 
    A(3):=90; 
    A(8):=92; 
    A(7):=20; 
    A(0):=10; 
   FORALL I IN VALUES OF A 
    --INSERT 
END; 
  
--EXISTS  
DECLARE 
    TYPE NES_TABLE IS TABLE OF NUMBER; 
    N NES_TABLE:=NES_TABLE(2,3,5,7,8,99,8,79,0); 
BEGIN 
    N.DELETE(3,6); 
    FOR I IN 1..N.LAST LOOP 
        IF N.EXISTS(I) THEN 
            DBMS_OUTPUT.PUT_LINE(N(I)); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('NO DATA AT THIS INDEX'); 
        END IF; 
    END LOOP; 
END;  
 
--FORALL 
DECLARE 
    TYPE NES_TABLE IS TABLE OF NUMBER; 
    N NES_TABLE:=NES_TABLE(2,3,5,7,8,99,8,79,0); 
    K NUMBER:=0; 
BEGIN 
    N.DELETE(3,6); 
    FORALL I IN INDICES OF N 
        --INSERT 
END; 
 
DECLARE 
    TYPE C1 IS TABLE OF VARCHAR(30); 
    E C1:=C1(); 
BEGIN 
    FOR I IN (SELECT FIRST_NAME FROM OEHR_EMPLOYEES ) 
    LOOP 
        E.EXTEND; 
        E(E.LAST):=I.FIRST_NAME; 
    END LOOP; 
    FOR I IN 1..E.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE(I||' - '||E(I)); 
    END LOOP; 
END; 
  
--BULK COLLECT CLAUSE 
  
--SELECT INTO 
DECLARE 
    TYPE BCOLL IS TABLE OF VARCHAR(30); 
    FN BCOLL; 
BEGIN 
    SELECT FIRST_NAME BULK COLLECT INTO FN FROM OEHR_EMPLOYEES; 
    FOR I IN 1..FN.COUNT 
    LOOP 
    DBMS_OUTPUT.PUT_LINE(I||' - '||FN(I)); 
    END LOOP; 
END; 
  
--FETCH INTO 
DECLARE 
    TYPE C IS TABLE OF VARCHAR(30); 
    FNAME C; 
    CURSOR C1 IS SELECT FIRST_NAME FROM OEHR_EMPLOYEES; 
BEGIN 
    OPEN C1; 
    LOOP 
        FETCH C1 BULK COLLECT INTO FNAME; 
        EXIT WHEN FNAME.COUNT=0; 
        FOR I IN FNAME.FIRST..FNAME.LAST LOOP 
            DBMS_OUTPUT.PUT_LINE(I||' - '||FNAME(I)); 
        END LOOP; 
    END LOOP; 
    CLOSE C1; 
END; 
  
--FETCH INTO LIMIT 
DECLARE 
    TYPE C IS TABLE OF VARCHAR(30); 
    FNAME C; 
    CURSOR C1 IS SELECT FIRST_NAME FROM OEHR_EMPLOYEES; 
BEGIN 
    OPEN C1; 
    FETCH C1 BULK COLLECT INTO FNAME LIMIT 10; 
    CLOSE C1; 
    FOR I IN 1..FNAME.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE(I||' - '||FNAME(I)); 
    END LOOP; 
END; 
  
--ASSOCIATE ARRAY OR INDEX BY TABLES 
  
declare 
    type emp_arr_type is table of varchar2(30) index by varchar2(30); 
    emp_arr emp_arr_type := emp_arr_type(); 
    emp_key varchar2(30); 
begin 
    emp_arr('A') := 'Santhosh'; 
    emp_arr('C') := 'Surendra'; 
    emp_arr('C') := 'Sony Priya'; 
    emp_arr('C') := 'Sony'; 
    emp_arr('F') := 'Sony yo'; 
    -- if emp_arr.exists('Z') then 
    -- dbms_output.put_line('HEY I AM THERE'); 
    -- else 
    -- dbms_output.put_line('NOT THERE'); 
    -- end if; 
    -- emp_key := emp_arr.last; 
    -- emp_Arr.delete; 
    -- dbms_output.put_line(emp_key); 
    -- emp_key := emp_Arr.first; 
    -- for idx in 1 .. emp_arr.count 
    -- loop 
    -- dbms_output.put_line(emp_key || ' ' || emp_arr(emp_key)); 
    -- emp_key := emp_Arr.next(emp_key); 
    -- end loop; 
    emp_key := emp_Arr.last; 
    for i in 1 .. emp_arr.count 
    loop 
        dbms_output.put_line(emp_key || ' ' || emp_Arr(emp_key)); 
       emp_key := emp_arr.prior(emp_key); 
    end loop; 
end;     
 
--VARRAY 
  
CREATE TYPE phone_numbers AS VARRAY(5) OF VARCHAR2(20); 
  
--Insert Values into a VARRAY: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    -- Insert statement not required as we're initializing the VARRAY directly. 
END; 
  
--Accessing Elements: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Second phone number: ' || p_numbers(2)); 
END; 
  
--Updating Values: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    p_numbers(3) := '999-999-9999'; 
END; 
  
--Deleting Values: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    p_numbers.DELETE(2); 
END; 
  
--Iterating Over VARRAY: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    FOR i IN 1..p_numbers.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('Phone number ' || i || ': ' || p_numbers(i)); 
    END LOOP; 
END; 
  
--VARRAY Length: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Number of phone numbers: ' || p_numbers.COUNT); 
END; 
  
--Clearing VARRAY: 
  
DECLARE 
    p_numbers phone_numbers := phone_numbers('123-456-7890', '987-654-3210', '555-555-5555'); 
BEGIN 
    p_numbers.DELETE; 
END; 
  
DROP TYPE phone_numbers; 
  
--NESTED TABLES 
 
DECLARE 
    TYPE CN IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    C_OLDS CN; 
    C_NEWS CN; 
BEGIN 
    FOR I IN (SELECT EMPLOYEE_ID,SALARY FROM OEHR_EMPLOYEES) LOOP 
        C_OLDS(I.EMPLOYEE_ID):=I.SALARY; 
        C_NEWS(I.EMPLOYEE_ID):=ROUND(I.SALARY*1.1,0); 
    END LOOP; 
  
    FOR I IN C_OLDS.FIRST..C_OLDS.LAST LOOP 
        DBMS_OUTPUT.PUT_LINE(I ||' '||'OLD SALARY: '||C_OLDS(I)||' NEW SALARY: '||C_NEWS(I)); 
    END LOOP; 
END; 
 
 
CREATE TYPE name_list IS TABLE OF VARCHAR2(100); 
  
DECLARE 
    names name_list := name_list('Alice', 'Bob', 'Charlie'); 
BEGIN 
    -- Add a new name 
    names.EXTEND; 
    names(names.LAST) := 'David'; 
  
    -- Iterate over the names 
    FOR i IN 1..names.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i)); 
    END LOOP; 
  
END;  
 
declare 
    emp_Arr emp_arr_type := emp_arr_type(); 
    emp_key number; 
begin 
    for employee in (select ename from emp) 
    loop 
        -- dbms_output.put_line(employee.ename); 
        emp_Arr.extend; 
        emp_arr(emp_arr.last) := employee.ename; 
        -- dbms_output.put_line(emp_arr.last); 
    end loop; 
    -- dbms_output.put_line(emp_arr.count); 
    -- emp_arr.extend; 
    -- emp_arr.extend; 
    -- emp_arr.extend; 
    -- dbms_output.put_line(emp_arr.count); 
    -- emp_arr(1) := 'Santhosh'; 
    -- emp_arr(2) := 'Sony'; 
    -- emp_arr(3) := 'Surendra'; 
    -- dbms_output.put_line(emp_arr(3)); 
    -- for idx in 1 .. emp_arr.count 
    -- loop 
    -- dbms_output.put_line(idx || ' ' || emp_arr(idx)); 
    -- end loop; 
    -- emp_arr.delete(emp_arr.first,emp_arr.last); 
    -- emp_key := emp_arr.first; 
    -- -- emp_key := emp_arr.next(emp_key); 
    -- while emp_key is not null 
    -- loop 
    --     dbms_output.put_line(emp_key || ' ' || emp_arr(emp_key)); 
    --     emp_key := emp_arr.next(emp_key); 
    -- end loop;      
    if isMemberOf(emp_arr, 'BLAKE') 
    then     
        dbms_output.put_line('HEY I AM THERE'); 
    else 
        dbms_output.put_line('HEY NOT THERE'); 
    end if;        
end; 
  
create or replace  type emp_arr_type is table of varchar2(30); 
  
create or replace function isMemberOf(emparr emp_arr_type, val  varchar2) 
return boolean 
is 
empkey number; 
begin 
    empkey := emparr.first; 
    for idx in 1..emparr.count 
    loop 
        if emparr(empkey) = val then 
            return TRUE; 
        else 
            empkey := emparr.next(empkey); 
        end if;             
    end loop;             
    return FALSE; 
end;     
 
declare 
type demo is table of employees%rowtype; 
e demo:=demo(); 
begin 
select * bulk collect into e from employees; 
for i in 1..e.count loop 
dbms_output.put_line(i||' - '||e(i).employee_id||' '||e(i).name); 
end loop; 
end; 
 
TRIGGERS 
--COMPOUND TRIGGER - BEFORE/AFTER STATEMENT LEVEL/ROW LEVEL 
CREATE OR REPLACE TRIGGER DEPT_SAL_TOT 
FOR UPDATE OF SALARY ON EMPLOYEES  
COMPOUND TRIGGER 
TOT NUMBER :=0; 
D NUMBER:=0; 
BEFORE EACH ROW IS 
    BEGIN 
        TOT:= TOT- :OLD.SALARY; 
    END BEFORE EACH ROW; 
AFTER EACH ROW IS 
    BEGIN 
        TOT:= TOT+ :NEW.SALARY; 
        D:=:NEW.DEPARTMENTID; 
    END AFTER EACH ROW; 
AFTER STATEMENT IS 
    BEGIN 
        UPDATE DEPARTMENT_SALARY 
        SET TOTAL_SALARY=TOTAL_SALARY+TOT 
        WHERE DEPARTMENT_ID = D; 
    END AFTER STATEMENT; 
END DEPT_SAL_TOT; 
  
UPDATE EMPLOYEES SET SALARY=SALARY+1 WHERE DEPARTMENTID=2 
  
select * from employees 
select * from department_salary 
-- Create department_salary table 
CREATE TABLE department_salary ( 
    department_id NUMBER PRIMARY KEY, 
    total_salary NUMBER 
); 
  
-- Insert initial total salaries for departments 
INSERT INTO department_salary (department_id, total_salary) 
VALUES (1, 2680); 
  
INSERT INTO department_salary (department_id, total_salary) 
VALUES (2, 600); 
  
DELETE FROM DEPARTMENT_SALARY WHERE DEPARTMENT_ID=1 
--ROW LEVEL TIGGER 
  
--WRITE TRIGGER SO THAT USER CANNOT PERFORM DML OPERATIONS ON WEEKENDS AND TIME 9 TO 8 
CREATE OR REPLACE TRIGGER TRIG_DML 
BEFORE INSERT OR DELETE OR UPDATE ON EMPLOYEES 
BEGIN 
    IF TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN') OR TO_CHAR(SYSDATE,'HH24') BETWEEN 19 AND 8 THEN 
        RAISE_APPLICATION_ERROR(-20201,'CANNOT WORK ON WEEKENDS OR AFTER WORKING HOURS'); 
    END IF; 
END; 
  
CREATE TABLE EMP_LOG (USERS VARCHAR(100),DATES DATE,OPERATION VARCHAR(100)); 
SELECT * FROM EMP_LOG 
  
CREATE OR REPLACE TRIGGER IN_EMP  
AFTER INSERT OR UPDATE OR DELETE ON EMPLOYEES 
BEGIN 
IF INSERTING THEN 
    INSERT INTO EMP_LOG VALUES(USER,SYSDATE,'INSERT'); 
    DBMS_OUTPUT.PUT_LINE('INSERTED SUCCESSFULLY'); 
ELSIF UPDATING THEN 
    INSERT INTO EMP_LOG VALUES(USER,SYSDATE,'UPDATE'); 
    DBMS_OUTPUT.PUT_LINE('UPDATED SUCCESSFULLY'); 
ELSE 
    INSERT INTO EMP_LOG VALUES(USER,SYSDATE,'DELETE'); 
    DBMS_OUTPUT.PUT_LINE('DELETED SUCCESSFULLY'); 
END IF; 
END; 
  
INSERT INTO EMPLOYEES VALUES(7,'Jack','Smith',1276543210,2,1,700,'05-14-2014'); 
UPDATE EMPLOYEES SET SALARY=SALARY-50 WHERE ID!=5 
SELECT * FROM EMPLOYEES 
DELETE FROM EMPLOYEES WHERE ID=7 
  
--DDL - DATABASE 
  
CREATE OR REPLACE TRIGGER DDL_TRI 
BEFORE DROP ON SCHEMA --SCHEMA OR DATABASE(IF YOU DROP SEQUENCE,VIEWS ECT.. THEN THIS TRIGGER IS EXECTED) 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('DROPPED'); 
END  
 
REF CURSORS 
--STRONG REF CURSOR-FIXED RETUEN TYPE 
DECLARE 
    TYPE CURSOR1 IS REF CURSOR RETURN OEHR_EMPLOYEES%ROWTYPE; 
    C CURSOR1; 
    R OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    OPEN C FOR SELECT * FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=100; 
    FETCH C INTO R; 
    CLOSE C; 
    DBMS_OUTPUT.PUT_LINE(R.FIRST_NAME||' '||R.LAST_NAME); 
END; 
  
DECLARE 
    TYPE RE IS RECORD( SAL OEHR_EMPLOYEES.SALARY%TYPE ); 
    TYPE CURSOR1 IS REF CURSOR RETURN RE; 
    C CURSOR1; 
    R OEHR_EMPLOYEES.SALARY%TYPE; 
BEGIN 
    OPEN C FOR SELECT SALARY FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=100; 
    FETCH C INTO R; 
    CLOSE C; 
    DBMS_OUTPUT.PUT_LINE(R); 
END; 
  
--WEAK REF CURSOR 
  
DECLARE 
    TYPE CURSOR1 IS REF CURSOR; 
    C CURSOR1; 
    FN OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    LN OEHR_EMPLOYEES.LAST_NAME%TYPE; 
BEGIN 
    OPEN C FOR SELECT FIRST_NAME,LAST_NAME FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=100; 
    FETCH C INTO FN,LN; 
    CLOSE C; 
    DBMS_OUTPUT.PUT_LINE(FN||' '||LN); 
END; 
  
--SYS REFCURSOR 
  
DECLARE 
    C SYS_REFCURSOR; 
    FN OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    LN OEHR_EMPLOYEES.LAST_NAME%TYPE; 
BEGIN 
    OPEN C FOR SELECT FIRST_NAME,LAST_NAME FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=100; 
    FETCH C INTO FN,LN; 
    CLOSE C; 
    DBMS_OUTPUT.PUT_LINE(FN||' '||LN); 
END; 
  
--ref cursor 
  
create or replace procedure prtemp(a in out sys_refcursor) 
is 
name employee.ename%type; 
sal employee.salary%type; 
begin 
loop 
fetch a into name,sal; 
exit when a%notfound; 
dbms_output.put_line(name||' earns '||sal||' per month'); 
end loop; 
end; 
  
declare 
--type k is ref cursor; 
dat sys_refcursor; --dat k 
begin 
open dat for select ename,salary from employee; 
prtemp(dat); 
close dat; 
end; 
select * from employee 
  
  
create or replace function refemp(d in employee.dept%type) return sys_refcursor 
as 
c sys_refcursor; 
begin 
open c for select emid,ename from employee where dept=d; 
return c; 
end; 
  
declare 
cur sys_refcursor; 
id employee.emid%type; 
name employee.ename%type; 
begin 
cur:=refemp('CSE'); 
loop 
fetch cur into id,name; 
exit when cur%notfound; 
dbms_output.put_line(id||' - '||name); 
end loop; 
close cur; 
end; 
  
  
/*create or replace procedure empcur (a in out sys_refcursor) 
is 
name employee.ename%type; 
emid employee.emid%type; 
begin 
loop 
fetch a into name,emid; 
exit when a%notfound; 
dbms_output.put_line('name '||name||' id is '||emid); 
end loop; 
end; 
  
declare 
a sys_refcursor; 
begin 
open a for select ename,emid from employee; 
empcur(a); 
close a; 
end; */  
 
CURSORS 
BEGIN 
    DELETE FROM EMPLOYEES WHERE ID=6; 
    DBMS_OUTPUT.PUT_LINE('ROWS DELETED '||SQL%ROWCOUNT); 
END; 
  
  
/*Cursor (Employee Commission): Write a PL/SQL block that declares a cursor to fetch employees who earn a commission (COMM is not null).  
Use a FOR loop to iterate through the cursor and display the employee details (EMPNO, ENAME, COMM) with appropriate labels.*/ 
SELECT * FROM OEHR_EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL; 
  
DECLARE 
    CURSOR COMM IS SELECT * FROM OEHR_EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL; 
    C NUMBER:=0; 
BEGIN 
    FOR I IN COMM LOOP 
        DBMS_OUTPUT.PUT_LINE(I.EMPLOYEE_ID||' NAME: '||I.FIRST_NAME||' '||I.LAST_NAME||' COMMISSION: '||I.COMMISSION_PCT); 
        C:=C+1; 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE(C||' RECEIVING COMMISSION'); 
END; 
  
  
--Write a PL/SQL block to retrieve the names and salaries of employees from the employees table using a cursor. 
DECLARE 
CURSOR EMPNS IS SELECT FIRST_NAME,LAST_NAME,SALARY FROM OEHR_EMPLOYEES; 
F OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
L OEHR_EMPLOYEES.LAST_NAME%TYPE; 
S OEHR_EMPLOYEES.SALARY%TYPE; 
BEGIN 
    OPEN EMPNS; 
    LOOP 
        FETCH EMPNS INTO F,L,S; 
        DBMS_OUTPUT.PUT_LINE('NAME: '||F||' '||L||' || SALARY: '||S); 
        EXIT WHEN EMPNS%NOTFOUND; 
    END LOOP; 
    CLOSE EMPNS; 
END; 
  
--Write a PL/SQL block to calculate the average salary of employees. 
DECLARE 
CURSOR EMPNS IS SELECT AVG(SALARY) FROM OEHR_EMPLOYEES; 
S OEHR_EMPLOYEES.SALARY%TYPE; 
BEGIN 
    OPEN EMPNS; 
    FETCH EMPNS INTO S; 
    DBMS_OUTPUT.PUT_LINE('AVG SALARY: '||S); 
    CLOSE EMPNS; 
END;  
  
select * from employee; 
  
update employee set age=30, salary=80000 where ename='RAJU'; 
update employee set salary=salary-30000 
  
declare 
name employee.ename%type; 
sal employee.salary%type; 
deptm employee.dept%type; 
cursor emp is select ename,salary,dept from employee where dept='CSE'; 
begin 
open emp; 
loop 
fetch emp into name,sal,deptm; 
exit when emp%notfound; 
dbms_output.put_line(name||' Salary= '||sal||' '||deptm); 
end loop; 
close emp; 
end; 
  
declare 
cursor empcur is select * from employee; 
k employee%rowtype; 
begin 
open empcur; 
loop 
fetch empcur into k; 
exit when empcur%notfound; 
dbms_output.put_line('employee name of id '||k.emid||' is '||k.ename); 
end loop; 
close empcur; 
end;  
 
PROCEDURES 
/*Subprograms (Procedure - Bonus Calculation): Create a PL/SQL procedure that takes an employee number and a bonus amount as input.  
Inside the procedure, update the employee's salary in the EMP table by adding the bonus amount (use UPDATE).  
Print a message indicating successful updation or an error message if the employee is not found.*/ 
CREATE OR REPLACE PROCEDURE BONUSCAL(EN NUMBER,B NUMBER) 
AS 
BEGIN 
    UPDATE EMPLOYEES SET SALARY=SALARY+B WHERE ID=EN; 
    DBMS_OUTPUT.PUT_LINE('SALARY UPDATED SUCCESSFULLY'); 
END; 
  
BEGIN 
BONUSCAL(1,30); 
END; 
SELECT * FROM EMPLOYEES; 
--FIND AVG,TOTAL,RESULT FOR STUDENT, RESULT MUST BE PASS OR FAIL 
  
CREATE TABLE STUDENT(ID NUMBER, 
                     NAME VARCHAR(30), 
                     S1 NUMBER, 
                     S2 NUMBER, 
                     S3 NUMBER); 
  
INSERT INTO STUDENT VALUES(1,'SONY',56,89,78) 
INSERT INTO STUDENT VALUES(2,'JANU',34,45,48) 
  
CREATE OR REPLACE PROCEDURE STU_REPORT AS 
    S1 STUDENT.S1%TYPE; 
    S2 STUDENT.S2%TYPE; 
    S3 STUDENT.S3%TYPE; 
    AVGS NUMBER(10,2); 
    TOT NUMBER; 
    RESULT VARCHAR(30); 
BEGIN 
  
    FOR I IN (SELECT * FROM STUDENT) LOOP 
        S1:=I.S1; 
        S2:=I.S2; 
        S3:=I.S3; 
        TOT:=S1+S2+S3; 
        AVGS:=TOT/3; 
        RESULT:= CASE WHEN S1>=35 AND S2>=35 AND S3>=35 THEN 'PASS' ELSE 'FAIL' END; 
        DBMS_OUTPUT.PUT_LINE('ID: '||I.ID||' NAME: '||I.NAME||' AVG: '||AVGS||' TOTAL: '||TOT||' RESULT: '||RESULT); 
    END LOOP; 
END; 
  
BEGIN 
STU_REPORT(); 
END; 
  
  
  
--Write a PL/SQL stored procedure to insert a new employee record into the employees table. 
SELECT * FROM EMPLOYEES 
CREATE OR REPLACE PROCEDURE INEMP( 
    P1 EMPLOYEES.ID%TYPE, 
    P2 EMPLOYEES.FNAME%TYPE, 
    P3 EMPLOYEES.LNAME%TYPE, 
    P4 EMPLOYEES.PHONENUMBER%TYPE, 
    P5 EMPLOYEES.MANAGERID%TYPE, 
    P6 EMPLOYEES.DEPARTMENTID%TYPE, 
    P7 EMPLOYEES.SALARY%TYPE, 
    P8 EMPLOYEES.HIREDATE%TYPE) 
AS 
BEGIN 
INSERT INTO EMPLOYEES VALUES(P1,P2,P3,P4,P5,P6,P7,P8); 
END; 
  
BEGIN 
INEMP(6,'Rohn','Johnson',1234997890,2,1,400,to_date('7-08-2005','DD-MM-YYYY')); 
END; 
  
--Increment 15% for the employees who have 5000 sal ,10% for the employees have sal between 5000 and 10000,5% for the employees who have more than 10000 
SELECT SALARY FROM OEHR_EMPLOYEES GROUP BY SALARY ORDER BY SALARY 
SELECT * FROM OEHR_EMPLOYEES 
  
CREATE OR REPLACE PROCEDURE INCEMPSAL AS 
E OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    FOR I IN (SELECT * FROM OEHR_EMPLOYEES) 
    LOOP 
    E:=I; 
    IF E.SALARY<=5000 THEN 
        E.SALARY:=E.SALARY*1.15; 
    ELSIF (E.SALARY>=5000 AND E.SALARY<=10000) THEN 
        E.SALARY:=E.SALARY*1.1; 
    ELSE 
        E.SALARY:=E.SALARY*1.05; 
    END IF; 
    DBMS_OUTPUT.PUT_LINE('ID: '||I.EMPLOYEE_ID||' NAME: '||I.FIRST_NAME||' '||I.LAST_NAME||' SALARY: '||E.SALARY); 
    END LOOP; 
END; 
  
BEGIN 
INCEMPSAL(); 
END; 
  
/* 
1. Write a procedure named GetEmployeeInfo that takes an employee ID as input and returns the employee's first name, last name,  
department name, and manager's name. 
*/ 
CREATE OR REPLACE PROCEDURE GETEMPINFO(N IN EMPLOYEES.ID%TYPE) 
AS 
FN EMPLOYEES.FNAME%TYPE; 
LN1 EMPLOYEES.LNAME%TYPE; 
DN DEPARTMENTS.NAME%TYPE; 
MN VARCHAR(100); 
MN2 VARCHAR(100); 
BEGIN 
SELECT E.FNAME,E.LNAME,D.NAME,M.FNAME,M.LNAME INTO FN,LN1,DN,MN,MN2  
FROM EMPLOYEES E  
JOIN DEPARTMENTS D ON E.DEPARTMENTID=D.ID  
JOIN EMPLOYEES M ON M.ID=E.MANAGERID  
WHERE E.ID=N; 
  
DBMS_OUTPUT.PUT_LINE('First Name: '||FN); 
DBMS_OUTPUT.PUT_LINE('Last Name: '||LN1); 
DBMS_OUTPUT.PUT_LINE('Departent Name: '||DN); 
DBMS_OUTPUT.PUT_LINE('Manager Name: '||MN||' '||MN2); 
END; 
  
BEGIN 
GETEMPINFO(2); 
END; 
  
create or replace procedure addg(a in number,b in number) 
is 
c number; 
begin 
c :=a+b; 
dbms_output.put_line('The addition of '||a||' and '||b||' is '||c); 
end; 
  
begin 
addg(26,28); 
end; 
  
declare 
a number:=90; 
b number:=983; 
--c number; 
begin 
addg(a,b); 
end; 
  
create or replace procedure addg(a in number,b in number, c out number) 
is 
begin 
c :=a+b; 
dbms_output.put_line('The addition of '||a||' and '||b||' is '||c); 
end; 
  
declare 
a number; 
begin 
addg(5,6,a); 
end; 
  
declare 
a number:=99; 
b number:=1; 
c number; 
begin 
addg(a,b,c);  
dbms_output.put_line(c); 
end; 
  
declare 
a number; 
b number; 
c number; 
begin 
addg(:a,:b,c); --a and b are bind variables 
end; 
  
select * from employee; 
create or replace procedure incrememployee(a in number) 
is 
begin 
update employee set salary=salary+a; 
end; 
  
declare 
a number; 
begin 
incrememployee(:a); 
end; 
  
begin 
incrememployee(6); 
end; 
  
select ename,salary from employee; 
  
create or replace procedure fact( n number) 
is 
c number:=1; 
begin 
for i in 1..n 
loop 
c:=c*i; 
end loop; 
dbms_output.put_line(c); 
end; 
  
  
begin 
fact(5); 
end; 
  
create or replace procedure factn(n number) 
is 
r number:=1; 
k number:=n; 
begin 
while k>0 
loop 
r:=r*k; 
k:=k-1; 
end loop; 
dbms_output.put_line(r); 
end; 
  
begin 
factn(5); 
end; 
  
create or replace procedure sqr(a in out number) 
as  
begin 
    a:=a*a; 
end; 
  
declare 
    a number:=6; 
begin 
sqr(a); 
dbms_output.put_line(a); 
end;  
 
FUNCTIONS 
/*Subprograms (Function - Department Head): Create a PL/SQL function that takes a department number as input.  
Inside the function, find the employee with the highest salary in that department (use appropriate aggregation functions in SELECT). 
Return the employee number (EMPNO) of the department head (highest salary).*/ 
 
CREATE OR REPLACE FUNCTION DEPTHEAD (D NUMBER) RETURN NUMBER 
AS 
    EM OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE; 
BEGIN 
    SELECT EMPLOYEE_ID INTO EM FROM OEHR_EMPLOYEES WHERE SALARY = (SELECT MAX(SALARY) FROM OEHR_EMPLOYEES WHERE DEPARTMENT_ID=D); 
    RETURN EM; 
END; 
  
DECLARE 
D NUMBER:=90; 
BEGIN 
DBMS_OUTPUT.PUT_LINE(DEPTHEAD(D)); 
END; 
  
SELECT * FROM OEHR_EMPLOYEES; 
  
CREATE OR REPLACE FUNCTION ADDITION(X NUMBER,Y NUMBER,Z NUMBER) RETURN NUMBER 
IS 
BEGIN 
    RETURN X+Y+Z; 
END; 
  
SELECT ID,ADDITION(S1,S2,S3),CASE WHEN S1>=35 AND S2>=35  AND S3>=35 THEN 'PASS' ELSE 'FAIL' END AS REPORT FROM STUDENT; 
  
--FUNCTION TO RETURN FACTORIAL OF A NUMBER 
CREATE OR REPLACE FUNCTION FACTO(N NUMBER) RETURN NUMBER AS 
    NUM NUMBER:=1; 
BEGIN 
    FOR I IN 1..N LOOP 
        NUM:=NUM*I; 
    END LOOP; 
    RETURN NUM; 
END; 
  
DECLARE 
    N NUMBER; 
BEGIN 
    N:=FACTO(4); 
    DBMS_OUTPUT.PUT_LINE('FACTORIAL OF A NUMBER IS '||N); 
END; 
  
--FUNCTION TO RETURN MULTIPLE COLUMNS 
CREATE OR REPLACE FUNCTION GET_EMP(ID OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN OEHR_EMPLOYEES%ROWTYPE 
AS 
    E OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    SELECT * INTO E FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=ID; 
    RETURN E; 
END; 
  
DECLARE 
    E OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    E:=GET_EMP(1); 
    DBMS_OUTPUT.PUT_LINE('NAME: '||E.FIRST_NAME||' '||E.LAST_NAME||' SALARY: '||E.SALARY); 
    EXCEPTION   
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Employee not found'); 
END; 
  
--FUNCTION TO RETURN MULTIPLE RECORDS 
CREATE OR REPLACE TYPE EMP_REC AS OBJECT( 
    EMPLOYEE_ID INTEGER, 
    FIRST_NAME VARCHAR2(100), 
    LAST_NAME VARCHAR2(100), 
    SALARY NUMBER 
); 
CREATE OR REPLACE TYPE EMP_TABLE AS TABLE OF EMP_REC; 
  
CREATE OR REPLACE FUNCTION GET_EMPLOYEES RETURN EMP_TABLE 
IS 
    E EMP_TABLE:=EMP_TABLE(); 
BEGIN 
    FOR I IN (SELECT EMPLOYEE_ID,FIRST_NAME,LAST_NAME,SALARY FROM OEHR_EMPLOYEES) 
    LOOP 
    E.EXTEND; 
    IF I.SALARY>5000 THEN 
    E(E.COUNT):=EMP_REC(I.EMPLOYEE_ID,I.FIRST_NAME,I.LAST_NAME,I.SALARY); 
    END IF; 
    END LOOP; 
    RETURN E; 
END; 
  
DECLARE 
    E EMP_TABLE; 
BEGIN 
    E:=GET_EMPLOYEES; 
    FOR I IN 1..(E.COUNT) LOOP 
        IF E(I).EMPLOYEE_ID IS NOT NULL THEN 
        DBMS_OUTPUT.PUT_LINE('ID '||E(I).EMPLOYEE_ID||' NAME: '||E(I).FIRST_NAME||' '||E(I).LAST_NAME||' SAL: '||E(I).SALARY); 
        END IF; 
    END LOOP; 
END; 
  
--Write a PL/SQL function to calculate the bonus amount based on an employee's salary. 
CREATE OR REPLACE FUNCTION EMPBONUS(ID OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN VARCHAR2 IS 
    S OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE; 
    K VARCHAR(30); 
BEGIN  
    SELECT SALARY INTO S FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=ID; 
    IF S<=5000 THEN 
        K:='15 %'; 
    ELSIF S>=5000 AND S<=10000 THEN 
        K:='10 %'; 
    ELSE 
        K:='5 %'; 
    END IF; 
    RETURN K; 
END; 
  
DECLARE 
S VARCHAR(30); 
BEGIN 
S:=EMPBONUS(100); 
DBMS_OUTPUT.PUT_LINE(S); 
END;  
 
PLSQL BLOCKS 
 
/*FOR Loop (Employee Details): Write a PL/SQL block that uses a FOR loop to iterate through each employee in the EMP table.  
Inside the loop, print the employee number (EMPNO), name (ENAME), and job title (JOB).*/ 
 
BEGIN 
    FOR I IN (SELECT E.EMPLOYEE_ID AS EMPLOYEE_ID,E.FIRST_NAME||' '||E.LAST_NAME AS NAME,J.JOB_TITLE AS JOB FROM OEHR_EMPLOYEES E INNER JOIN OEHR_JOBS J ON E.JOB_ID=J.JOB_ID) LOOP 
        DBMS_OUTPUT.PUT_LINE(I.EMPLOYEE_ID|| ' NAME: '||I.NAME||' JOB: '||I.JOB); 
    END LOOP; 
END; 
  
/*WHILE Loop (Salary Threshold): Write a PL/SQL block that prompts the user for a salary amount. 
Use a WHILE loop to iterate through employees in the EMP table. Inside the loop,  
stop iterating (using EXIT) once you encounter an employee with a salary less than the user-provided threshold.  
Print details (EMPNO, ENAME, SAL) of employees exceeding the threshold.*/ 
 
DECLARE 
    ENO OEHR_EMPLOYEES.EMPLOYEE_ID%TYPE:=:ID; 
    NAME OEHR_EMPLOYEES.FIRST_NAME%TYPE; 
    SAL OEHR_EMPLOYEES.SALARY%TYPE; 
    --C NUMBER; 
BEGIN 
    WHILE TRUE LOOP 
        SELECT EMPLOYEE_ID,FIRST_NAME,SALARY INTO ENO,NAME,SAL FROM OEHR_EMPLOYEES WHERE EMPLOYEE_ID=ENO; 
        DBMS_OUTPUT.PUT_LINE(ENO||NAME||SAL); 
        EXIT WHEN SQL%FOUND; 
    END LOOP; 
END; 
  
/*IF-ELSE (Manager Check): Write a PL/SQL block that prompts the user for an employee number.  
Use an IF statement to check if the employee has a manager (MGR is not null). If a manager exists,  
use another SELECT statement to retrieve the manager's name (use MGR and another SELECT from EMP).  
Print the employee's name and manager's name. Otherwise, print a message indicating the employee has no manager.*/ 
 
  
BEGIN 
    FOR I IN (SELECT E.FIRST_NAME||' '||E.LAST_NAME AS EMPLOYEE_NAME,M.LAST_NAME AS MANAGER_NAME  
             FROM OEHR_EMPLOYEES E  
             LEFT JOIN OEHR_EMPLOYEES M ON M.EMPLOYEE_ID=E.MANAGER_ID) 
    LOOP 
        IF I.MANAGER_NAME IS NULL THEN 
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE_NAME: '||I.EMPLOYEE_NAME|| ' MANAGER_NAME: EMPLOYEE HAS NO MANAGER');    
        ELSE 
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE_NAME: '||I.EMPLOYEE_NAME|| ' MANAGER_NAME: '||I.MANAGER_NAME); 
        END IF; 
    END LOOP; 
END;   
  
/*CASE WHEN (Department Analysis): Write a PL/SQL block that retrieves department information for all employees. 
Use a CASE WHEN expression within the SELECT statement to categorize employees based on their department number (DEPTNO).  
For example, print "Sales" for department 10, "Marketing" for department 20, and "Others" for any other department. 
Print department names along with employee details (EMPNO, ENAME).*/ 
  
BEGIN 
    FOR I IN (SELECT EMPLOYEE_ID,FIRST_NAME,LAST_NAME,DEPARTMENT_ID FROM OEHR_EMPLOYEES) 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(I.EMPLOYEE_ID|| ' '||' NAME: '||I.FIRST_NAME||' '||I.LAST_NAME||' DEPT NAME: '||CASE WHEN I.DEPARTMENT_ID=10 THEN 'SALES' 
                                                                                                                  WHEN I.DEPARTMENT_ID=20 THEN 'MARKETING' 
                                                                                                                  ELSE 'OTHERS' END); 
    END LOOP; 
END; 
  
SELECT * FROM OEHR_EMPLOYEES 
 
--Write a PL/SQL block to retrieve the count of records in a table named employees. 
DECLARE 
C NUMBER; 
BEGIN 
    SELECT COUNT(*) INTO C FROM OEHR_EMPLOYEES; 
    DBMS_OUTPUT.PUT_LINE(C); 
END; 
  
--Write a PL/SQL block to update the salary of an employee with a specific ID. 
 
 
DECLARE 
    ID NUMBER:=100; 
BEGIN 
    UPDATE OEHR_EMPLOYEES SET SALARY=SALARY+1 WHERE EMPLOYEE_ID=ID; 
    DBMS_OUTPUT.PUT_LINE(ID); 
END; 
SELECT * FROM OEHR_EMPLOYEES 
  
--Write a PL/SQL block to find the maximum salary from the employees table. 
 
DECLARE 
    M NUMBER:=0; 
BEGIN 
    FOR I IN (SELECT SALARY FROM OEHR_EMPLOYEES) LOOP 
    IF M<I.SALARY THEN 
        M:=I.SALARY; 
    END IF; 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE(M); 
END; 
  
--Write a PL/SQL block to calculate the factorial of a given number using a loop. 
 
DECLARE 
    N NUMBER:=4; 
    RES NUMBER:=1; 
BEGIN 
    FOR I IN 1..N LOOP 
        RES:=RES*I; 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE(RES); 
END;   
  
--1. Write a PL/SQL block to calculate the incentive of an employee whose ID is 110. 
 
declare 
    k number; 
    n oehr_employees.first_name%type; 
begin 
    select salary*0.12,first_name into k,n from oehr_employees where employee_id=110; 
    dbms_output.put_line('incentive of employee '||n||' is '||k); 
end; 
  
--Write a PL/SQL block to show an invalid case-insensitive reference to a quoted and without quoted user-defined identifier. 
  
declare 
"WELCOME" varchar(30):='welcome'; 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(welcome); 
    DBMS_OUTPUT.PUT_LINE(Welcome); 
    DBMS_OUTPUT.PUT_LINE(WELCOME); 
    DBMS_OUTPUT.PUT_LINE("WELCOME"); 
end; 
  
--Write a PL/SQL block to show a reserved word can be used as a user-define identifier. 
DECLARE 
  "DECLARE" varchar2(25) := 'This is UPPERCASE'; 
  "Declare" varchar2(25) := 'This is Proper Case'; 
  "declare" varchar2(25) := 'This is lowercase'; 
BEGIN 
  DBMS_Output.Put_Line("DECLARE"); 
  DBMS_Output.Put_Line("Declare"); 
  DBMS_Output.Put_Line("declare"); 
END; 
 
INDEXES 
CREATE TABLE DATA1(ID INT, 
                   NAME VARCHAR(30)) 
  
INSERT ALL  
    INTO DATA1 (ID, NAME) VALUES (1, 'Frame') 
    INTO DATA1 (ID, NAME) VALUES (2, 'Head Tube') 
    INTO DATA1 (ID, NAME) VALUES (3, 'Handlebar Grip') 
    INTO DATA1 (ID, NAME) VALUES (4, 'Shock Absorber') 
    INTO DATA1 (ID, NAME) VALUES (5, 'Fork') 
SELECT * FROM dual; 
  
-- CLUSTERED INDEX 
--Oracle does not support clustered indexes in the same way as SQL Server. 
  
-- NON-CLUSTERED INDEX 
CREATE INDEX DEPT_INDEX ON EMPLOYEES(DEPARTMENTID); 
  
-- SELECT Statement 
SELECT FNAME FROM EMPLOYEES WHERE DEPARTMENTID = 1; 
  
-- RENAME INDEX 
ALTER INDEX DEPT_INDEX RENAME TO D_INDEX; 
  
-- UNIQUE INDEX 
CREATE UNIQUE INDEX E_INDEX ON CUSTOMERS(EMAIL); 
  
-- DISABLE INDEX 
ALTER INDEX D_INDEX UNUSABLE; 
  
-- ENABLE INDEX 
ALTER INDEX D_INDEX REBUILD; 
  
-- DROP INDEX 
DROP INDEX E_INDEX; 
  
-- INDEXES WITH INCLUDED COLUMNS 
-- Oracle doesn't support included columns directly,  
-- but you can achieve similar functionality using composite indexes. 
CREATE INDEX E_INDEX ON CUSTOMERS(EMAIL, FNAME, LNAME); 
  
-- FILTERED INDEX 
-- Oracle doesn't support filtered indexes directly. 
-- You can use a function-based index to achieve similar functionality. 
CREATE INDEX M_INDEX ON EMPLOYEES (CASE WHEN MANAGERID IS NOT NULL THEN MANAGERID END); 
  
  
-- INDEXES ON COMPUTED COLUMNS 
-- Oracle supports function-based indexes for computed columns. 
-- First, add the computed column to the table. 
  
ALTER TABLE CUSTOMERS ADD (email_local_part VARCHAR2(400) AS (SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1))); 
CREATE INDEX ELP_INDEX ON CUSTOMERS(email_local_part); 
select * from customers 
  
create table accounts( 
    acc_no int primary key, 
    name varchar2(30) not null, 
    balance number(10,2) 
); 
  
INSERT INTO accounts values(101,'A', 25000); 
INSERT INTO accounts values(102,'B', 55000); 
INSERT INTO accounts values(103,'C', 50000); 
INSERT INTO accounts values(104,'D', 75000); 
INSERT INTO accounts values(105,'E', 5000); 
INSERT INTO accounts values(106,'F', 7500); 
INSERT INTO accounts values(107,'G', 2500); 
  
  
create table transactions( 
    t_id int, 
    acc_no int, 
    t_date date, 
    amount int, 
    balance number(10,2) 
); 
  
  
drop table transactions; 
alter table transactions  
add t_type char(1); 
  
DROP trigger t_upd; 
  
drop sequence s1; 
  
create sequence s1 
    START WITH 1 
    INCREMENT BY 1 
    NOCACHE 
    NOCYCLE; 
  
  
CREATE OR REPLACE TRIGGER t_upd 
AFTER UPDATE ON accounts 
FOR EACH ROW 
DECLARE 
    v_transaction_type VARCHAR2(1); 
BEGIN 
     
    -- Determine transaction type 
    IF :new.balance > :old.balance THEN 
        v_transaction_type := 'C'; 
    ELSE 
        v_transaction_type := 'D'; 
    END IF; 
     
    -- Insert into transactions table 
    INSERT INTO transactions(t_id, acc_no, t_date, amount, balance, t_type) 
    VALUES(s1.nextval, :new.acc_no, sysdate, ABS(:new.balance - :old.balance), :new.balance, v_transaction_type); 
END; 
/ 
  
update accounts set balance=balance*1.2 where balance<=10000 
select * from transactions; 
truncate table transactions; 
 
-- Customers Table 
CREATE TABLE Customers1 ( 
    CustomerID INT PRIMARY KEY, 
    Name VARCHAR(100), 
    Email VARCHAR(100), 
    Address VARCHAR(255), 
    PhoneNumber VARCHAR(20) 
); 
  
-- Products Table 
CREATE TABLE Products1 ( 
    ProductID INT PRIMARY KEY, 
    Name VARCHAR(100), 
    Description VARCHAR(255), 
    Price DECIMAL(10, 2) 
); 
  
-- Purchases Table 
CREATE TABLE Purchases1 ( 
    PurchaseID INT PRIMARY KEY, 
    CustomerID INT, 
    ProductID INT, 
    PurchaseDate DATE, 
    Quantity INT, 
    TotalPrice DECIMAL(10, 2), 
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID), 
    FOREIGN KEY (ProductID) REFERENCES Products1(ProductID) 
); 
  
  
INSERT INTO Customers1  (CustomerID, Name, Email, Address, PhoneNumber) VALUES (1, 'John Doe', 'john.doe@example.com', '123 Main St, Anytown', '123-456-7890'); 
INSERT ALL 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (2, 'Jane Smith', 'jane.smith@example.com', '456 Oak St, Othertown', '987-654-3210') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (3, 'Alice Johnson', 'alice.johnson@example.com', '789 Elm St, Anothertown', '555-123-4567') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (4, 'Bob Williams', 'bob.williams@example.com', '321 Pine St, Yetanothertown', '555-987-6543') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (5, 'Emily Brown', 'emily.brown@example.com', '456 Maple St, Somewhereville', '555-789-1234') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (6, 'Michael Johnson', 'michael.johnson@example.com', '789 Elm St, Anothertown', '555-123-4567') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (7, 'Sarah Williams', 'sarah.williams@example.com', '321 Pine St, Yetanothertown', '555-987-6543') 
    INTO Customers1 (CustomerID, Name, Email, Address, PhoneNumber) VALUES (8, 'David Brown', 'david.brown@example.com', '456 Maple St, Somewhereville', '555-789-1234') 
SELECT * FROM Customers1; 
  
INSERT INTO Products1 (ProductID, Name, Description, Price) VALUES (101, 'Milk', 'Fresh cow milk', 2.49); 
INSERT ALL 
    INTO Products1 (ProductID, Name, Description, Price) VALUES (102, 'Curd', 'Thick and creamy yogurt', 3.99) 
    INTO Products1 (ProductID, Name, Description, Price) VALUES (103, 'Cheese', 'Aged cheddar cheese', 5.99) 
    INTO Products1 (ProductID, Name, Description, Price) VALUES (104, 'Eggs', 'Organic farm-fresh eggs', 2.99) 
    INTO Products1 (ProductID, Name, Description, Price) VALUES (105, 'Bread', 'Whole wheat bread loaf', 3.49) 
    INTO Products1 (ProductID, Name, Description, Price) VALUES (106, 'Butter', 'Salted butter', 4.99) 
SELECT * FROM products1; 
  
INSERT INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1001, 1, 102, TO_DATE('2024-05-26', 'YYYY-MM-DD'), 2, 7.98) 
INSERT INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1009, 1, 106, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 1, 4.99) 
INSERT INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1010, 1, 105, TO_DATE('2024-06-04', 'YYYY-MM-DD'), 1, 3.49) 
  
INSERT ALL 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1002, 2, 103, TO_DATE('2024-05-27', 'YYYY-MM-DD'), 1, 5.99) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1003, 3, 101, TO_DATE('2024-05-28', 'YYYY-MM-DD'), 3, 7.47) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1004, 4, 102, TO_DATE('2024-05-29', 'YYYY-MM-DD'), 2, 7.98) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1005, 5, 103, TO_DATE('2024-05-30', 'YYYY-MM-DD'), 1, 5.99) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1006, 6, 104, TO_DATE('2024-05-31', 'YYYY-MM-DD'), 2, 5.98) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1007, 7, 105, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 1, 3.49) 
    INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1008, 8, 106, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 1, 4.99) 
SELECT * FROM purchases1; 
  
--Query 1: Total Revenue by Product: 
/*Write a PL/SQL block to calculate the total revenue generated by each product. Use a cursor to iterate through the Products table  
and calculate the total revenue for each product based on the quantity sold and the price. implement a trigger to update the total revenue automatically whenever a new purchase is made.*/ 
 
  
DECLARE 
    CURSOR  REVENUE IS SELECT NAME,PRODUCTID FROM PRODUCTS1; 
    TOT_RVE NUMBER; 
BEGIN 
    FOR I IN REVENUE LOOP 
        SELECT SUM(P.PRICE * P1.QUANTITY) INTO TOT_RVE FROM PRODUCTS1 P  
        JOIN PURCHASES1 P1 ON P.PRODUCTID=P1.PRODUCTID  
        WHERE P.PRODUCTID=I.PRODUCTID; 
    DBMS_OUTPUT.PUT_LINE('PRODUCT ID: '||I.PRODUCTID||' NAME: '||I.NAME||' TOTAT REVENUE: '||TOT_RVE); 
    END LOOP; 
END; 
  
-- CREATE TABLE REVENUE(PRODUCTID NUMBER,REVENUE NUMBER ); 
-- SELECT * FROM REVENUE; 
-- INSERT INTO REVENUE(PRODUCTID,REVENUE) VALUES(101,0); 
-- DROP TABLE REVENUE 
-- TRUNCATE TABLE PRODUCTS1 
  
--THIS TRIGGER WILL AUTOMATICALLY CALCULATE TOTAL PRICE ON PURCHASE TABLE, IT WILL UPDATE QUANTITYIN PRODUCT TABLE AND IT WILL UPDATE REVENUE 
  
CREATE OR REPLACE TRIGGER REV_TRG  
FOR INSERT ON PURCHASES1 
COMPOUND TRIGGER  
BEFORE EACH ROW IS 
P_PRICE PRODUCTS1.PRICE%TYPE; 
BEGIN 
    SELECT PRICE INTO P_PRICE FROM PRODUCTS1 WHERE PRODUCTID=:NEW.PRODUCTID; 
    :NEW.TOTALPRICE := :NEW.QUANTITY *P_PRICE; 
END BEFORE EACH ROW; 
  
AFTER EACH ROW IS 
    BEGIN 
    UPDATE PRODUCTS1 SET QUANTITY=QUANTITY-:NEW.QUANTITY WHERE PRODUCTID=:NEW.PRODUCTID; 
    UPDATE REVENUE SET REVENUE=REVENUE+:NEW.TOTALPRICE WHERE PRODUCTID=:NEW.PRODUCTID; 
END AFTER EACH ROW; 
END REV_TRG; 
TRUNCATE TABLE PURCHASES1 
  
--THIS TRIGGER WILL INSERT THE PRODUCT ID INTO REVENUE WHEN THERE IS INSERT ON PRODUCT TABLE  
-- AND IT WILL DELETE PRODUCTID FROM REVENUE IF IT IS DELETED FROM PRODUCTID 
  
CREATE OR REPLACE TRIGGER REV_INSERT 
AFTER INSERT OR DELETE ON PRODUCTS1 
FOR EACH ROW 
DECLARE 
    TYPE ID_NES IS TABLE OF PLS_INTEGER; 
    REV_ID ID_NES:=ID_NES(); 
    -- C NUMBER; 
BEGIN 
    IF INSERTING THEN 
        FOR I IN (SELECT PRODUCTID FROM REVENUE) LOOP 
            REV_ID.EXTEND; 
            REV_ID(REV_ID.LAST):=I.PRODUCTID; 
        END LOOP; 
        IF NOT REV_ID.EXISTS(:NEW.PRODUCTID) THEN 
            INSERT INTO REVENUE(PRODUCTID,REVENUE) VALUES(:NEW.PRODUCTID,0); 
        END IF; 
        -- SELECT COUNT(*) INTO C FROM REVENUE WHERE PRODUCTID=:NEW.PRODUCTID; 
        -- IF C=0 THEN 
        --     INSERT INTO REVENUE(PRODUCTID,REVENUE) VALUES(:NEW.PRODUCTID,0); 
        -- END IF; 
    ELSIF DELETING THEN 
        DELETE FROM REVENUE WHERE PRODUCTID=:NEW.PRODUCTID; 
    END IF; 
END; 
  
  
INSERT INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity, TotalPrice) VALUES (1011, 2, 101, TO_DATE('2024-06-04', 'YYYY-MM-DD'), 1, 2.49) 
INSERT INTO Purchases1 (PurchaseID, CustomerID, ProductID, PurchaseDate, Quantity) VALUES (1012, 4, 103, TO_DATE('2024-06-04', 'YYYY-MM-DD'), 3) 
  
  
--Query 2: Customer Purchase History: 
/*Write a PL/SQL Procedure to display the purchase history for a specific customer.  
Prompt the user to input a customer ID, then use a cursor to fetch and display all purchases made by that customer, including the product details.*/ 
  
DECLARE 
    CUIS NUMBER :=:C; 
    CURSOR C1 IS SELECT P1.PurchaseID, P.NAME, P1.PurchaseDate, P1.Quantity, P1.TotalPrice FROM PRODUCTS1 P 
                 JOIN PURCHASES1 P1 ON P.PRODUCTID=P1.PRODUCTID  
                 WHERE CUSTOMERID=:C; 
BEGIN 
    FOR I IN C1 LOOP 
    DBMS_OUTPUT.PUT_LINE('PurchaseID: ' ||I.PurchaseID || 
                              ', PurchaseDate: ' ||I.PurchaseDate || 
                              ', Product: ' ||I.Name || 
                              ', Quantity: ' ||I.Quantity || 
                              ', TotalPrice: ' || I.totalprice); 
    END LOOP; 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No purchase history found for the specified customer ID.'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occurred. Please try again later.'); 
END; 
 
--3.FIND AVG,TOTAL,RESULT FOR STUDENT, RESULT MUST BE PASS OR FAIL 
  
CREATE TABLE STUDENT(ID NUMBER, 
                     NAME VARCHAR(30), 
                     S1 NUMBER, 
                     S2 NUMBER, 
                     S3 NUMBER); 
  
INSERT INTO STUDENT VALUES(1,'SONY',56,89,78) 
INSERT INTO STUDENT VALUES(2,'JANU',34,45,48) 
  
CREATE OR REPLACE PROCEDURE STU_REPORT AS 
    S1 STUDENT.S1%TYPE; 
    S2 STUDENT.S2%TYPE; 
    S3 STUDENT.S3%TYPE; 
    AVGS NUMBER(10,2); 
    TOT NUMBER; 
    RESULT VARCHAR(30); 
BEGIN 
  
    FOR I IN (SELECT * FROM STUDENT) LOOP 
        S1:=I.S1; 
        S2:=I.S2; 
        S3:=I.S3; 
        TOT:=S1+S2+S3; 
        AVGS:=TOT/3; 
        RESULT:= CASE WHEN S1>=35 AND S2>=35 AND S3>=35 THEN 'PASS' ELSE 'FAIL' END; 
        DBMS_OUTPUT.PUT_LINE('ID: '||I.ID||' NAME: '||I.NAME||' AVG: '||AVGS||' TOTAL: '||TOT||' RESULT: '||RESULT); 
    END LOOP; 
END; 
  
BEGIN 
STU_REPORT(); 
END; 
  
--4. Increment 15% for the employees who have 5000 sal ,10% for the employees have sal between 5000 and 10000,5% for the employees who have more than 10000 
SELECT SALARY FROM OEHR_EMPLOYEES GROUP BY SALARY ORDER BY SALARY 
SELECT * FROM OEHR_EMPLOYEES 
  
CREATE OR REPLACE PROCEDURE INCEMPSAL AS 
E OEHR_EMPLOYEES%ROWTYPE; 
BEGIN 
    FOR I IN (SELECT * FROM OEHR_EMPLOYEES) 
    LOOP 
    E:=I; 
    IF E.SALARY<=5000 THEN 
        E.SALARY:=E.SALARY*1.15; 
    ELSIF (E.SALARY>=5000 AND E.SALARY<=10000) THEN 
        E.SALARY:=E.SALARY*1.1; 
    ELSE 
        E.SALARY:=E.SALARY*1.05; 
    END IF; 
    DBMS_OUTPUT.PUT_LINE('ID: '||I.EMPLOYEE_ID||' NAME: '||I.FIRST_NAME||' '||I.LAST_NAME||' SALARY: '||E.SALARY); 
    END LOOP; 
END; 
  
BEGIN 
INCEMPSAL(); 
END; 
  
/* 
5. Write a procedure named GetEmployeeInfo that takes an employee ID as input and returns the employee's first name, last name,  
department name, and manager's name. 
*/ 
CREATE OR REPLACE PROCEDURE GETEMPINFO(N IN EMPLOYEES.ID%TYPE) 
AS 
FN EMPLOYEES.FNAME%TYPE; 
LN1 EMPLOYEES.LNAME%TYPE; 
DN DEPARTMENTS.NAME%TYPE; 
MN VARCHAR(100); 
MN2 VARCHAR(100); 
BEGIN 
SELECT E.FNAME,E.LNAME,D.NAME,M.FNAME,M.LNAME INTO FN,LN1,DN,MN,MN2  
FROM EMPLOYEES E  
JOIN DEPARTMENTS D ON E.DEPARTMENTID=D.ID  
JOIN EMPLOYEES M ON M.ID=E.MANAGERID  
WHERE E.ID=N; 
  
DBMS_OUTPUT.PUT_LINE('First Name: '||FN); 
DBMS_OUTPUT.PUT_LINE('Last Name: '||LN1); 
DBMS_OUTPUT.PUT_LINE('Departent Name: '||DN); 
DBMS_OUTPUT.PUT_LINE('Manager Name: '||MN||' '||MN2); 
END; 
  
BEGIN 
GETEMPINFO(2); 
END; 
  
/*6. Cursor (Employee Commission): Write a PL/SQL block that declares a cursor to fetch employees who earn a commission (COMM is not null).  
Use a FOR loop to iterate through the cursor and display the employee details (EMPNO, ENAME, COMM) with appropriate labels.*/ 
SELECT * FROM OEHR_EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL; 
  
DECLARE 
    CURSOR COMM IS SELECT * FROM OEHR_EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL; 
    C NUMBER:=0; 
BEGIN 
    FOR I IN COMM LOOP 
        DBMS_OUTPUT.PUT_LINE(I.EMPLOYEE_ID||' NAME: '||I.FIRST_NAME||' '||I.LAST_NAME||' COMMISSION: '||I.COMMISSION_PCT); 
        C:=C+1; 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE(C||' RECEIVING COMMISSION'); 
END; 
  
-- 7.Function to Calculate Total Revenue by Customer: 
-- This function calculates the total revenue generated by a specific customer. 
  
CREATE OR REPLACE FUNCTION TOT_CUS_REV(ID IN NUMBER,REV OUT NUMBER)RETURN NUMBER 
IS  
BEGIN 
    SELECT SUM(P.PRICE*PUR.QUANTITY) INTO REV FROM PRODUCTS1 P JOIN PURCHASES1 PUR ON P.PRODUCTID=PUR.PRODUCTID WHERE PUR.CUSTOMERID=ID; 
    RETURN REV; 
END; 
  
DECLARE 
REVENUE NUMBER; 
OUTPUT NUMBER; 
BEGIN 
REVENUE:=TOT_CUS_REV(1,OUTPUT); 
DBMS_OUTPUT.PUT_LINE(REVENUE); 
END; 
 
--8. Using the HEALTH_STATUS_UPDATES table, generate a report showing the number of patients who reported feeling feverish today, grouped by state. 
CREATE OR REPLACE PROCEDURE STATE_FEVER_REPORT IS 
BEGIN 
    FOR I IN (SELECT HP.STATE AS STATES,SUM(CASE HSU.FEVERISH_TODAY WHEN 'Yes' THEN 1 ELSE 0 END) AS COUNT 
                FROM HEALTH_PATIENTS HP  
                JOIN HEALTH_STATUS_UPDATES HSU  
                ON HSU.PATIENT_ID=HP.PATIENT_ID GROUP BY HP.STATE) 
    LOOP 
    DBMS_OUTPUT.PUT_LINE('STATE: '||I.STATES||' FEVER COUNT IS '||I.COUNT); 
    END LOOP; 
END; 
  
BEGIN 
STATE_FEVER_REPORT(); 
END; 
  
--9. Write a SQL query to find the top 5 states with the highest number of patients. 
  
CREATE OR REPLACE PROCEDURE STATE_PATIENT_COUNT  
IS 
     
BEGIN 
    FOR I IN (SELECT COUNT(*) AS C, 
                   STATE, 
                   DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS D 
                   FROM HEALTH_PATIENTS GROUP BY STATE) 
    LOOP 
        IF I.D>5 THEN 
            EXIT; 
        ELSE 
            DBMS_OUTPUT.PUT_LINE(I.STATE||' has count '||I.C||' and rank is '||I.D); 
        END IF; 
    END LOOP; 
END; 
  
BEGIN 
STATE_PATIENT_COUNT(); 
END; 
 
--9. Write a SQL query to find the top 5 states with the highest number of patients. 
  
CREATE OR REPLACE PROCEDURE STATE_PATIENT_COUNT  
IS 
     
BEGIN 
    FOR I IN (SELECT COUNT(*) AS C, 
                   STATE, 
                   DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS D 
                   FROM HEALTH_PATIENTS GROUP BY STATE) 
    LOOP 
        IF I.D>5 THEN 
            EXIT; 
        ELSE 
            DBMS_OUTPUT.PUT_LINE(I.STATE||' has count '||I.C||' and rank is '||I.D); 
        END IF; 
    END LOOP; 
END; 
  
BEGIN 
STATE_PATIENT_COUNT(); 
END; 
     
DROP TYPE STATE_PATIENT_COUNT 
  
--10. Develop a stored procedure that takes a patient's ID as input and returns their latest health status update. 
  
CREATE OR REPLACE PROCEDURE PATIENT_LATEST_STATUS(ID IN NUMBER) 
IS 
    DATE_P HEALTH_STATUS_UPDATES.DATE_PROVIDED%TYPE; 
BEGIN 
    SELECT MAX(DATE_PROVIDED) INTO DATE_P 
    FROM HEALTH_STATUS_UPDATES  
    WHERE PATIENT_ID=ID; 
    FOR I IN (SELECT * FROM HEALTH_STATUS_UPDATES WHERE PATIENT_ID=ID AND DATE_PROVIDED=DATE_P) 
    LOOP 
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE('DATE PROVIDED: '||I.DATE_PROVIDED); 
        DBMS_OUTPUT.PUT_LINE('STATUS_UPDATE_ID: '||I.STATUS_UPDATE_ID); 
        DBMS_OUTPUT.PUT_LINE('FEELING TODAY: '||I.FEELING_TODAY); 
        DBMS_OUTPUT.PUT_LINE('IMPACT: '||I.IMPACT); 
        DBMS_OUTPUT.PUT_LINE('INJECTION_SITE_SYMPTOMS: '||I.INJECTION_SITE_SYMPTOMS); 
        DBMS_OUTPUT.PUT_LINE('HIGHEST_TEMP: '||I.HIGHEST_TEMP); 
        DBMS_OUTPUT.PUT_LINE('FEVERISH_TODAY: '||I.FEVERISH_TODAY); 
        DBMS_OUTPUT.PUT_LINE('GENERAL SYMPTOMS'||I.GENERAL_SYMPTOMS); 
        DBMS_OUTPUT.PUT_LINE('HEALTH CARE VISIT: '||I.HEALTHCARE_VISIT); 
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------'); 
    END LOOP; 
END; 
  
BEGIN 
PATIENT_LATEST_STATUS(1199); 
END; 
 
--11. Create a package that includes a function to calculate the average age of patients in a given state and a procedure to update the population count of a state. 
  
CREATE OR REPLACE PACKAGE PATIENTS_PAC IS 
    FUNCTION PATIENT_AVG(S IN HEALTH_PATIENTS.STATE%TYPE) RETURN NUMBER; 
    PROCEDURE POPULATION_UPDATE(S IN HEALTH_PATIENTS.STATE%TYPE,P IN NUMBER ); 
END; 
  
CREATE OR REPLACE PACKAGE BODY PATIENTS_PAC IS 
    FUNCTION PATIENT_AVG(S IN HEALTH_PATIENTS.STATE%TYPE) RETURN NUMBER 
    IS 
    AVGG NUMBER; 
    BEGIN 
        SELECT TO_NUMBER(CEIL(AVG(TO_CHAR(SYSDATE,'YYYY')-YEAR_OF_BIRTH))) INTO AVGG FROM HEALTH_PATIENTS WHERE STATE=S GROUP BY STATE ; 
        RETURN AVGG; 
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('State not found'); 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error occured'); 
    END PATIENT_AVG; 
    
    PROCEDURE POPULATION_UPDATE(S IN HEALTH_PATIENTS.STATE%TYPE,P IN NUMBER )  
    IS 
    BEGIN 
        UPDATE HEALTH_STATES SET POPULATION=P WHERE STATE=S; 
        DBMS_OUTPUT.PUT_LINE('State Population updated successfully'); 
    EXCEPTION  
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('State not found'); 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error occured'); 
    END POPULATION_UPDATE; 
END PATIENTS_PAC; 
  
BEGIN 
DBMS_OUTPUT.PUT_LINE(PATIENTS_PAC.PATIENT_AVG('Alabama')); 
PATIENTS_PAC.POPULATION_UPDATE('Alabama',5021532); 
END; 
  
  
SELECT TO_NUMBER(CEIL(AVG(TO_CHAR(SYSDATE,'YYYY')-YEAR_OF_BIRTH))) FROM HEALTH_PATIENTS WHERE STATE='Alabama' ; 
SELECT TO_CHAR(SYSDATE,'YYYY')-YEAR_OF_BIRTH FROM HEALTH_PATIENTS WHERE STATE='Alabama' ; 
