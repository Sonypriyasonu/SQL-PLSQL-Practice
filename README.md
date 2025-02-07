# SQL-PLSQL-Practice

# Relational Database Management System (RDBMS)

A Relational Database Management System (RDBMS) is a software system that manages relational databases. It provides an interface for users to interact with the database, stores and retrieves data, and ensures data integrity and security. Some popular examples of RDBMS include:

- Oracle Database
- MySQL
- Microsoft SQL Server
- PostgreSQL
- IBM Db2
- SQLite

## Logical and Physical Storage Structures

[Learn More](https://sl.bing.net/xVba6zSEay)

---

## Oracle History

Oracle Corporation has a long history of database development, and its Oracle Database management system has gone through several versions and releases since its inception. Here's a brief overview:

### Oracle Database Versioning:

Oracle Database versions are typically identified by a numeric version number, followed by optional release numbers and patchset updates. For example:

- Oracle Database 11g Release 2 (11.2.0.4)
- Oracle Database 12c Release 1 (12.1.0.2)

**Version Naming:**
- The "g" in the version name stands for "grid computing."
- The "c" in more recent versions stands for "cloud computing."

### Historical Overview:

- **Oracle 2 (Version 2)**: Released in 1979, first commercially available SQL-based RDBMS.
- **Oracle 3, 4, 5, 6**: Improvements and expansions in features.
- **Oracle 7 (1992)**: Introduced PL/SQL, stored procedures, triggers, etc.
- **Oracle 8, 8i, 9i**: Enhanced performance, scalability, and internet technologies support.
- **Oracle 10g (2003)**: Introduced grid computing capabilities.
- **Oracle 11g (2007)**: Focused on improving database management and performance.
- **Oracle 12c (2013)**: Introduced "multitenant architecture" and cloud computing capabilities.
- **Oracle 18c & 19c**: Continued focus on cloud-first features and autonomous databases.
- **Oracle 21c (2020)**: Introduced Blockchain Tables, Native JSON Datatype, etc.

---

## SQL (Structured Query Language)

SQL is a domain-specific language used for managing data held in a relational database management system (RDBMS) or a relational data stream management system (RDSMS).

### SQL Categories:

- **DML (Data Manipulation Language)**: `INSERT`, `UPDATE`, `DELETE`
- **DDL (Data Definition Language)**: `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME`
- **DRL (Data Retrieval Language)**: `SELECT`
- **DCL (Data Control Language)**: `GRANT`, `REVOKE`
- **TCL (Transaction Control Language)**: `COMMIT`, `ROLLBACK`, `SAVEPOINT`

---

## Normalization

Normalization is the process of organizing data efficiently in a database to reduce redundancy and improve data integrity.

### Normal Forms:

- **1NF (First Normal Form)**: No repeating groups within rows; each column should contain atomic values and must have a unique name.
- **2NF (Second Normal Form)**: Must be in 1NF; all non-key attributes fully depend on the primary key.
- **3NF (Third Normal Form)**: Must be in 2NF; no transitive dependencies; non-prime attributes depend only on the primary key.
- **BCNF (Boyce-Codd Normal Form)**: A stronger version of 3NF; every determinant must be a candidate key.
- **4NF (Fourth Normal Form)**: No multi-valued dependencies.

### Example:

| EmployeeID | Name        | Dept       |
|------------|------------|------------|
| 1          | John Doe   | Engineering|
| 2          | Jane Smith | Marketing  |

### Key Concepts:

- **Candidate Key**: A set of columns that can serve as the primary key.
- **Composite Key**: A key composed of two or more columns to uniquely identify records in a table.

---

## Data Types

### Common SQL Data Types:

- **VARCHAR2**: Variable-length character string.
- **NVARCHAR2**: Variable-length Unicode character string.
- **NUMBER**: Numeric value with precision and scale.
- **FLOAT**: Subtype of NUMBER with binary precision.
- **LONG**: Variable-length character data.
- **DATE**: Date and time value.
- **BINARY_FLOAT**: 32-bit floating point number.
- **BINARY_DOUBLE**: 64-bit floating point number.
- **TIMESTAMP**: Date and time with fractional seconds.
- **TIMESTAMP WITH TIME ZONE**: Timestamp with time zone information.
- **TIMESTAMP WITH LOCAL TIME ZONE**: Timestamp with local time zone information.
- **INTERVAL YEAR TO MONTH**: Period of time in years and months.
- **INTERVAL DAY TO SECOND**: Period of time in days, hours, minutes, and seconds.
- **RAW / LONG RAW**: Raw binary data.
- **ROWID / UROWID**: Unique row address.
- **CHAR / NCHAR**: Fixed-length character data.
- **CLOB / NCLOB**: Character large objects.
- **BLOB**: Binary large object.
- **BFILE**: Locator to a large binary file stored outside the database.

---


