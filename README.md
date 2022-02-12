<p align="center">
 <img width="100px" src="https://raw.githubusercontent.com/NekoSilverFox/NekoSilverfox/403ab045b7d9adeaaf8186c451af7243f5d8f46d/icons/silverfox.svg" align="center" alt="NekoSilverfox" />
 <h1 align="center">Oracle 数据库</h2>
 <p align="center"><b>笔记</b></p>
</p>


<div align=center>


[![License](https://img.shields.io/badge/license-Apache%202.0-brightgreen)](LICENSE)


<div align=left>
<!-- 顶部至此截止 -->

# Oracle 简介

**Oracle实例：**位于物理内存的数据结构，它由操作系统的多个后台进程和一个共享的内存池所组成，共享的内存可以被所有进程访问。Oracle用它们来管理数据库访。用户如果要存取数据库（也就是硬盘上的文件）里的数据，必须通过Oracle实例能实现，不能直接读取硬盘上的文件。实际上，Oracle实例就是平常所说的数据库服务（service）。在任何时刻，一个实例只能与一个数据库关联，访问一个数据库；而同一个数据库可由多个实例访问（RAC）

<img src="doc/pic/README/image-20220120150137417.png" alt="image-20220120150137417" style="zoom:50%;" />





# 表设计

## 表的概念

数据库中以表为组织单位存储数据。表用来存储一些事物的信息，首先需要有一个表名，以及存储的信息



## 约束

对于存储的没一个信息，都应该使用相应的数据进行表示，并且这些数据应该是合法的（包括实际和业务逻辑），在数据库中我们通过约束来对每个字段中的数据的合法性进行规范。

- 主键约束（PRIMARY KEY）
- 一性约束（UNIQUE）
- 非空约束（NOT NULL）
- 外键约束（FOREIGN KEY）
- 检查约束（CHECK）



## dual 虚表

dual 是一个虚表，虚拟表，是用来构成 select 的语法规则， oraclet 保证dua里面永远只有一条记录。该表只有一行一列，它和其他表一样，可以执行插入、更新、删除操作，还可以执行drop操作。但是不要去执行drop表的操作，否则会使系统不能用，起不了数据库。

dual 主要用来选择系统变量或是求一个表达式的值。如果我们不需要从具体的表来取得表中数据，而是单纯地味了得到一些我们想得到的信息，并要通过 select 完成时，就要借助一个对象，这个对象就是 dual。

例如：计算999*666

```sql
SELECT 666 * 999 FROM dual;
```



# SQL 命令

## 基本语法

```sql
SELECT [DISTINCT]
        字段, 
        字段 AS 别名, 
        字段 || 拼接的字符串, 
        伪列
	FROM 数据来源
	WHERE 
		行记录条件=? [AND] / [OR] / [NOT] 
		行记录条件='?'
		字段 [is null] / [is not null] / [not ... is null]
		LIKE '%_a%%' EXCAPE('a')
	ORDER BY 
		排序字段
		[ASC（升序）] / [DESC（降序）]
		[NULLS FIRST] / [NULLS LAST]
	;
```

- **不等于**可以用 `!=`、`<>`、`^=` 进行表示
- `WHERE` 范围取值可用 `BETWEEN ... AND ...`、`IN`
    - `BETWEEN ... AND ...` 的取值范围是 [Right, Left]。**是左右闭区间**
    - `IN` 的取值范围可以使用 `IN (值1, 值2, 值3, ...)`
- 在 `WHERE` 的条件中，**被单引号所包含的字符串是区分大小写的**！



## SELECT

- **解析顺序**

    ```sql
    	3		1		2			4
    SELECT ... FROM ... WHERE ... ORDER BY ... ;
    
    
    -- 【重点】根据 SQL 的解析顺序，在 ORDER BY 中是可以使用别名的
    -- 查询员工的姓名、工资别名为工资，并且按照工资的降序排列
    SELECT ename, sal 工资 FROM emp ORDER BY 工资 DESC;
    ```

    

- **去重**

    ```sql
    SELECT DISTINCT 查询的信息 FROM 数据来源;
    ```




- **取别名**

    ```sql
    SELECT colName 别名 FROM ...;
    
    SELECT colName as 别名 FROM ...;
    ```

    

- **排序**

    ```sql
    -- 升序
    SELECT ...... ORDER BY 列明 ASC;
    
    -- 降序
    SELECT ...... ORDER BY 列明 DESC;
    
    -- 多字段排序
    -- 查询所有员工的姓名、工资、所在的部门的编号，按照部门编号升序排序，同一部门的员工，按照工资降序排序
    SELECT ename, sal, deptno FROM emp ORDER BY deptno ASC, sal DESC;
    ```

    

- **伪列和表达式**

    ```sql
    -- 查询用户姓名，工资, 1  <-- 这里的 1 就是伪列
    SELECT ename, sal, 1 from emp;
    
    -- 查询姓名，月工资，年薪（月薪*12），这里的年薪就是伪列
    SELECT ename, sal, sal*12 FROM emp;
    
    SELECT ename, sal, sal*12 AS "年薪" FROM emp;
    ```

    

- **null 处理**

    **在进行表达式或者排序操作的时候会遇到对空值的处理**，其中：

    - 如果**表达式运算**中有字段为 null，则**结果为 null**；

    - 如果字符串拼接中有字段为 null，则改空值被处理为**空字符串**；

        `nvl(表达式或列，如果参数1为空的话使用的值)` - 可以**对 null 进行处理**，当某个值为空的时候，用一个特定的值替换

        ```SQL
        -- 查询员工月收入（工资+提成）
        select ename, sal, comm, sal+comm as "月收入" from emp; -- 如果表达式中有一个为 null，那么运算后的结果为 null
        
        -- nvl(表达式或列，如果参数1为空的话使用的值) 
        select ename, sal, comm, sal+NVL(comm， 0) as "月收入" from emp; -- 如果 comm 为空则使用 0 进行替代
        
        -- 查询所有没有奖金的员工（comm <= 0），当某个人的将近为 null 时，则认为他的奖金为 0
        SELECT * FROM emp WHERE NVL(comm, 0)<=0 OR comm <=0;
        ```

        

    - 如果在**排序**中，被排序的行有的为空值，那么这些行无法被排序

        `nulls first` 将空值的放在最前面

        `nulls last` 将空值的都放在后面

        ```SQL
        -- 按照提成进行升序排序
        SELECT * FROM emp ORDER BY comm ASC;
        
        -- nulls first 将空值的放在最前面
        -- nulls last 将空值的都放在后面
        SELECT * FROM emp ORDER BY comm DESC NULLS FIRST;
        SELECT * FROM emp ORDER BY comm DESC NULLS LAST;
        ```

        

- **字符串拼接**

	`||` - 可以对字符串进行拼接
	
	```sqlite
	SELECT ename FROM emp;
	
	-- 名字后面都加上一个 fox` 
	SELECT ename, ename||'fox' AS This_is_Alisa FROM emp;
	-- 【重点】如果在字符串拼接时，遇到了null，那么对自动转换为空字符串，而不是也为 null！
	SELECT ename, comm , ename || comm AS null_merge FROM emp;
	```



## WHERE

- **不等于**可以用 `!=`、`<>`、`^=` 进行表示
- `WHERE` 范围取值可用 `BETWEEN ... AND ...`、`IN`
    - `BETWEEN ... AND ...` 的取值范围是 [Right, Left]。**是左右闭区间**
    - `IN` 的取值范围可以使用 `IN (值1, 值2, 值3, ...)`
- 在 `WHERE` 的条件中，**被单引号所包含的字符串是区分大小写的**！

```sql
-- （BETWEEN ... AND... 用法）查询工资在 2000 到 3000 之间的员工信息
SELECT * FROM emp WHERE sal BETWEEN 2000 AND 3000;

-- 【重点】（IN 用法）查询在 10 或 20 号部门工作的员工信息
SELECT * FROM emp WHERE deptno IN (10, 20);
```



- **模糊查询**

    关键字：`LIKE`

    其中：

    - `%` 表示匹配任意多个字符
    - `_` 表示匹配任意 1 个字符
    - `escape('标识符') ` 函数表示**标识符后面紧挨的【一个字符】为普通字符**，不具有特殊含义；这个标识符可以为任意字符

    ```sqlite
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
    ```

    



# 函数

根据函数的返回结果，我们将函数分为**单行函数**和**多行函数**

- **单行函数**：对应在表记录时，一条记录返回一个结果。例如 lower(x)，将参数转换为小写
- **多行函数也称组函数或聚合函数**（重点）：类函数可同时对多条记录进行操作，并返回一个结果。例如 max(x) 求最大值。



## 单行函数

会处理表里的每一个记录或者字段

| 函数名                   | 功能                                                         |
| ------------------------ | ------------------------------------------------------------ |
| concat(x, y)             | 连接字符串 x 和 y                                            |
| instr(x, str, start, n)  | 在 x 中查找 str，可以指定从 start 开始；也可以指定从第 n 次开始 |
| length(x)                | 返回 x 的长度                                                |
| lower(x)                 | x 转换为小写                                                 |
| upper(x)                 | x 转换为大写                                                 |
| ltrim(x, trim_str)       | 把 x 的左边截去 trim_str 字符串，如果缺省则截去空格          |
| rtrim(x, trim_str)       | 把 x 的右边截去 trim_str 字符串，如果缺省则截去空格          |
| replace(x, old, new)     | 在 x 中查找 old，并替换成 new                                |
| substr(x, start, length) | 返回 x 的字符串，从 start 处开始截取 length 个字符，如果 length 缺省则默认截取到结尾 |



## 多行函数

​	



## 数学函数

| 函数名    | 功能             |
| --------- | ---------------- |
| abs(x)    | 取 x 的绝对值    |
| ceil(x)   | 向上取整         |
| floor(x)  | 向下取整         |
| mod(x, y) | 对 x 求 y 的余数 |
|           |                  |
|           |                  |
|           |                  |

