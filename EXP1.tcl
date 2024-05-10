#https://www.phind.com/search?cache=fg6bg9ckriikioyfon923qom

set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nf1 [open out.tr w]
$ns trace-all $nf1

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.05

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0

proc finish {} {
    global ns nf nf1
    $ns flush-trace
    close $nf
    close $nf1
    exec nam out.nam &
    exit 0
}

$ns at 1.0 "$cbr0 start"
$ns at 4.0 "$cbr0 stop"
$ns at 5.0 "finish"

$ns run
