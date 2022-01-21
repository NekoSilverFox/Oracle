
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