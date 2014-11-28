% RSS trace collection for mmWave imaging
% 
% Author: Sanjib Sur
% Institute: University of Wisconsin - Madison
% 
% Comments: 
% 

clear all;
close all;
clc;


%% Read the global variables
mmWaveImage_GlobalVars;


%% Read the config file
mmWaveImage_trace_config;


%% Setup WARP board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the WARPLab experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NUMNODES = 1;

%Create a vector of node objects
nodes = wl_initNodes(NUMNODES);

%Create a UDP broadcast trigger and tell each node to be ready for it
WARPLab_eth_trig = wl_trigger_eth_udp_broadcast;
wl_triggerManagerCmd(nodes,'add_ethernet_trigger',[WARPLab_eth_trig]);

%Get IDs for the interfaces on the boards. Since this example assumes each
%board has the same interface capabilities, we only need to get the IDs
%from one of the boards
[RFA,RFB] = wl_getInterfaceIDs(nodes(1));

%Set up the interface for the experiment
wl_interfaceCmd(nodes,'RF_ALL','tx_gains',3,30);
wl_interfaceCmd(nodes,'RF_ALL','channel',2.4,11);

wl_interfaceCmd(nodes,'RF_ALL','rx_gain_mode','manual');
RxGainRF =1; %Rx RF Gain in [1:3]
RxGainBB = 1; %Rx Baseband Gain in [0:31]
wl_interfaceCmd(nodes,'RF_ALL','rx_gains',RxGainRF,RxGainBB);

%We'll use the transmitter's I/Q buffer size to determine how long our
%transmission can be
WARPLab_txLength = nodes(1).baseband.txIQLen;
WARPLab_rxLength = nodes(1).baseband.rxIQLen;

% Setup continuous transmission mode in Tx
WARP_CONT_TX = 1;
wl_basebandCmd(nodes, 'continuous_tx', WARP_CONT_TX);

%Set up the baseband for the experiment
wl_basebandCmd(nodes,'tx_delay',0);
wl_basebandCmd(nodes,'tx_length',WARPLab_txLength);

WARPLab_node_tx = nodes(1);
WARPLab_node_rx = nodes(1);

WARPLab_RF_TX = RFA;
WARPLab_RF_RX = RFA;

mmWaveImage_trace_collect();
