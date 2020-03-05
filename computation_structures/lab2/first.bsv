function Bit#(1) multiplexer1(Bit#(1) sel, Bit#(1) a, Bit#(1) b);
    return or1(and1(a, not1(sel)), and1(b, sel));
endfunction