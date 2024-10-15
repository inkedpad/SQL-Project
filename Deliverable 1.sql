

--- Creation Of AHT_Table

/*
SELECT 
    agent_id,
    NumberOfCalls,
    total_time,
    total_time / NULLIF(NumberOfCalls, 0) AS AHT  -- Avoid division by zero
INTO 
    AHT_Table  -- This is the new table that will be created
FROM (
    SELECT 
        agent_id,
        COUNT(*) AS NumberOfCalls,
        SUM(DATEDIFF(SECOND, call_start_datetime, call_end_datetime)) AS total_time
    FROM 
        Calls
    GROUP BY 
        agent_id
) AS CallData;
*/

--- Creation Of AST_Table

/*
SELECT 
    agent_id,
    NumberOfCalls,
    total_waiting_time,
    total_waiting_time / NULLIF(NumberOfCalls, 0) AS AST  -- Avoid division by zero
INTO
	AST_Table
FROM (
    SELECT 
        agent_id,
        COUNT(*) AS NumberOfCalls,
        SUM(DATEDIFF(SECOND, call_start_datetime, agent_assigned_datetime)) AS total_waiting_time
    FROM 
        Calls
    GROUP BY 
        agent_id
) AS CallData
;
*/

---- Creation of joined Call id and Reason Table
/*
SELECT Calls.call_id, agent_id, primary_call_reason, call_start_datetime, agent_assigned_datetime, call_end_datetime

INTO Call_Id_Reason_Table

FROM Reasons

JOIN Calls
  ON reasons.call_id = calls.call_id
;

*/

---- CReation of AHT grouped BY reason

/* 
SELECT 
    primary_call_reason,
    NumberOfCalls,
    total_time,
    total_time / NULLIF(NumberOfCalls, 0) AS AHT  -- Avoid division by zero
INTO
	AHT_GroupedBy_Reason_Table
  
FROM (
    SELECT 
        primary_call_reason,
        COUNT(*) AS NumberOfCalls,
        SUM(DATEDIFF(SECOND, agent_assigned_datetime, call_end_datetime)) AS total_time
    FROM 
       call_id_reason_Table
    GROUP BY 
        primary_call_reason

) AS Call_reason_AHT_DATA

ORDER BY NumberOfCalls DESC;
*/


------- CReation of AST grouped BY reason Table
/*

SELECT 
    primary_call_reason,
    NumberOfCalls,
    total_time,
    total_time / NULLIF(NumberOfCalls, 0) AS AST  -- Avoid division by zero
INTO
	AST_GroupedBy_Reason_Table
	
FROM (
    SELECT 
        primary_call_reason,
        COUNT(*) AS NumberOfCalls,
        SUM(DATEDIFF(SECOND, call_start_datetime, agent_assigned_datetime)) AS total_time
    FROM 
       call_id_reason_Table
    GROUP BY 
        primary_call_reason

) AS Call_reason_AST_DATA

ORDER BY NumberOfCalls DESC;
*/

----Creation of Sentiment_GroupedBy_Agent_Table

/*
SELECT 
    agent_id,
    NumberOfCalls,
    sentiment_per_agent,
    silence / NULLIF(NumberOfCalls, 0) AS silence_per_agent 

INTO
	Sentiment_GroupedBy_Agent_Table
FROM (
    SELECT 
        agent_id,
        COUNT(*) AS NumberOfCalls,
		SUM(average_sentiment) AS  sentiment_per_agent,
		SUM(silence_percent_average) AS silence

       
    FROM 
        sentiment_statistics
    GROUP BY 
        agent_id
	
) AS temp

*/
----Creation of Call_duration_AHTAST_GroupedBy_agentId Table

/*
SELECT AHT_Table.agent_id, AHT+AST AS Call_Duration, sentiment_per_agent, silence_per_agent
INTO
	CallDuration_Sentiment_GroupedByAgentId_Table

FROM AHT_Table
JOIN AST_Table
  ON AHT_Table.agent_id = AST_Table.agent_id
JOIN Sentiment_GroupedBy_Agent_Table
  ON AHT_Table.agent_id = Sentiment_GroupedBy_Agent_Table.agent_id
 
ORDER BY sentiment_per_agent 
;
*/

--- Creation of Call Duration Grouped By Sentiment Table
/*
SELECT 
    primary_call_reason,
    NumberOfCalls,
    total_time_agent,
    total_time_agent / NULLIF(NumberOfCalls, 0) AS AHT,  -- Avoid division by zero
	total_time_queue,
	total_time_queue / NULLIF(NumberOfCalls, 0) AS AST,
    (total_time_agent / NULLIF(NumberOfCalls, 0)) + (total_time_queue / NULLIF(NumberOfCalls, 0)) AS Call_Duration

INTO
	Call_Duration_GROUPEDBY_Sentiment
	
FROM (
    SELECT 
        primary_call_reason,
        COUNT(*) AS NumberOfCalls,
        SUM(DATEDIFF(SECOND, agent_assigned_datetime, call_end_datetime)) AS total_time_agent,
		SUM(DATEDIFF(SECOND, call_start_datetime, agent_assigned_datetime)) AS total_time_queue
    FROM 
       call_id_reason_Table
    GROUP BY 
        primary_call_reason

) AS Call_reason_AHTAST_DATA

ORDER BY NumberOfCalls DESC;
*/



/*
Select Primary_Call_Reason, Call_Duration 
from Call_Duration_GROUPEDBY_Sentiment
ORDER BY call_duration DESC;


Select * from CallDuration_Sentiment_GroupedByAgentId_Table
ORDER BY Call_Duration DESC;


Select * from Sentiment_GroupedBy_Agent_Table
ORDER BY Numberofcalls DESC
; ---Agents which were assigned many calls had this sentiment and silence


Select * from AHT_GroupedBy_Reason_Table
ORDER BY AHT DESC

Select * from AST_GroupedBy_Reason_Table   ---- CAN AUTOMATE THIS!
Order by AST DESC;


Select * from AHT_GroupedBy_Reason_Table
ORDER BY NumberOfcalls DESC

*/

/*
Select * from Customers;
Select * from reasons;
Select * from Calls;
*/

----Creation of master table including calls, customer and reasons
/*
SELECT calls.call_id, calls.customer_id, calls.agent_id, primary_call_reason, customer_name, elite_level_code
INTO Customer_Call_Reason_MasterTable
FROM Calls
JOIN Reasons
  ON Calls.call_id = Reasons.call_id
LEFT JOIN Customers
  ON Calls.customer_id = Customers.customer_id;
  */



  

  --- 2nd Deliverable
  /*
  Select primary_call_reason, Count(*) AS Reason_Frequency, AVG(elite_level_code) AS Average_Elite_Value
  from Customer_Call_Reason_MasterTable
  WHERE elite_level_code IS NOT NULL
  GROUP BY primary_call_reason
  ORDER BY Average_Elite_Value DESC;

  
  Select primary_call_reason, Count(*) AS Reason_Frequency
  from Customer_Call_Reason_MasterTable
  GROUP BY primary_call_reason
  ORDER BY Reason_Frequency DESC;
  */


  ---3rd Deliverable

  /*
  SELECT primary_call_reason, AVG(average_sentiment) as Sentiment, AVG(silence_percent_average) AS Silence
FROM sentiment_statistics s
JOIN reasons r
  ON s.call_id = r.call_id
 GROUP BY primary_call_reason
 ORDER BY Sentiment;
 */



