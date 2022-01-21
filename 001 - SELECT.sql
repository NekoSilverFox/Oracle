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

-- 查询所有没有奖金的员工（comm <= 0），当某个人的将近为 null 时，则认为他的奖金为 0
SELECT * FROM emp WHERE NVL(comm, 0)<=0 OR comm <=0;


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



----------------------------------- 模糊查询 -----------------------------------
-- 名字以 ** S 开头 ** 的员工
SELECT * FROM emp WHERE ename LIKE 'S%';

-- 名字以 ** S 结尾 ** 的员工
SELECT * FROM emp WHERE ename LIKE '%S';

-- 名字 ** 含有 S ** 的员工
SELECT * FROM emp WHERE ename LIKE '%S%';

-- 查询名字第 2 个字母为 `A` 的
SELECT * FROM emp WHERE ename LIKE '_A%';

-- 查询名字倒数第 2 个字母为 `I` 的
SELECT * FROM emp WHERE ename LIKE '%I_';

-- 查询员工名字中包含 `%` 的
SELECT * FROM emp;
INSERT INTO emp(empno, ename, job, deptno) VALUES(1252, 'fox%e_r', 'eee', 20);
COMMIT;
SELECT * FROM emp WHERE ename LIKE '%a%%' escape('a'); -- 【重点】escape('标识符') 表示标识符后面紧挨的[一个字符]为普通字符，不具有特殊含义；这个标识符可以为任意字符

-- 查询员工名字中包含 `x%` 的
SELECT * FROM emp WHERE ename LIKE '%xxx%%' escape('x');

-- 查询员工名字中包含 `%` `_` 的
SELECT * FROM emp WHERE ename LIKE '%x%%x_%' escape('x');


