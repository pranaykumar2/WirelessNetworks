# Define simulation time
set simTime 100

# Create a simulator object
set ns [new Simulator]

# Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail

# Set up AODV routing protocol
$ns aodv

# Enable AODV for all nodes
$ns aodv-enable $n0
$ns aodv-enable $n1
$ns aodv-enable $n2
$ns aodv-enable $n3

# Create a UDP agent and attach it to node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a null agent and attach it to node 3
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

# Connect the agents
$ns connect $udp0 $null3

# Create a CBR traffic source and attach it to the UDP agent
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

# Schedule events for the CBR source
$ns at 1.0 "$cbr0 start"
$ns at 4.0 "$cbr0 stop"

# Open the trace file
set tracefile [open simpleAODV.tr w]
$ns trace-all $tracefile

# Define a 'finish' procedure
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    puts "Simulation completed."
    exit 0
}

# Run the simulation
$ns run
