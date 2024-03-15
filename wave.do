onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Main Signal}
add wave -noupdate /test_fir_top/Clk
add wave -noupdate /test_fir_top/instance_fir/rstb
add wave -noupdate -radix decimal /test_fir_top/instance_fir/xn
add wave -noupdate -radix decimal /test_fir_top/instance_fir/yn
add wave -noupdate -radix decimal /test_fir_top/ExpectedOutput
add wave -noupdate -color Green /test_fir_top/instance_fir/valid
add wave -noupdate /test_fir_top/instance_fir/ctrl/CurrentState
add wave -noupdate -divider {Memory Unit}
add wave -noupdate -label new_sampling(start) /test_fir_top/new_sample
add wave -noupdate -radix decimal /test_fir_top/xn
add wave -noupdate -radix decimal /test_fir_top/instance_fir/memoire/ADR_RAM
add wave -noupdate -radix decimal /test_fir_top/instance_fir/memoire/RAM
add wave -noupdate -radix decimal /test_fir_top/instance_fir/memoire/X
add wave -noupdate -radix decimal /test_fir_top/instance_fir/memoire/ADR_ROM
add wave -noupdate -radix decimal /test_fir_top/instance_fir/memoire/H
add wave -noupdate -radix decimal /test_fir_top/instance_fir/count
add wave -noupdate /test_fir_top/instance_fir/rstb
add wave -noupdate -divider {Processing Unit}
add wave -noupdate /test_fir_top/instance_fir/trait/clk
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/X
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/R1
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/H
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/R2
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/M
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/R3
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/R4
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/A
add wave -noupdate -radix decimal /test_fir_top/instance_fir/trait/Y
add wave -noupdate -divider {Control Unit}
add wave -noupdate /test_fir_top/instance_fir/trait/clk
add wave -noupdate /test_fir_top/instance_fir/ctrl/CurrentState
add wave -noupdate /test_fir_top/instance_fir/ctrl/endof
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {108 ns} 0}
configure wave -namecolwidth 352
configure wave -valuecolwidth 108
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
WaveRestoreZoom {1900 ns} {1936 ns}
