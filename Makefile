all: 	compile sim
# dont compile the trial.sv before compiling the design and the interface and the package 
# The order makes a difference 
# if u want to dont care about the the order of compilation check file trial_no_order.sv
compile:
		vlib work
		vlog -sv tb_classes.sv  Door_Contoller.sv 

sim:
		vsim -logfile sim.log -c  -wlf Door_Controller.wlf -voptargs="+acc" -do "run -all" work.Door_Controller_tb
		vcd2wlf Door_Controller.vcd Door_Controller.wlf

sim_vcd :
		vsim -logfile sim.log -c -do "vcd file sim.vcd; vcd add -r /*; run -all; vcd flush; quit" work.state_machine_oop

wave:
		vsim -view Door_Controller.wlf
