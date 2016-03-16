/* This is for create view of mysql testing

   1. in the empty database
   2. craete two tables
   3. start to insert some data for testing.
   */

/* create the test database */
CREATE DATABASE IF NOT EXISTS dbForViewTest;

/* change into dbForViewTest database */
USE dbForViewTest;

/* craete table for testing*/

-- drop the table if exists.
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS teacher;

-- create table
CREATE TABLE teacher (
  tno INT PRIMARY KEY,
  tname VARCHAR(20)
);

CREATE TABLE student (
  sno INT,
  sname VARCHAR(20),
  tno INT,
  PRIMARY KEY(sno),
  CONSTRAINT FOREIGN KEY (tno) REFERENCES teacher(tno) ON DELETE CASCADE
);

/* insert teacher data */
INSERT INTO teacher(tno, tname)VALUES(10000, "wa");
INSERT INTO teacher(tno, tname) VALUES(10001, "wb");
INSERT INTO teacher(tno, tname) VALUES(10002, "wc");
INSERT INTO teacher(tno, tname) VALUES(10003, "wd");
INSERT INTO teacher(tno, tname) VALUES(10004, "we");
INSERT INTO teacher(tno, tname) VALUES(10005, "wf");
INSERT INTO teacher(tno, tname) VALUES(10006, "wg");
INSERT INTO teacher(tno, tname) VALUES(10007, "wh");
INSERT INTO teacher(tno, tname) VALUES(10008, "wi");
INSERT INTO teacher(tno, tname) VALUES(10009, "wj");

/* insert student data */
INSERT INTO student(sno, sname, tno) VALUES(20000, "sa", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20001, "sb", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20002, "sc", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20003, "sd", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20004, "se", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20005, "sf", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20006, "sg", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20007, "sh", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20008, "si", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20009, "sj", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20010, "sk", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20011, "sl", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20012, "sm", 10000);
INSERT INTO student(sno, sname, tno) VALUES(20013, "sn", 10000);
/* end */
