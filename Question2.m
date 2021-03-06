%Constants
gK = 36; %conductance of potassium in milli Siemens per cm^2
gNa = 120; %conductance of sodium in milli Siemens per cm^2
gL = .3; %conductance of leakage in milli Siemens per cm^2
EK = -12; %Potential of potassium in mV
ENa = 115; %Potential of Sodium in mV
EL =10.6; %Potential of the leakage in mV
%Vrest = -70; I subtract 70 mV at the end thanks to Piazza
Cm = 1.0; %Membrane capacitance in micro farads per cm^2

IInject=zeros(1,length(t)); %Step Response of 5 micro amps per cm^2 for .5ms
IInject(1:(.5/sh)) = 5; %Since the length is 100 ms, just do .5 divide by 
%step size to get the desired duration

% %Constants This didn't work so I'm leaving this out
% gK = .036; %Converted from millisiemens per cm^2 ti siemens 
% gNa = .120;
% gL = .0003;
% EK = -.012; %Convert voltages to V from mV
% ENa = .115;
% EL =.0106;
% Vrest = -.070;
% Cm = 1.0*10^-6; %Converted from mico farads to just farads
% IInject = 0;

sh = .01; %Step size. 

%Initialize time
t = 0:sh:100; %From 0 seconds to 100 ms through sh sized second steps

%Equations

%Gating Variables

i=1; %Set my inital value of my indexes



%The following is just an array of zeroes for the variables that iterate
%through time. The reason why I do this is so my code runs faster.
%For debugging too

Vm = zeros(1,length(t)); 
dVm = zeros(1,length(t));

m=zeros(1,length(t));
n=zeros(1,length(t));
h=zeros(1,length(t));

IK=zeros(1,length(t));
INa=zeros(1,length(t));
ILeak=zeros(1,length(t));

IIon=zeros(1,length(t));

dm=zeros(1,length(t));
dh=zeros(1,length(t));
dn=zeros(1,length(t));

%Solve for the first round (Initial Conditions) of alpha and beta variables
%a and b are probability that the membrane channel is open or closed
%respectively.

an = .01*((10-Vm(i))/(exp((10-Vm(i))/10)-1));
bn = .125*exp(-Vm(i)/80);
am = .1*((25-Vm(i))/(exp((25-Vm(i))/10)-1)); 
bm = 4*exp(-Vm(i)/18);
ah = .07*exp(-Vm(i)/20);
bh = 1/(exp((30-Vm(i))/10)+1);

%Using the initial condition formulas to get the first m,n, and h value
m(1) = am/(am+bm);
n(1) = an/(an+bn);
h(1) = ah/(ah+bh);


while t(i)>=0 && t(i)<100
%This loops through and updates each respective value through time. Its a
%basic copy of the provided formulas and just repeating it through.
an = .01*((10-Vm(i))/(exp((10-Vm(i))/10)-1));
bn = .125*exp(-Vm(i)/80);    
am = .1*((25-Vm(i))/(exp((25-Vm(i))/10)-1));
bm = 4*exp(-Vm(i)/18);
ah = .07*exp(-Vm(i)/20);
bh = 1/(exp((30-Vm(i))/10)+1);    

INa = (m(i)^3)*gNa*h(i)*(Vm(i)-ENa);
IK = (n(i)^4)*gK*(Vm(i)-EK);
ILeak = gL*(Vm(i)-EL); 

IIon = IInject(i)-(IK+INa+ILeak);

%Eulers Formula to update each respective value

%Theres are the derivitative values calculated
dm(i) = am*(1-m(i))-bm*m(i);
dn(i) = an*(1-n(i))-bn*n(i);
dh(i) = ah*(1-h(i))-bh*h(i);  
   
dVm = IIon/Cm;

%This is the application of Eulers
Vm(i+1) = Vm(i)+dVm*sh;   
n(i+1) = n(i)+dn(i)*sh;
m(i+1) = m(i)+dm(i)*sh;
h(i+1) = h(i)+dh(i)*sh;


i = i+1;
end

Vm=Vm-70;

%This is to plot it and make it look pretty without the +- .003 noise
plot(t,Vm)
ylabel('Volts (mV)')
xlabel('Seconds (mS)')
Title('Voltage over Time')


% plot(t,gK*(n.^4),t,gNa*(m.^3).*h)
% legend('Potassium','Sodium')
% xlabel('time ms')
% ylabel('Conductance, mS')





