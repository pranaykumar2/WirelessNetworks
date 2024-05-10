# Define the simulator
set ns [new Simulator]

# Open the trace file
set tracefile [open simple-dv-routing.tr w]
$ns trace-all $tracefile

# Define the finish procedure
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    puts "Simulation completed."
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create links between nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

# Set up the routing protocol
$ns rtproto DV

# Define a finish procedure
$ns at 5.0 "finish"

# Run the simulation
$ns run
