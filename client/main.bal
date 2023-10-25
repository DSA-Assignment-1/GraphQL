import ballerina/graphql;
import ballerina/io;





type departmentObjectives record {
int objId;
string description;
//string empId;
};

type ProductResponse record {|
    record {|anydata dt;|} data;
|};


public function main()returns  error? {
 //graphql:Client graphqlClient = check new ("localhost:8080/perf");

string option ="10";
 while(option !="0"){
  io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                 "Enter 1 to check objective HOD\n" +
                                                 "Enter 2 to create objective HOD\n" +
                                                 "Enter 3 to delete objective HOD\n" +
                                                 "Enter 4 Assign the Employee to a supervisor HOD\n" +
                                                 "Enter 5 check Employee's KPIs Supervisor\n" +
                                                 "Enter 6 Approve Employee's KPIs Supervisor\n" +
                                                 "Enter 7 delete Employee's KPIs Supervisor\n" +
                                                 "Enter 8 update Employee's KPIs Supervisor\n" +
                                                 "Enter 9 grade Employee's KPIs Supervisor\n" +
                                                 "Enter 10 create KPI Employee\n" +
                                                 "Enter 11 grade supervisior Employee\n" +
                                                 "Enter  0 to exit");
                                                 option = io:readln("Enter choice here: ");

   
   match option {
     "0" => {
                       io:println("Goodbye, exiting main menu.");
                       break; }
    "1" => {
          io:println(check doesObjectiveExist1());
        
    }
    "2"=>{
              io:println(createDepartmentObjectives1());
    }
   
    "3"=>{
        io:println(deleteDepartmentObjectives1());
    }

    "4"=>{
        io:println(AssignSupervisor1());
    }

    "5"=>{
        io:println(checkEmpKpi1());
    }

    "6"=>{
        io:println(AprroveKpi1());
    }

    "7"=>{
        io:println(DeleteEmployeeKPI1());
    }
    "8"=>{
        io:println(UpdateEmployeeKPIs1());
    }

     "9"=>{
        io:println(GradeemployeeKPIs1());
    }
     
    "10"=>{
        io:println( CreateemployeeKPIs1());
    } 

    "11"=>{
        io:println( GradeSupervisor1());
    } 
     
               
   }

 
}
}

type Responses record {
    record { anydata dt; } data;
};


type tah record {
int objIdv;
};

function doesObjectiveExist1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId"));  

    string doc = string `query doesObjectiveExist($gf: Int!) {
        doesObjectiveExist(objIdv:$gf)
    }`;

      map<json> variables = {"gf": objId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}

function createDepartmentObjectives1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId"));  
    string ObjDescription = io:readln("Enter the objective discription");

    string doc = string `mutation createDepartmentObjectives($obID: Int!,$obDes:String!) {
       createDepartmentObjectives(objective:{objId:$obID,ObjDescription:$obDes})
    }`;

     map<json> variables = {"obID":objId1,"obDes":ObjDescription};

    map<json>  ObjResponse = check cli->execute(doc,variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}


function deleteDepartmentObjectives1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId of the description to delete"));  

    string doc = string `mutation deleteDepartmentObjectives($gf: Int!) {
        deleteDepartmentObjectives(objIdv:$gf)
    }`;

      map<json> variables = {"gf": objId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}

function AssignSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to")); 

    int superid = check int:fromString(io:readln("Enter the Supervisor id you want to assign to the employee"));  
 

     string doc = string `mutation AssignSupervisor($empID: Int!,$supId:Int!) {
       AssignSupervisor(obj:{empId:$empID,superId:$supId})
    }`;

      map<json> variables = {"empID": empid,"supId": superid};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}


function AprroveKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to"));  

    string doc = string `mutation AprroveKpi($empID: Int!) {
       AprroveKpi(empId:$empID)
    }`;

    map<json> variables = {"empID":empid};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}


function checkEmpKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empID = check int:fromString(io:readln("Enter the ID of the employee to see thier KPI"));  

    string doc = string `query checkEmpKpi($gf: Int!) {
    checkEmpKpi(empId:$gf) {
        KpiName
        Metric
        KpiScore
        Grade
        ApprovalStatus
        empID
    }
    }`;

      map<json> variables = {"gf": empID};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;
}

function DeleteEmployeeKPI1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to delete"));  

    string doc = string `mutation DeleteEmployeeKPI($gf: Int!) {
        DeleteEmployeeKPI(empID1:$gf)
    }`;

      map<json> variables = {"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}
    
 function UpdateEmployeeKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to update"));  
    string KpiName = io:readln("Enter KpiName to update");
    string Metric = io:readln("Enter Metric to update");
    int KpiScore1 = check int:fromString(io:readln("Enter KpiScore to update"));     
    
    string doc = string `mutation UpdateEmployeeKPIs($gf: Int!, $kpName: String!, $metric: String!, $kapSc: Int!) {
        UpdateEmployeeKPIs(updateKpi: { empID: $gf, KpiName: $kpName, Metric: $metric, KpiScore: $kapSc })
    }`;

    map<json> variables = {"gf": empId1, "kpName": KpiName, "metric": Metric, "kapSc": KpiScore1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}

   function GradeemployeeKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to grade"));  
    int grade1 = check int:fromString(io:readln("Enter grade"));     
    
    string doc = string `mutation GradeemployeeKPIs($gf: Int!,$gradek: Int!) {
        GradeemployeeKPIs(gkp: { empID: $gf, Grade: $gradek })
    }`;

    map<json> variables = {"gf": empId1,  "gradek": grade1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}
    function CreateemployeeKPIs1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    string KpiName = io:readln("Enter the KPI Name");
    string Metric = io:readln("Enter the Metric");
    int empId1 = check int:fromString(io:readln("Enter your empID"));   
   

    string doc = string `mutation CreateemployeeKPIs($kpiName: String!,$metric:String!,$gf: Int!) {
       CreateemployeeKPIs(crt:{KpiName:$kpiName,Metric:$metric,empID:$gf})
    }`;

     map<json> variables = {"kpiName":KpiName ,"metric":Metric,"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc,variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
} 
     function GradeSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    
    int empId1 = check int:fromString(io:readln("Enter your empID"));  
    int SupGrade1 = check int:fromString(io:readln("Enter the grade from 1 to 5 ")); 
    int SuperID1 = check int:fromString(io:readln("Enter supervisor ID"));  
   

    string doc = string `mutation GradeSupervisor($gf: Int!,$SupGrade1: Int!,$Super1: Int!) {
       GradeSupervisor(scr:{empID: $gf,SupGrade:$SupGrade1,SuperID:$Super1})
    }`;

     map<json> variables = {"gf":empId1 ,"SupGrade1":SupGrade1,"Super1":SuperID1};

    map<json>  ObjResponse = check cli->execute(doc,variables);

    // io:println(ObjResponse);

    return ObjResponse;

    //return null; // or an error if needed
}

// function doesObjectiveExist1() returns error? {
//     graphql:Client cli = check new("localhost:8080/perf");
    
//     int objId = check int:fromString(io:readln("Enter the objId"));  
//     string doc = string `
//     query {doesObjectiveExist1(objId: "${objId}") }
//     `;

//     string ObjResponse = check cli->execute(doc, {"id":objId});
//     // Read the objId from user input
//     // int objId = check int:fromString(io:readln("Enter the objId"));  

//     // // Define the GraphQL query
//     // string graphqlQuery = string `
//     //     query {
//     //         doesObjectiveExist1(objId: "${objId}") {
//     //             objId
//     //             description
//     //         }
//     //     }
//     // `;

//     // // Execute the GraphQL query
//     // json response = check cli->execute(graphqlQuery);


//    io:println(ObjResponse);

//     // Handle the response as needed
//     // ...
// }


// }
// function doesObjectiveExist1() returns error? {
//    graphql:Client cli =check new("localhost:8080");
//     string objId = io:readln("Enter the objId");  
//    int objid = check int:fromString(objId);

   
 
   
//    json c1=check cli->/perf/doesObjectiveExist1.get();
   
//     if(c1.objId !=-1){  
//         io:println(c1);}
//         else{io:println("No objective with that number");}
        
    
//    }

//    function doesObjectiveExist1(graphql:Client  graphqlClient, string objId) returns string {
//     // Define your GraphQL query
//     string graphqlQuery = string `
//    query {
//   getObjective(id: objId) {
//     id
//     description
//   }
// }
// `;

//     // Execute the GraphQL query
//     ProductResponse response = check graphqlClient->execute(graphqlQuery);

//      io:println("Response ", response);

//     // if (response is graphql:Success) {
//     //     // The server responds with the result message in the body
//     //     return response.getJsonPayload().toString();
//     // } else {
//     //     // Handle error cases
//     //     return "Error: " + response.toString();
//     // }
// }
  

//   function  getObj() returns error?{
//           string doc = string `
//    query {
//   getObjective(objId: objId) {
//     id
//     description
//   }
// }
// `;

//     // Execute the GraphQL query
//     ProductResponse response = check graphqlClient->execute(doc);

//      io:println("Response ", response);
//   }