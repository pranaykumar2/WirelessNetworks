#DSR

# Define simulation time
set simTime 100.0

# Create a simulator object
set ns [new Simulator]

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Create links between nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail

# Set the routing protocol to DSR
$ns dsrroute-obj [Simulator instance] $n0
$ns dsrroute-obj [Simulator instance] $n1
$ns dsrroute-obj [Simulator instance] $n2
$ns dsrroute-obj [Simulator instance] $n3
$ns dsrroute-obj [Simulator instance] $n4

# Create a UDP agent and attach it to node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a null agent and attach it to node 4
set null4 [new Agent/Null]
$ns attach-agent $n4 $null4

# Connect the agents
$ns connect $udp0 $null4

# Create a CBR traffic source and attach it to the UDP agent
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1Mb
$cbr0 set random_ false

# Define the finish procedure
proc finish {} {
    global ns
    $ns flush-trace
    puts "Simulation completed."
    exit 0
}

# Schedule the finish procedure
$ns at $simTime "finish"

# Run the simulation
$ns run
