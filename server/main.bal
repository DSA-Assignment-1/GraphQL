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
int superId;
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
   int SupGrade;
   int SuperID;
};



service /perf on new  graphql:Listener(9090) {
 
    private final mysql:Client db;
    function init() returns error? {
     self.db = check new ("localhost", "root", "Gr2001", "GraphQl", 3306);
    }
 

// function doesObjectiveExist(departmentObjectives) returns boolean {
//     sql:Connection conn = check database->obtain();
//     sql:PreparedStatement stmt = check conn->prepareStatement("SELECT objId FROM departmentObjectives WHERE objId = ?");
//     stmt->setInt(1, id);
//     stream<departmentObjectives, sql:Result> result = check stmt->executeQuery();
    
//     if (result.length() > 0) {
//         return true;
//     } else {
//         return false;
//     }
// }

   //THIS IS FOR THE HOD
    
     resource function get doesObjectiveExist(int deliveryIdv) returns string|error  {
        // Execute simple query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM departmentobjectives WHERE  objId = ${deliveryIdv}`;
         stream<departmentDeliverables, sql:Error?> resultStream =   self.db->query(result);
         int result1=0;

        //   foreach departmentObjectives item in resultStream{
        //     if(item.ObjDescription !=""){
        //         result1="description found!";
        //     }
        //  }
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
                    INSERT INTO departmentobjectives
                     VALUES (${objective.deliveryId}, ${objective.deliveryDescription})`);

         //io:println(objective.objId);
         if result.affectedRowCount>0{
         return ("Succesfuly added objective");
       } else {
        return error("Failed to add objective");
       } 
            
  
}

  remote function deleteDepartmentObjectives(int deliveryIdv) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM departmentobjectives WHERE deliveryId = ${deliveryIdv}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted objective");
       } else {
        return error("Failed to delete objective");
       }  
}
 
   remote function AssignSupervisor(assignSupervisor obj) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`UPDATE EMPLOYEE SET Supervisor =${obj.superId} WHERE empID = ${obj.empId}`);

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

    resource function get checkEmpKpi(int empId) returns KPI|error {
       // Execute simple query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM KPI WHERE  empID = ${empId}`;
         stream<KPI, sql:Error?> resultStream =   self.db->query(result);
         //int result1=0;
         check from KPI vr1 in resultStream
         do{
            return vr1;
         };
         return { KpiName: "", Metric: "",KpiScore:0,Grade: 0 ,ApprovalStatus: "",empID:0};
    }
  


     // THIS IS FOR THE Supervisor

       remote function DeleteEmployeeKPI(int empID1) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM KPI WHERE empID = ${empID1}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted KPI");
       } else {
        return error("Failed to delete KPI");
       }  
}

   remote function UpdateEmployeeKPIs(KPI_Input updateKpi) returns string|error? {
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

   remote function GradeemployeeKPIs(grade_Kpi gkp) returns string|error? {
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


     //THIS IS FOR THE Employee

     remote function CreateemployeeKPIs(create_KPI crt) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    INSERT INTO KPI(KpiName,Metric,empID)
                     VALUES (${crt.KpiName}, ${crt.Metric},${crt.empID})`);

         //io:println(objective.objId);
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
       SupGrade = ${scr.SupGrade}
      WHERE SuperID = ${scr.SuperID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  Graded!");
       } else {
        return error("Failed to Grade!");
       } 
   }
}