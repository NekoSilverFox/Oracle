----------------------------------- 别名 -----------------------------------
-- 【重点】根据 SQL 的解析顺序，在 ORDER BY 中是可以使用别名的
-- 查询员工的姓名、工资别名为工资，并且按照工资的降序排列
SELECT ename, sal 工资 FROM emp ORDER BY 工资 DESC;




----------------------------------- 伪列 -----------------------------------
-- 查询用户姓名，工资, 1  <-- 这里的 1 就是伪列
SELECT ename, sal, 1 from emp;

-- 查询姓名，月工资，年薪（月薪*12），这里的年薪就是伪列
SELECT ename, sal, sal*12 FROM emp;

SELECT ename, sal, sal*12 as "年薪" FROM emp;




----------------------------------- 空值处理 -----------------------------------
-- 查询员工月收入（工资+提成）
select ename, sal, comm, sal+comm as "月收入" from emp; -- 如果表达式中有一个为 null，那么运算后的结果为 null
-- nvl(表达式或列，如果参数1为空的话使用的值) 
select ename, sal, comm, sal+NVL(comm， 0) as "月收入" from emp; -- 如果 comm 为空则使用 0 进行替代


-- 按照提成进行升序排序
SELECT * FROM emp ORDER BY comm ASC;
-- nulls first 将空值的放在最前面
-- nulls last 将空值的都放在后面
SELECT * FROM emp ORDER BY comm DESC NULLS FIRST;
SELECT * FROM emp ORDER BY comm DESC NULLS LAST;



----------------------------------- 字符串拼接 -----------------------------------
SELECT ename FROM emp;
-- 名字后面都加上一个 fox` 
SELECT ename, ename||'fox' AS This_is_Alisa FROM emp;
-- 【重点】如果在字符串拼接时，遇到了null，那么对自动转换为空字符串，而不是也为 null！
SELECT ename, comm , ename || comm AS null_merge FROM emp;



----------------------------------- dual 虚表 -----------------------------------
SELECT 666 * 999 FROM dual;



----------------------------------- WHERE -----------------------------------
-- （BETWEEN ... AND... 用法）查询工资在 2000 到 3000 之间的员工信息
SELECT * FROM emp WHERE sal BETWEEN 2000 AND 3000;

-- 【重点】（IN 用法）查询在 10 或 20 号部门工作的员工信息
SELECT * FROM emp WHERE deptno IN (10, 20);



