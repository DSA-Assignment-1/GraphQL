import ballerina/graphql;
import ballerina/io;

type departmentDeliverables record {
int deliveryId;
string deliveryDescription;
//string empId;
};

type ProductResponse record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    io:println("****** Performance Management System ********");

    while (true) {
        string option = io:readln("Enter 1 to login as headOfDepartment: \n"+
                                     "Enter 2 to login as departmentSupervisor: \n"+
                                     "Enter 3 to login as staff: \n");

        match option {
            //Login headOfDepartment
            "1" => {
                map<json> intResultLogin =   check checkClient1("headOfDepartment");
                io:println(intResultLogin.data.checkClient);
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // headOfDepartment
                        string headOfDepartment = "";

                       while (headOfDepartment != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                    "Enter 1 to check objective headOfDepartment\n" +
                                                    "Enter 2 to create objective headOfDepartment\n" +
                                                    "Enter 3 to delete objective headOfDepartment\n" +
                                                    "Enter 4 Assign the Employee to a supervisor headOfDepartment\n" +
                                                    "Enter 0 to exit");

                            headOfDepartment = io:readln("Enter choice here: ");

                            
                                 match headOfDepartment {
                                 "1" => {io:println(check doesObjectiveExist1());}
                                 "2" => {io:println(createDepartmentDeliverables1());}
                                 "3" => {io:println(deleteDepartmentDeliverables1());}
                                 "4" => {io:println(AssignSupervisor1());}
                                
                                
                                //Log out of HOD 
                                "0" => {
                                    io:println("Goodbye, leaving library menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }
            //Login Supervisor
              "2" => {
                map<json> intResultLogin  =  check checkClient1("departmentSupervisor");
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // Supervisor
                        string departmentSupervisor = "";

                       while (departmentSupervisor != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                     "Enter 1 check Employee's KPIs departmentSupervisor\n" +
                                                     "Enter 2 Approve Employee's KPIs departmentSupervisor\n" +
                                                     "Enter 3 delete Employee's KPIs departmentSupervisor\n" +
                                                     "Enter 4 update Employee's KPIs departmentSupervisor\n" +
                                                     "Enter 5 grade Employee's KPIs departmentSupervisor\n" +
                                                     "Enter 0 to exit");

                            departmentSupervisor = io:readln("Enter choice here: ");

                            
                                 match departmentSupervisor {
                                 "1" => { io:println(checkEmpKpi1());}
                                 "2" => { io:println(AprroveKpi1());}
                                 "3" => { io:println(DeleteStaffKPI1());}
                                 "4" => { io:println(UpdateStaffKPIs1());}
                                 "5" => { io:println(GradeemployeeKPIs1());}
                                
                                
                                //Log out of Supervisor
                                "0" => {
                                    io:println("Goodbye, leaving the library menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }
         //Employee
           "3" => {
                map<json> intResultLogin =  check checkClient1("staff");
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // Employee
                        string staff = "";

                       while (staff != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                     "Enter 1 create KPI staff\n" +
                                                     "Enter 2 grade supervisior staff\n" +
                                                     "Enter 0 to exit");

                            staff = io:readln("Enter choice here: ");

                            
                                 match staff {
                                 "1" => { io:println( CreateStaffKPIs1());}
                                 "2" => {io:println( GradeSupervisor1());}                                
                                
                                //Log out of Supervisor
                                "0" => {
                                    io:println("Goodbye, leaving the library menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }

            "0" => {
                       io:println("Goodbye, exiting main menu.");
                       break; // Exit the student menu
                                }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
        
    }   
}


function doesObjectiveExist1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int deliveryId1 = check int:fromString(io:readln("Enter the deliveryId"));  

    string doc = string `query doesObjectiveExist($gf: Int!) {
        doesObjectiveExist(deliveryIdv:$gf)
    }`;

      map<json> variables = {"gf": deliveryId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}

function createDepartmentDeliverables1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int deliveryId1 = check int:fromString(io:readln("Enter the deliveryId"));  
    string deliveryDescription = io:readln("Enter the objective discription");

    string doc = string `mutation createDepartmentDeliverables($delcID: Int!,$delvDes:String!) {
       createDepartmentDeliverables(objective:{deliveryId:$delvID,ObjDescription:$delvDes})
    }`;

     map<json> variables = {"obID":deliveryId1,"obDes":deliveryDescription};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

}


function deleteDepartmentDeliverables1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int deliveryId1 = check int:fromString(io:readln("Enter the deliveryId of the description to delete"));  

    string doc = string `mutation deleteDepartmentDeliverables($gf: Int!) {
        deleteDepartmentDeliverables(deliveryIdv:$gf)
    }`;

      map<json> variables = {"gf": deliveryId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}

function AssignSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to")); 

    int superid = check int:fromString(io:readln("Enter the Supervisor id you want to assign to the employee"));  
 

     string doc = string `mutation AssignSupervisor($empID: Int!,$supId:Int!) {
       AssignSupervisor(obj:{empId:$empID,supsId:$supId})
    }`;

      map<json> variables = {"empID": empid,"supsId": superid};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}


function AprroveKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to"));  

    string doc = string `mutation AprroveKpi($empID: Int!) {
       AprroveKpi(empId:$empID)
    }`;

    map<json> variables = {"empID":empid};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}


function checkEmpKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

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


    return ObjResponse;
}

function DeleteStaffKPI1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to delete"));  

    string doc = string `mutation DeleteStaffKPI($gf: Int!) {
        DeleteStaffKPI(empID1:$gf)
    }`;

      map<json> variables = {"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}
    
 function UpdateStaffKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to update"));  
    string KpiName = io:readln("Enter KpiName to update");
    string Metric = io:readln("Enter Metric to update");
    int KpiScore1 = check int:fromString(io:readln("Enter KpiScore to update"));     
    
    string doc = string `mutation UpdateStaffKPIs($gf: Int!, $kpName: String!, $metric: String!, $kapSc: Int!) {
        UpdateStaffKPIs(updateKpi: { empID: $gf, KpiName: $kpName, Metric: $metric, KpiScore: $kapSc })
    }`;

    map<json> variables = {"gf": empId1, "kpName": KpiName, "metric": Metric, "kapSc": KpiScore1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}

   function GradeemployeeKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to grade"));  
    int grade1 = check int:fromString(io:readln("Enter grade"));     
    
    string doc = string `mutation GradeemployeeKPIs($gf: Int!,$gradek: Int!) {
        GradeemployeeKPIs(gkp: { empID: $gf, Grade: $gradek })
    }`;

    map<json> variables = {"gf": empId1,  "gradek": grade1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}
    function CreateStaffKPIs1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    string KpiName = io:readln("Enter the KPI Name");
    string Metric = io:readln("Enter the Metric");
    int empId1 = check int:fromString(io:readln("Enter your empID"));   
   

    string doc = string `mutation CreateStaffKPIs($kpiName: String!,$metric:String!,$gf: Int!) {
       CreateStaffKPIs(crt:{KpiName:$kpiName,Metric:$metric,empID:$gf})
    }`;

     map<json> variables = {"kpiName":KpiName ,"metric":Metric,"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

} 
     function GradeSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:9090/perf");

    
    int empId1 = check int:fromString(io:readln("Enter your empID"));  
    int supsGrade1 = check int:fromString(io:readln("Enter the grade from 1 to 5 ")); 
    int supsID1 = check int:fromString(io:readln("Enter departmentSupervisor ID"));  
   

    string doc = string `mutation GradeSupervisor($gf: Int!,$supsGrade1: Int!,$Super1: Int!) {
       GradeSupervisor(scr:{empID: $gf,SupGrade:$supsGrade1,SuperID:$Super1})
    }`;

     map<json> variables = {"gf":empId1 ,"supsGrade1":supsGrade1,"Super1":supsID1};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

}


function checkClient1(string tbName) returns map<json>|error {
    graphql:Client cli = check new("http://localhost:9090/perf");

    int id = check int:fromString(io:readln("Enter the your ID"));  
    string pass = io:readln("Enter the your Password");  
    string tbName1 =tbName;

    string doc = string `query checkClient($gf: Int!, $ps: String!, $tbn: String!) {
        checkClient(checks:{id:$gf,pass:$ps ,tbname:$tbn})
    }`;

    map<json> variables = {"gf":id ,"ps":pass,"tbn":tbName1};
    map<json>  ObjResponse =  check cli->execute(doc, variables);

    return ObjResponse;

}