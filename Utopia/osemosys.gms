*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* utopia_data.txt
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 4 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 4. You should find that you get an optimal value of 29446.861.
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
*
* declarations for sets, parameters, variables
$eolcom #
$offlisting
$if not set scen $setglobal scen base
$include osemosys_dec.gms
* specify Utopia Model data
$include utopia_data.gms
$include renewables_data.gms
*$include Water_data.gms
* define model equations
$offlisting
$include osemosys_equ.gms

* water limit flags
$ifthen.scen set Riv_5 
TotalAnnualMaxCapacity(r,'RIV',y) = 5;
$setglobal scen Riv_5
$endif.scen

$ifthen.scen set Riv_6 
TotalAnnualMaxCapacity(r,'RIV',y) = 6;
$setglobal scen Riv_6
$endif.scen

$ifthen.scen set Riv_8 
TotalAnnualMaxCapacity(r,'RIV',y) = 8;
$setglobal scen Riv_8
$endif.scen

$ifthen.scen set Riv_10 
TotalAnnualMaxCapacity(r,'RIV',y) = 10;
$setglobal scen Riv_10
$endif.scen

$ifthen.scen set Riv_15 
TotalAnnualMaxCapacity(r,'RIV',y) = 15;
$setglobal scen Riv_15
$endif.scen

* solve the model
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;
option mip = copt;
solve osemosys minimizing z using mip;
* create results in file SelResults.CSV
$include osemosys_res.gms
$include report.gms
execute_unload 'results_%scen%.gdx';
