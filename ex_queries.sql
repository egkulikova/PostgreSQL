/* Существуют таблицы: 1. order, 2. orderdetails, связанные по ключу orderid.
 * Существуют таблицы: 1. products, 2. categories, 3. suppliers (таб. 1, 2 связаны 
 * по ключу categoryid, таб. 1, 3 связаны по ключу supplierid, таб. 1, 3 связаны
 * по ключу supplierid).
 * Существует таблица shippers, связанная с orders по ключу shipperid.
 * Существует таблица customers, связанная с orders по ключу customerid.
 * Существует таблица employees, связанная с orders по ключу employeeid.
 * -------------------------JOINS----------------------------------
 * Вывести информацию по кол-ву посылок в заказе и по датам, используя LJ,RJ*/
SELECT quantity, orderdate
FROM orderdetails LEFT JOIN orders
ON orderdetails.orderid = orders.orderid
ORDER BY 1;
/*Вывести тот же результат с RJ*/
SELECT quantity, orderdate
FROM orders RIGHT JOIN orderdetails
ON orders.orderid = orderdetails.orderid 
ORDER BY 1; 
/* Вывести всю информацию по продуктам и их категориям для продуктов с ценой не менее 
 * 90 и с названием категории продукта, начинающимся не на букву "M" */
SELECT * 
FROM products JOIN categories
ON products.categoryid = categories.categoryid
WHERE price >= 90 AND categoryname NOT LIKE 'M%'; */
/* Вывести всю информацию по продуктам, их категориям и поставщикам для продуктов 
 * с уникальным номером между 10 и 20, отсортированную по цене в порядке убывания */
SELECT * FROM products
JOIN categories ON products.categoryid = categories.categoryid
JOIN suppliers ON products.supplierid = suppliers.supplierid
WHERE productid BETWEEN 10 AND 20
ORDER BY price DESC;
/* -----------------ВЛОЖЕННЫЕ ЗАПРОСЫ------------------------------
 * Вывести уникальный номер грузоотправителя, дату заказа и уникальный номер покупателя
 * для всех грузоотправителей, у которых в названии организации нет слова Package. */
SELECT shipperid, orderdate, customerid 
FROM orders
WHERE shipperid IN
(SELECT shipperid
FROM shippers
WHERE shippername NOT LIKE '%Package%')
ORDER BY 1 DESC;
/* Вывести название организации поставщика и имя контактного лица поставщика для всех 
 * поставщиков, у которых средняя цена продукта больше 40 */
SELECT s.suppliername, s.contactname
FROM suppliers s
WHERE s.supplierid IN
(SELECT p.supplierid
FROM products p
GROUP BY productid
HAVING AVG(price) > 40 
AND p.supplierid = s.supplierid);
/* Вывести всю информацию по продуктам, цена которых больше минимального значения цены 
 * для данной категории продукта */
SELECT * FROM products p1
WHERE p1.price >
(SELECT MIN(p2.price)
FROM products p2
GROUP BY categoryid
HAVING p1.categoryid = p2.categoryid);
/* ----------------------------------------------------------------
 * Вывести сотрудников, у которых нет заказов */
SELECT * FROM employees e
WHERE NOT EXISTS
(SELECT * FROM orders o
WHERE o.employeeid = e.employeeid);
/* Вывести выведет всю информацию о продуктах, значение поля цены которых превышает каждое 
 * из значений для продуктов, поставщики которых находятся в США. */
SELECT * FROM products
WHERE price > ALL
(SELECT price FROM products
WHERE supplierid IN
(SELECT supplierid FROM suppliers
WHERE country = 'USA'));
/* Вывести значения полей CustomerID, CustomerName, EmployeeID, LastName для каждого покупателя и 
 * сотрудника, имеющего более четырех заказов. Строки с покупателями должны иметь комментарий 
 * “Покупатель”, строки с сотрудниками должны иметь комментарий “Сотрудник” */
(SELECT customerid, customername, 'Покупатель' FROM customers
WHERE customerid IN
(SELECT o1.customerid FROM orders o1 WHERE 4 < (SELECT COUNT(DISTINCT o2.orderid) FROM orders o2 WHERE o1.customerid = o2.customerid)))
UNION
(SELECT employeeid, lastname, 'Сотрудник' FROM employees
WHERE employeeid IN
(SELECT o1.employeeid FROM orders o1 WHERE 4 < (SELECT COUNT(DISTINCT o2.orderid) FROM orders o2 WHERE o1.employeeid = o2.employeeid)))
ORDER BY 1 DESC;