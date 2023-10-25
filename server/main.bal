import ballerina/graphql;
import ballerina/sql;
import ballerinax/mysql;
// import ballerina/io;
import ballerinax/mysql.driver as _;
// import ballerina/io;

type headOfDepartment record {
    int headId;
    string headName;
    string headOfficeCode;    
};

type departmentSupervisor record {
int supsId;
string supsName;
int supsGrade;
};

type assignSupervisor record {
int empId;
int supsId;
};

type Employee record {
   int empId;
   string empName;
   //string score;
};

type KPI record  {|
 string KpiName;
 string Metric;
 int KpiScore;
 int Grade ;
 string ApprovalStatus;
 int empID ;
|};

type departmentDeliverables record {
int deliveryId;
string deliveryDescription;
//string empId;
};

type employeeScores record {
int score;
int totalScore;
int grade;
};

type staff record {
int empID;
string empPassword;
string empName;
int score;
int totalScore;
int grade;
int Supervisor;
};

type KPI_Input record {
 string KpiName; 
 string Metric;
 int KpiScore;
 int empID;
};

type grade_Kpi record {
   int Grade;  
   int empID;
};

type create_KPI record{
string KpiName; 
string Metric;
int empID;
};

type GradeSupervisor record{
   int empID;
   int supsGrade;
   int supsID;
};



service /perf on new  graphql:Listener(9090) {
 
    private final mysql:Client db;
    function init() returns error? {
     self.db = check new ("localhost", "root", "Gr2001", "GraphQl", 3306);
    }

   //For head of department
    
     resource function get doesDeliverableExist(int deliveryIdv) returns string|error  {
        // Execute simple query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM departmentdeliverables WHERE  objId = ${deliveryIdv}`;
         stream<departmentDeliverables, sql:Error?> resultStream =   self.db->query(result);
         int result1=0;

        check from departmentDeliverables vr in resultStream
        where vr.deliveryId == deliveryIdv
        do {
            result1=1;
        };
           
           if(result1==1){
            return "description found!";
           }else{
             return "description not found!";
           }
         
    }   
         remote function createDepartmentDeliverables(departmentDeliverables objective) returns string|error? {
               sql:ExecutionResult result=check self.db->execute(`
                    INSERT INTO departmentdeliverables
                     VALUES (${objective.deliveryId}, ${objective.deliveryDescription})`);

         if result.affectedRowCount>0{
         return ("Succesfuly added objective");
       } else {
        return error("Failed to add objective");
       } 
            
  
}

  remote function deleteDepartmentDeliverables(int deliveryIdv) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM departmentdeliverables WHERE deliveryId = ${deliveryIdv}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted objective");
       } else {
        return error("Failed to delete objective");
       }  
}
 
   remote function AssignSupervisor(assignSupervisor obj) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`UPDATE staff SET Supervisor =${obj.supsId} WHERE empID = ${obj.empId}`);

         if result.affectedRowCount>0{
         return ("Succesfully assigned");
       } else {
        return error("Failed to assign");
       }  
}

  remote function AprroveKpi(int empId) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`UPDATE KPI SET ApprovalStatus ="YES" WHERE empID = ${empId}`);

         if result.affectedRowCount>0{
         return ("Succesfully approved");
       } else {
        return error("Failed to approved");
       }  
}

    resource function get checkStaffKpi(int empId) returns KPI|error {
       //query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM KPI WHERE  empID = ${empId}`;
         stream<KPI, sql:Error?> resultStream =   self.db->query(result);
         //int result1=0;
         check from KPI vr1 in resultStream
         do{
            return vr1;
         };
         return { KpiName: "", Metric: "",KpiScore:0,Grade: 0 ,ApprovalStatus: "",empID:0};
    }
  


     //For Supervisor

       remote function DeleteStaffKPI(int empID1) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM KPI WHERE empID = ${empID1}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted KPI");
       } else {
        return error("Failed to delete KPI");
       }  
}

   remote function UpdateStaffKPIs(KPI_Input updateKpi) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
      UPDATE KPI
      SET KpiName =${updateKpi.KpiName},  Metric =${updateKpi.Metric},  KpiScore =${updateKpi.KpiScore}
      WHERE empID =  ${updateKpi.empID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  UPDATED!");
       } else {
        return error("Failed to UPDATE");
       }  
}

   remote function GradeStaffKPIs(grade_Kpi gkp) returns string|error? {
        sql:ExecutionResult result=check self.db->execute(`
      UPDATE KPI
      SET  Grade =${gkp.Grade}
      WHERE empID =  ${gkp.empID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  Graded!");
       } else {
        return error("Failed to Grade!");
       } 
   }


     //For Staff
     remote function CreateStaffKPIs(create_KPI crt) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    INSERT INTO KPI(KpiName,Metric,empID)
                     VALUES (${crt.KpiName}, ${crt.Metric},${crt.empID})`);

         if result.affectedRowCount>0{
         return ("Succesfuly added KPI");
       } else {
        return error("Failed to add KPI");
       } 
 }

    remote function GradeSupervisor(GradeSupervisor scr) returns string|error? {
        sql:ExecutionResult result=check self.db->execute(`
      UPDATE SUPERVISIOR
      SET  empID = ${scr.empID},
       supsGrade = ${scr.supsGrade}
      WHERE supsID = ${scr.supsID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  Graded!");
       } else {
        return error("Failed to Grade!");
       } 
   }
}