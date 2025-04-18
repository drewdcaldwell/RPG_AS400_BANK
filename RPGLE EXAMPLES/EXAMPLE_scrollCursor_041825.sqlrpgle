**free
ctl-opt dftactgrp(*no) actgrp(*caller);

***********************************************************************************		
// SCROLL CURSOR EXAMPLE USING MULTIPLE VARIABLES                                 *
***********************************************************************************		

// Declare some variables for the queries

dcl-s item			char(15);
dcl-s facility      char(10);
dcl-s setId 		char(5);
dcl-s bucket		char(5);

// Declare the cursor using SELECT statement

exec sql
	 declare c0 cursor for
	 select i.item, i.facility, i.set, i.bucket
	 from <YOUR_TABLE> i
	 join <ANOTHER_TABLE> o on i.<SOME_KEY> = o.<SOME_KEY>
	 join <TABLE_3> c on o.customerID = c.customerID 
	 where c.status = 'INACTIVE';
	 
// Open the cursor we just created...

exec sql
	 open c0;
	 
// Loop through the results of the first SQL select

dow SQLCODE = 0;
	exec sql
		 fetch c0 into :item, :facility, :setID, :bucket;
	
	if sqlcode = 0;
		exec sql
			 delete from <DELETING_TABLE>
			 where item = :item
			   and facility = :faciltiy
			   and set = setId
			   and bucket = :bucket;
			   
	endif;
enddo;

// Close c0 cursor

exec sql 
	 close deleteCursor;
	 
*inlr = *on
return;
