insert into workers ( Workercode, Workername, Gender, Birthdate, Identityno, Workerbarcode )
values ( '12345678901','Ekin Candaþ','E','19900101','12345678901',NEWID() )

select * from workers            --çalýþan tablosu
select * from workertransactions --çalýþan iþe giriþ çýkýþ tablosu

--truncate table workers
--truncate table workertransactions

insert into workertransactions ( WorkerId, Date_, Iotype, GateId )
values ( '1','2022-03-04 10:00:00','G','1' )

insert into workertransactions ( WorkerId, Date_, Iotype, GateId )
values ( '1','2022-03-04 12:00:00','Ç','3' )

insert into workertransactions ( WorkerId, Date_, Iotype, GateId )
values ( '1','2022-03-04 12:30:00','G','2' )

insert into workertransactions ( WorkerId, Date_, Iotype, GateId )
values ( '1','2022-03-04 13:30:00','Ç','1' )

-------------------------------------------------ilk procedure 

--drop procedure Sp_Card_Control

create procedure Sp_Card_Control
( @workerbarcode as varchar(50) )

as

Begin

	if exists ( select * from workers where workerbarcode = @workerbarcode )
		Begin
			Select 'Kart Doðru'
		End
	Else
		Begin
			Select 'Kart Yanlýþ'
		End
End

-------alter proc 1

alter procedure Sp_Card_Control
( @workerbarcode as varchar(50) )

as

Begin

	Declare @workername as varchar (100)

	select @workername = workername from workers where workerbarcode = @workerbarcode
	
	if @workername is NULL
		Begin
			RAISERROR ('Geçersiz kart',16,1 )
			Return 
		End
	Else
		Begin
			Select @workername 
		End

End

exec Sp_Card_Control  'B0E3A47C-0E23-4B51-B221-B4A55BC89E2F'                  --1
exec Sp_Card_Control  @workerbarcode = 'B0E3A47C-0E23-4B51-B221-B4A55BC89E2F' --2

-------------------------------------------------2. procedure 

Create procedure Sp_worker_Inout ( @Workerbarcode as varchar(50), @Date as varchar(50), @Iotype as varchar(1), @Gateid as int )
As

Begin

	Declare @workername as varchar (100)
	Declare @workerid as int
	Declare @lastio as varchar (1)

	Select @workername=workername, @workerid = Id from workers where Workerbarcode = @Workerbarcode

	If @workerid is NULL
		Begin
			raiserror ('Okutulan kart geçersizdir!',16,1)
			Return
		End
	
	Select Top 1 @lastio = Iotype from workertransactions where  WorkerId = @workerid and Date_ > = convert (date,getdate()) order by Date_ desc

	If @lastio = @Iotype
		Begin
			If @Iotype = 'G'
				Begin 
					Raiserror ( 'Zaten Ýçeridesiniz',16,1 )
					Return
				End
			If @Iotype = 'Ç'
				Begin 
					Raiserror ( 'Zaten Dýþarýdasýnýz',16,1 )
					Return
				End
		End

	Insert Into workertransactions ( WorkerId, Date_, Iotype, GateId ) values ( @workerid,@Date, @Iotype  , @Gateid )


End

--( @Workerbarcode as varchar(50), @Date as varchar(50), @Iotype as varchar(1), @Gateid as int )

select * from workers            
select * from workertransactions 

exec Sp_worker_Inout 'B0E3A47C-0E23-4B51-B221-B4A55BC89E2F','2022-03-04 14:00:00','G','1'
exec Sp_worker_Inout @Workerbarcode = 'B0E3A47C-0E23-4B51-B221-B4A55BC89E2F',
					 @Date = '2022-03-04 14:00:00',
					 @Iotype = 'G',
					 @Gateid = '1'




