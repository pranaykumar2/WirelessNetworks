# Define simulation parameters
set val(chan)         Channel/WirelessChannel
set val(prop)         Propagation/TwoRayGround
set val(ant)          Antenna/OmniAntenna
set val(ll)           LL
set val(ifq)          Queue/DropTail/PriQueue
set val(ifqlen)       50
set val(netif)        Phy/WirelessPhy
set val(mac)          Mac/802_11
set val(rp)           DSDV
set val(nn)           2

# Create a simulator object
set ns [new Simulator]

# Define node movement
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace ON

# Create nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
}

# Define initial position of nodes
$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(1) set X_ 500.0
$node_(1) set Y_ 500.0

# Create links between nodes
$ns duplex-link $node_(0) $node_(1) 2Mb 10ms DropTail

# Set up TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $node_(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink

# Schedule events
$ns at 1.0 "$tcp start"
$ns at 4.0 "$tcp stop"

# Run the simulation
$ns run
