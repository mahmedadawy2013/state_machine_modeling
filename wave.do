onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider MODEL
add wave -noupdate /tb_classes_sv_unit::Up_M_model
add wave -noupdate /tb_classes_sv_unit::Dn_M_model
add wave -noupdate -radix symbolic /tb_classes_sv_unit::next_state
add wave -noupdate -radix symbolic /tb_classes_sv_unit::current_state
add wave -noupdate -divider RTL
add wave -noupdate /Door_Controller_tb/DUT/CLK
add wave -noupdate /Door_Controller_tb/DUT/RST
add wave -noupdate -divider {RTL IN}
add wave -noupdate /Door_Controller_tb/DUT/Activate
add wave -noupdate /Door_Controller_tb/DUT/Up_Max
add wave -noupdate /Door_Controller_tb/DUT/Dn_Max
add wave -noupdate -radix binary /Door_Controller_tb/DUT/next_state
add wave -noupdate -radix binary /Door_Controller_tb/DUT/current_state
add wave -noupdate -divider {RTL OUT}
add wave -noupdate /Door_Controller_tb/DUT/Up_M
add wave -noupdate /Door_Controller_tb/DUT/Dn_M
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {146 ns}
