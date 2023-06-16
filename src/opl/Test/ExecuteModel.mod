/*********************************************
* OPL 12.10.0.0 Data
* Author: Davide Montagno Bozzone
* Creation Date: 2023-06-16 17:46:12.595702
*********************************************/
/*********************************************

* OPL 12.10.0.0 Data

* Author: Davide Montagno Bozzone

* Creation Date: 2023-01-18 22:05:00.459196

*********************************************/





{int} Drones = ...;



{int} Reqs = ...;







float Cost_CPU_d[Drones] = ...;

float Cost_CPU_d_idle[Drones] = ...;



float Capacity_CPU_d[Drones] = ...;

float InstPowerVolo[Drones] = ...;



float CA[Drones] = ...;



float CB[Drones] = ...;



float Cost_Radio_d[Drones] = ...;



float Cost_Radio_d_idle[Drones] = ...;

float Capacity_Radio_d[Drones] = ...;



float BJ[Drones] = ...;



float Max_Capacity_BS= ...;



int length_max = ...;



int Length_VNF_r[Reqs] = ...; 



range D = 0..(card(Drones));



range C = 0..length_max;



dvar boolean Decision[Reqs][C][D][D];



float Workloads_r[Reqs][0..3] = ...;
dvar float+ z;





minimize
  		

	z;



		



		







subject to{

	z>=0;

    

	 ObjectiveFunction:

	 forall(d in 0..card(Drones)-1)

	 z>=

		 (



				(



				InstPowerVolo[d]+



					(

						//Instantaneous Power overall requests considering only radio and cpu active

						sum(r in Reqs)



						(



							(



								

								//Instantaneous Power level 0 for request "r"

								( 



									Decision[r][0][d][d] *  (Workloads_r[r][0] / Capacity_Radio_d[d]) * Cost_Radio_d[d] 



									+ 



									(Decision[r][0][d][card(Drones)]* ((Workloads_r[r][0] / Capacity_Radio_d[d])*2)) * Cost_Radio_d[d]



								) + 

								//Instantaneous Power overall levels for request "r"

								sum(c in 0..(Length_VNF_r[r])-1)

								(



									(

	

											

	

											Decision[r][c][d][card(Drones)] *( Workloads_r[r][c] / Capacity_Radio_d[d]  ) * Cost_Radio_d[d]

	

									)



								)

								+

								sum(c in 1..(Length_VNF_r[r]))

								(



									(

	

											Decision[r][c-1][d][d] * (Workloads_r[r][c-1] / Capacity_CPU_d[d])  * Cost_CPU_d[d]

											

											

									)



								)

								



							)

						)

					)

					

					+ 

					//Percentage of CPU in idle

					Cost_CPU_d_idle[d]*

					( 

						1 - 

						

						sum(r in Reqs)



						(



							(



								



								



								sum(c in 1..(Length_VNF_r[r]))

								(



									(

	

											Decision[r][c-1][d][d] * (Workloads_r[r][c-1] / Capacity_CPU_d[d]) 

											

											

									)



								)

								



							)

						)

						

						

					)

					

					+ 

					//Percentage of Radio in idle

					Cost_Radio_d_idle[d]*

					( 

						1 - 

						

						sum(r in Reqs)



						(



							(



								



								( 



									Decision[r][0][d][d] * (Workloads_r[r][0] / Capacity_Radio_d[d]) +

									(Decision[r][0][d][card(Drones)]* ((Workloads_r[r][0] / Capacity_Radio_d[d])))*2



								) + 



								sum(c in 1..(Length_VNF_r[r]))

								(



									(

	

											Decision[r][c][d][card(Drones)] * (Workloads_r[r][c] / Capacity_Radio_d[d]) 

	

									)



								)



							)

						)

						

						

					)



			)/(BJ[d] - CA[d] - CB[d])	

		 );



     

	

	ctIdlePercentageCPU:

	

	forall(d in 0..(card(Drones)-1))

	 (

			(

					(



						sum(r in Reqs)



						(



							(



								



								sum(c in 1..(Length_VNF_r[r]))

								(



									(

	

											Decision[r][c-1][d][d] * (Workloads_r[r][c-1] / Capacity_CPU_d[d]) 

											

											

									)



								)

								

								



							)

						)

					)



			)	 <= 1



	 );

	

	ctIdlePercentageRadio:

	

	forall(d in 0..(card(Drones)-1))

	 (

			(

					(



						sum(r in Reqs)



						(



							(



								



								( 



									Decision[r][0][d][d] *  ( (Workloads_r[r][0] / Capacity_Radio_d[d]) )   + 

									(Decision[r][0][d][card(Drones)]* ((Workloads_r[r][0] / Capacity_Radio_d[d])))*2



								) + 



								sum(c in 1..(Length_VNF_r[r]))

								(



									(

	

											Decision[r][c][d][card(Drones)] * (Workloads_r[r][c] / Capacity_Radio_d[d]) 

	

									)



								)



							)

						)

					)



			)	 <= 1



	 );

	



	



    





	ctCapacityBS: 

	(

	

		sum(r in Reqs)

		(

			

			(	

				

				(

					sum(c in 0..Length_VNF_r[r]-1)

					(

						sum(i in 0..card(Drones)-1)

							Decision[r][c][i][card(Drones)] * Workloads_r[r][c]

					)

					+

					sum(c in 0..Length_VNF_r[r]-1)

					(

						

							Decision[r][c][card(Drones)][card(Drones)] * Workloads_r[r][c]

					)

					

				)

			)

		)

	

	)<=Max_Capacity_BS;

	

	

	



  		



    





    



  



  	

	ctLevel0:

	forall(r in Reqs){

			(

			

				(

					sum(i in 0..card(Drones)-1)

						((Decision[r][0][i][i] +  Decision[r][0][i][card(Drones)]))

				)

				

				+

				(

						((Decision[r][0][card(Drones)][card(Drones)]))

				)

			

			)==1;

		   }



	ctLevelLast:



	



	forall(r in Reqs){





				sum(i in 0..card(Drones))(



						(Decision[r][Length_VNF_r[r]][i][card(Drones)]) 

				)==1;

						

		   } 

		   forall(r in Reqs){





				sum(i in 0..card(Drones)-1)(



						(Decision[r][Length_VNF_r[r]][i][i]) + (Decision[r][Length_VNF_r[r]][card(Drones)][i])

				)==0;

						

		   } 

		

	ctFlow:   

	forall(r in Reqs)



		   forall(c in 1..(Length_VNF_r[r]))



				forall(i in 0..card(Drones)-1){



						( (Decision[r][c-1][i][i]==Decision[r][c][i][card(Drones)] + Decision[r][c][i][i]))  ;

						

		   }  



	ctFlowBSContinum:	 

	forall(r in Reqs)



		   forall(c in 1..(Length_VNF_r[r])-1)



				forall(i in 0..card(Drones)){



						( (Decision[r][c-1][i][card(Drones)] - Decision[r][c][card(Drones)][card(Drones)])  ) <=0  ;

						

						

		   }   

		  

	

}



main {

  thisOplModel.generate();

  cplex.solve();



  var ofile = new IloOplOutputFile("modelRun.txt");



  ofile.writeln(thisOplModel.printExternalData());



  ofile.writeln(thisOplModel.printInternalData());



  ofile.writeln(thisOplModel.printSolution());



  ofile.close();

}

