# Define the simulation time
set simTime 10.0

# Create a simulator object
set ns [new Simulator]

# Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Define the color for TCP and UDP flows
$ns color 1 Blue
$ns color 2 Red

# Create nodes
set n0 [$ns node]
set n1 [$ns node]

# Create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail

# Set up TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

# Set up UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n1 $null
$ns connect $udp $null
$udp set fid_ 2

# Create a FTP traffic source and attach it to the TCP agent
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

# Create a CBR traffic source and attach it to the UDP agent
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packetSize_ 1000
$cbr set rate_ 0.01Mb
$cbr set random_ false

# Schedule events for the FTP and CBR traffic
$ns at 1.0 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 9.0 "$ftp stop"
$ns at 9.0 "$cbr stop"

# Define the finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    puts "Simulation completed."
    exit 0
}

# Call the finish procedure after the simulation time
$ns at $simTime "finish"

# Run the simulation
$ns run
