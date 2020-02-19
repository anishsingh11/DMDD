/******CREATE TABLE STARTS*********/

CREATE DATABASE P2P

USE P2P
GO

CREATE TABLE [dbo].[Customer](
	[CustomerId] [int] NOT NULL,
	[CustomerName] [varchar](max) NOT NULL,
	[CardNo] [bigint] NULL,
	[CVV] [int] NOT NULL,
	[ExpiryDate] [date] NOT NULL,
	[CustPhoneNo] [bigint] NULL,
	[CustEmail] [varchar](max) NULL,
	[SSN] [bigint] NULL,
	[ResAddress] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)
)ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerFeedBack](
	[FeedbackID] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[EmployeeRating] [int] NOT NULL,
	[CompanyRating] [int] NOT NULL,
 CONSTRAINT [PK_CustomerFeedBack] PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)
)ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerFeedBack]  WITH CHECK ADD  CONSTRAINT [FK_FeedBack_CustFeedBack] FOREIGN KEY([FeedbackID])
REFERENCES [dbo].[CustomerFeedBack] ([FeedbackID])
GO


CREATE TABLE [dbo].[Employee](
	[EmpId] [int] NOT NULL,
	[EmpName] [nvarchar](max) NOT NULL,
	[EmpPhoneNo] [bigint] NULL,
	[EmpEmail] [nvarchar](max) NOT NULL,
	[EmpSSN] [int] NOT NULL,
	[EmpResAddress] [varchar](max) NOT NULL,
	[LicenseNo] [varchar](max) NOT NULL,
	[MedicalInsuranceNo] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC
)
)ON [PRIMARY]
GO

CREATE TABLE [dbo].[EmployeeSalary](
	[AccountNo] [int] NOT NULL,
	[AccountType] [varchar](max) NOT NULL,
	[RoutingNo] [int] NOT NULL,
	[BankName] [varchar](max) NOT NULL,
	[Amount] [float] NOT NULL,
	[NoOfOrders] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeSalary] PRIMARY KEY CLUSTERED 
(
	[AccountNo] ASC
)
)ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeSalary_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([EmpId])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_EmployeeSalary_Employee]
GO


CREATE TABLE [dbo].[Product](
	[ProductId] [int] NOT NULL,
	[ProductName] [varchar](max) NOT NULL,
	[ProductCategory] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)
)ON [PRIMARY]
GO



CREATE TABLE [dbo].[Order](
	[OrderId] [int] NOT NULL,
	[TimeOfOrder] [time](7) NOT NULL,
	[TimeOfDelivery] [time](7) NOT NULL,
	[TotalDistance] [float] NOT NULL,
	[DateOfOrder] [date] NOT NULL,
	[FromAddress] [varchar](max) NOT NULL,
	[ToAddress] [varchar](max) NOT NULL,
	[ReceivedBy] [varchar](max) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[PaymentId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)
)ON [PRIMARY]
GO

ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO

ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Product]
GO

CREATE TABLE [dbo].[Payment](
	[PaymentId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CustomerName] [varchar](max) NOT NULL,
	[OrderTotal] [float] NOT NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)
)ON [PRIMARY]
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [FK_Payment] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerId])
GO

ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment]
GO


CREATE TABLE [dbo].[SafetyBox](
	[BoxId] [int] NOT NULL,
	[BoxSize] [varchar](50) NOT NULL,
	[OrderId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_SafetyBox] PRIMARY KEY CLUSTERED 
(
	[BoxId] ASC
)
)ON [PRIMARY]
GO


ALTER TABLE [dbo].[SafetyBox]  WITH CHECK ADD  CONSTRAINT [FK_SafetyBox_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([EmpId])
GO

ALTER TABLE [dbo].[SafetyBox] CHECK CONSTRAINT [FK_SafetyBox_Employee]
GO


CREATE TABLE [dbo].[Vehicles](
	[VehicleRegistrationNo] [nvarchar](50) NOT NULL,
	[VehicleType] [varchar](max) NOT NULL,
	[Make] [varchar](max) NOT NULL,
	[Model] [varchar](max) NOT NULL,
	[InsuranceNo] [nvarchar](50) NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED 
(
	[VehicleRegistrationNo] ASC
)
)ON [PRIMARY]
GO

ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK_Vehicles_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([EmpId])
GO

ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK_Vehicles_Employee]
GO

/***********CREATE TABLE ENDS***************/



/*****STORED PROCEDURES FOR P2P*****/


/********Procedure 1 returns employees tha have completed the highest orders**************/



CREATE PROCEDURE GetEmployeesWithMaxOrders
AS
Begin

Select e.EmpName , es.NoOfOrders
from Employee e JOIN EmployeeSalary es on e.EmpId = es.EmpId
Where es.NoOfOrders = (
Select Max(NoOfOrders) From EmployeeSalary
)
END

/*********Additional Query that returns employees with over 50 Orders************/


--Select e.EmpName , es.NoOfOrders
--from Employee e JOIN EmployeeSalary es on e.EmpId = es.EmpId
--Where es.NoOfOrders > 50

EXEC GetEmployeesWithMaxOrders

/********Procedure 2 returns details of the customers who have given ratings***************/

CREATE PROCEDURE getCustomerBasedOnRatings @compRating INT
AS
BEGIN

Select c.CustomerName ,c.CustPhoneNo, c.CustEmail, cf.CompanyRating
from Customer c JOIN CustomerFeedback cf on c.CustomerId = cf.CustomerId
Where CompanyRating = @compRating
END;

EXEC getCustomerBasedOnRatings '5'


/********************Proedure 3 returns details of the vehicle being used by the employee*********************/

CREATE Proc spGetVehiclesAssignedToEmployees
@EmployeeId int
WITH ENCRYPTION
As
BEGIN
SELECT e.EmpName,v.VehicleType,v.make,v.VehicleRegistrationNo
FROM Vehicles v JOIN Employee e ON v.EmpId =e.EmpId
WHERE v.EmpId = @EmployeeId 
END

/* Excecute Proc */
EXEC spGetVehiclesAssignedToEmployees 65

/* to get contents of Proc */
sp_helptext spGetVehiclesAssignedToEmployees

/***********************Procedure 4 retruns orders of the employee using input and output paramters**********/

CREATE PROC spGetTotalNoOfOrderByEmployee
@EmployeeId int,
@NoOfOrders int output
As
BEGIN
--DECLARE @NoOfOrder int
SELECT Count(OrderId) AS TotalOrders
FROM [Order]
WHERE EmpId =@EmployeeId
END

/* Excecute Proc */
DECLARE @count int;
EXEC spGetTotalNoOfOrderByEmployee
@EmployeeId = 69 ,
@NoOfOrders= @count OUTPUT


/* to get contents of Proc */
sp_helptext spGetTotalNoOfOrderByEmployee



/****************************Views******************************************/

CREATE VIEW VwProductByCateogry
As
SELECT c.CustomerId ,c.CustomerName,o.OrderId,o.DateOfOrder,p.ProductCategory
FROM Customer c JOIN [Order] o ON c.CustomerId = o.CustomerId 
JOIN Product p  ON   p.ProductId = o.ProductId
WHERE p.ProductCategory = 'Industrial';

/* To excecute View */
SELECT * FROM VwProductByCateogry


/*********************************View 2**************************/

CREATE VIEW VwEmployeeRating
As
SELECT COUNT(e.EmpId) as TotalEmployee,f.EmployeeRating
FROM Employee e JOIN CustomerFeedback f ON e.EmpId = f.EmpId
WHERE f.EmployeeRating >3
GROUP BY f.EmployeeRating;

/* To excecute View */
SELECT * FROM VwEmployeeRating




/****************************TRIGGERS*****************************/


/**************************TRIGGER 1********************************/

USE [P2P]
GO

/****** Object:  Table [dbo].[Employee]    Script Date: 11/27/2019 11:38:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmployeeAudit](
	[EmployeeAuditId] int primary key identity(1,1),
	[EmpId] [int] NOT NULL,
	[EmpName] [nvarchar](max) NOT NULL,
	[EmpPhoneNo] [bigint] NULL,
	[EmpEmail] [nvarchar](max) NOT NULL,
	[EmpSSN] [int] NOT NULL,
	[EmpResAddress] [varchar](max) NOT NULL,
	[LicenseNo] [varchar](max) NOT NULL,
	[MedicalInsuranceNo] [varchar](max) NOT NULL,
	[updated_at] DATETIME NOT NULL,
    [operation] CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);
	
CREATE TRIGGER tr_EmployeeAudit
ON Employee
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO EmployeeAudit( 
        [EmpId],
        [EmpName],
        [EmpPhoneNo],
        [EmpEmail],
        [EmpSSN], 
        [EmpResAddress], 
        [LicenseNo],
		[MedicalInsuranceNo],
		[updated_at],
		[operation]

    )
    SELECT
        i.EmpId
        EmpName,
        EmpPhoneNo,
        EmpPhoneNo,
        EmpEmail,
        EmpSSN,
		EmpResAddress,
		LicenseNo,
		MedicalInsuranceNo,
		GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.EmpId
        EmpName,
        EmpPhoneNo,
        EmpPhoneNo,
        EmpEmail,
        EmpSSN,
		EmpResAddress,
		LicenseNo,
		MedicalInsuranceNo,
        GETDATE(),
        'DEL'
    FROM
        deleted d;
END	
	
	Insert into employee values(22,	'Avani Iddalgi',9825238303	,'avani_acb.com',885566992	,'10 Randy Street',	'372301613580123','5602223984078667');
	select * from EmployeeAudit
	
	delete from Employee where EmpId =22;
	select * from EmployeeAudit
	
/*************************************************TRIGGER 2*************************************/



USE [P2P]
GO

/****** Object:  Table [dbo].[SafetyBox]    Script Date: 11/23/2019 12:45:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SafetyBoxAudit](
	[BoxAuditId] int primary key identity(1,1),
	[BoxId] int ,
	[BoxSize] [varchar](50) NOT NULL,
	[Action] char(50),
	ActionDate datetime);

CREATE TRIGGER tr_boxChanges_ForUpdate ON dbo.SafetyBox
FOR UPDATE   /* update,delete,insert */
AS
BEGIN
insert into dbo.SafetyBoxAudit(BoxId,BoxSize,[Action],ActionDate)
SELECT b.BoxId, b.BoxSize,'U',GETDATE()
FROM deleted b   /* inserted */
end

UPDATE SafetyBox SET BoxSize ='S' where BoxId = '125'

UPDATE SafetyBox SET BoxSize ='L' where BoxId = '140'
select * from SafetyBoxAudit




/***********CONSTRAINTS FOR TABLES********************/

ALTER TABLE CustomerFeedback
ADD CONSTRAINT CHK_EmployeeRating CHECK (EmployeeRating<=5);

ALTER TABLE CustomerFeedback
ADD CONSTRAINT CHK_CompanyRating CHECK (CompanyRating<=5);

ALTER TABLE SafetyBox
ADD CONSTRAINT CHK_BoxSize CHECK (BoxSize IN ('S','M','L','XS','XL','2XL','3XL'));

ALTER TABLE Customer
ADD CONSTRAINT CHK_CustPhoneNo CHECK(CustPhoneNo NOT LIKE '%[^0-9]%');
	


/*****FUNCTIONS FOR P2P*********/

/******************generate computed column based on the order id and the distance********************/


CREATE FUNCTION dbo.GetDistance(@OrderId int)
RETURNS varchar(20)
AS   
-- Returns the Distance.  
BEGIN  
    DECLARE @ret varchar(20)
SELECT @ret =
CASE 
WHEN o.TotalDistance<10 then 'Very Short'
WHEN o.TotalDistance BETWEEN 11 and 20 then 'Short'
WHEN o.TotalDistance BETWEEN 21 and 35 then 'Medium'
WHEN o.TotalDistance BETWEEN 36 and 50 then 'Large'
WHEN o.TotalDIstance >50 then 'Very Large'
end
FROM [Order] o
where o.OrderId =@OrderId
    RETURN @ret;  
END;

select dbo.GetDistance(175) AS Distance;


/**************function 2********************************/

/**generate Bonus amount by adding an extra column in the employeesalary using a formula**/

CREATE FUNCTION dbo.Incentive
(
   @empID int
)
returns int
AS
Begin
Declare @orders int , @ratings int


Select @orders = es.NoOfOrders from EmployeeSalary es
where es.EmpId = @empID

Select @ratings = c.EmployeeRating
from CustomerFeedBack c Join [Order] oc on c.EmpId = oc.EmpId


RETURN @Orders + (@ratings)*20

END

Select dbo.Incentive(63) as Incentives;

/************************function 3*******************************/

/*******************generates amount of the order based on the distance of the order*************/

CREATE FUNCTION dbo.GetOrderAmount
(

@CustomerId int

)
returns float
AS
Begin

DECLARE @distance float
Select @distance = o.TotalDistance from [Order] o
JOIN Customer c on o.CustomerId = c.CustomerId
Where @CustomerId = c.CustomerId


RETURN 20+(1.2*@distance)

END

Select dbo.GetOrderAmount(45) AS OrderAmount


/********************Non index clusters************/


CREATE NONCLUSTERED INDEX IX_CustomerSSN
ON Customer(SSN);

CREATE NONCLUSTERED INDEX IX_AcountNo
ON EmployeeSalary(AccountNo);

CREATE NONCLUSTERED INDEX IX_Customer
ON [Order](CustomerId,OrderId);



/*********************ENCRYPTION************************/



/*To create Master Key*/

/*To encrypt SSN from EMPLOYEE TABLE*/

CREATE MASTER KEY ENCRYPTION BY
PASSWORD = 'Teamwork';
GO

GO
/*Encrypt Employee SSN*/
CREATE CERTIFICATE empssn
WITH SUBJECT = 'EmpSSN';
GO

CREATE SYMMETRIC KEY SSN_Key_3
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE empssn;
GO

OPEN SYMMETRIC KEY SSN_Key_3
DECRYPTION BY CERTIFICATE empssn;

ALTER TABLE EMPLOYEE
ADD EncryptedSSN varbinary(max);

UPDATE Employee SET EncryptedSSN = ENCRYPTBYKEY(KEY_GUID('SSN_Key_3'), CONVERT(varbinary(max),EmpSSN));
GO

ALTER TABLE Employee DROP Column EmpSSN;

Select * from Employee
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* To encrypt Employee Salary from Employee Salary Table*/
CREATE CERTIFICATE empsalary
WITH SUBJECT = 'Amount';
GO

CREATE SYMMETRIC KEY SSN_Key_4
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE empsalary;
GO

OPEN SYMMETRIC KEY SSN_Key_4
DECRYPTION BY CERTIFICATE empsalary;

ALTER TABLE EmployeeSalary
ADD EncryptedSalary varbinary(max);

UPDATE EmployeeSalary SET EncryptedSalary = ENCRYPTBYKEY(KEY_GUID('SSN_Key_4'), CONVERT(varbinary(max),Amount));
GO

ALTER TABLE EmployeeSalary DROP COLUMN Amount;

Select * from EmployeeSalary

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*To encrypt Credit Card Number)*/
CREATE CERTIFICATE CustomerCardNo
WITH SUBJECT = 'CardNo';
GO

CREATE SYMMETRIC KEY SSN_Key_5
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CustomerCardNo;
GO

OPEN SYMMETRIC KEY SSN_Key_5
DECRYPTION BY CERTIFICATE CustomerCardNo;

ALTER TABLE Customer
ADD EncryptedCardNo varbinary(max);

UPDATE Customer SET EncryptedCardNo = ENCRYPTBYKEY(KEY_GUID('SSN_Key_5'), CONVERT(varbinary(max),CardNo));
GO

ALTER TABLE Customer DROP Column CardNo;

SELECT * FROM Customer