/* ���������� �������: 1. order, 2. orderdetails, ��������� �� ����� orderid.
 * ���������� �������: 1. products, 2. categories, 3. suppliers (���. 1, 2 ������� 
 * �� ����� categoryid, ���. 1, 3 ������� �� ����� supplierid, ���. 1, 3 �������
 * �� ����� supplierid).
 * ���������� ������� shippers, ��������� � orders �� ����� shipperid.
 * ���������� ������� customers, ��������� � orders �� ����� customerid.
 * ���������� ������� employees, ��������� � orders �� ����� employeeid.
 * -------------------------JOINS----------------------------------
 * ������� ���������� �� ���-�� ������� � ������ � �� �����, ��������� LJ,RJ*/
SELECT quantity, orderdate
FROM orderdetails LEFT JOIN orders
ON orderdetails.orderid = orders.orderid
ORDER BY 1;
/*������� ��� �� ��������� � RJ*/
SELECT quantity, orderdate
FROM orders RIGHT JOIN orderdetails
ON orders.orderid = orderdetails.orderid 
ORDER BY 1; 
/* ������� ��� ���������� �� ��������� � �� ���������� ��� ��������� � ����� �� ����� 
 * 90 � � ��������� ��������� ��������, ������������ �� �� ����� "M" */
SELECT * 
FROM products JOIN categories
ON products.categoryid = categories.categoryid
WHERE price >= 90 AND categoryname NOT LIKE 'M%'; */
/* ������� ��� ���������� �� ���������, �� ���������� � ����������� ��� ��������� 
 * � ���������� ������� ����� 10 � 20, ��������������� �� ���� � ������� �������� */
SELECT * FROM products
JOIN categories ON products.categoryid = categories.categoryid
JOIN suppliers ON products.supplierid = suppliers.supplierid
WHERE productid BETWEEN 10 AND 20
ORDER BY price DESC;
/* -----------------��������� �������------------------------------
 * ������� ���������� ����� ����������������, ���� ������ � ���������� ����� ����������
 * ��� ���� �����������������, � ������� � �������� ����������� ��� ����� Package. */
SELECT shipperid, orderdate, customerid 
FROM orders
WHERE shipperid IN
(SELECT shipperid
FROM shippers
WHERE shippername NOT LIKE '%Package%')
ORDER BY 1 DESC;
/* ������� �������� ����������� ���������� � ��� ����������� ���� ���������� ��� ���� 
 * �����������, � ������� ������� ���� �������� ������ 40 */
SELECT s.suppliername, s.contactname
FROM suppliers s
WHERE s.supplierid IN
(SELECT p.supplierid
FROM products p
GROUP BY productid
HAVING AVG(price) > 40 
AND p.supplierid = s.supplierid);
/* ������� ��� ���������� �� ���������, ���� ������� ������ ������������ �������� ���� 
 * ��� ������ ��������� �������� */
SELECT * FROM products p1
WHERE p1.price >
(SELECT MIN(p2.price)
FROM products p2
GROUP BY categoryid
HAVING p1.categoryid = p2.categoryid);
/* ----------------------------------------------------------------
 * ������� �����������, � ������� ��� ������� */
SELECT * FROM employees e
WHERE NOT EXISTS
(SELECT * FROM orders o
WHERE o.employeeid = e.employeeid);
/* ������� ������� ��� ���������� � ���������, �������� ���� ���� ������� ��������� ������ 
 * �� �������� ��� ���������, ���������� ������� ��������� � ���. */
SELECT * FROM products
WHERE price > ALL
(SELECT price FROM products
WHERE supplierid IN
(SELECT supplierid FROM suppliers
WHERE country = 'USA'));
/* ������� �������� ����� CustomerID, CustomerName, EmployeeID, LastName ��� ������� ���������� � 
 * ����������, �������� ����� ������� �������. ������ � ������������ ������ ����� ����������� 
 * ������������, ������ � ������������ ������ ����� ����������� ���������� */
(SELECT customerid, customername, '����������' FROM customers
WHERE customerid IN
(SELECT o1.customerid FROM orders o1 WHERE 4 < (SELECT COUNT(DISTINCT o2.orderid) FROM orders o2 WHERE o1.customerid = o2.customerid)))
UNION
(SELECT employeeid, lastname, '���������' FROM employees
WHERE employeeid IN
(SELECT o1.employeeid FROM orders o1 WHERE 4 < (SELECT COUNT(DISTINCT o2.orderid) FROM orders o2 WHERE o1.employeeid = o2.employeeid)))
ORDER BY 1 DESC;