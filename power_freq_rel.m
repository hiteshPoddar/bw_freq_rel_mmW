clear;
clc;
c = 3e8; 
P_tx_w = 1;%mW
P_tx = 10*log10(P_tx_w/1000); %% dBm
d = 100; %m
f = [3*10^9 10*10^9 30*10^9 100*10^9 300*10^9 400*10^9];
% 10*10^9 30*10^9 100*10^9 300*10^9 400*10^9];
n_nlos = 3.2; %% nLOS
n_los = 2.0;
NF = 10; %% DB
%SNR = [10 20 30]; %% DB
BW = [100 * 10^6 , 500 * 10^6, 1000 * 10^6, 5000 * 10^6, 10000 * 10^6 ];
Aer = 5; %% in cm^2
Aet = 5000; %% in cm^2
KT = 10*log10((1.38*10^-23)*294); %% dB
effeciency = 0.6;
for j=1:length(f)
    for i=1:length(BW)
        lambda = (3*10^8)/f(j); %m
        Gain_rx(j) = 10*log10(effeciency*4*pi*(Aer/10^4)/ lambda ^2) ; %% dBi
        Gain_tx(j) = 10*log10(effeciency*4*pi*(Aet/10^4)/ lambda ^2); %% dBi
        FSPL(j) = 20*log10(4*pi*f(j)/c); %% dB
        PL(j) = FSPL(j) + 10*n_nlos*log10(d) ; %% dB
        P_rx(j) = P_tx + Gain_rx(j) + Gain_tx(j) - PL(j); % Rx power in dBm
        if(BW(i) < f(j)/10)
            SNR_nlos(i,j) = round(P_rx(j) - NF - 10*log10((1.38*10^-23)*294 * BW(i)),1);
        else
            SNR_nlos(i,j) = nan;
        end
    end
end

for j=1:length(f)
    for i=1:length(BW)
        lambda = (3*10^8)/f(j); %m
        Gain_rx(j) = 10*log10(effeciency*4*pi*(Aer/10^4)/ lambda ^2) ; %% dBi
        Gain_tx(j) = 10*log10(effeciency*4*pi*(Aet/10^4)/ lambda ^2); %% dBi
        FSPL(j) = 20*log10(4*pi*f(j)/c); %% dB
        PL(j) = FSPL(j) + 10*n_los*log10(d) ; %% dB
        P_rx(j) = P_tx + Gain_rx(j) + Gain_tx(j) - PL(j); % Rx power in dBm
        if(BW(i) < f(j)/10)
            SNR_los(i,j) = round(P_rx(j) - NF - 10*log10((1.38*10^-23)*294 * BW(i)),1);
        else
            SNR_los(i,j) = nan;
        end
    end
end

for i=1:length(f)
  norm_f(i) = f(i)/10^9;
end

figure(1);
b = semilogx(norm_f,SNR_nlos(1,:),':',norm_f,SNR_los(1,:),'LineWidth',5);
hold on
grid on
c = semilogx(norm_f,SNR_nlos(2,:),':',norm_f,SNR_los(2,:),'Displayname','BW = 500 MHz', 'LineWidth',5);
d = semilogx(norm_f,SNR_nlos(3,:),':',norm_f,SNR_los(3,:),'Displayname','BW = 1 GHz','LineWidth',5);
e = semilogx(norm_f,SNR_nlos(4,:),':',norm_f,SNR_los(4,:),'Displayname','BW = 5 GHz','LineWidth',5);
f = semilogx(norm_f,SNR_nlos(5,:),':',norm_f,SNR_los(5,:),'Displayname','BW = 10 GHz','LineWidth',5);
a = xline(3,'--', '3 GHz','LineWidth',3,'Fontsize',40,'LabelVerticalAlignment','bottom');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = xline(10,'--', '10 GHz','LineWidth',3,'Fontsize',40,'LabelVerticalAlignment','bottom');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = xline(30,'--', '30 GHz','LineWidth',3,'Fontsize',40,'LabelVerticalAlignment','bottom');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = xline(100,'--', '100 GHz','LineWidth',3,'Fontsize',40,'LabelVerticalAlignment','bottom');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = xline(300,'--', '300 GHz','LineWidth',3,'Fontsize',40,'LabelVerticalAlignment','bottom');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlim([3 400]);
ylim([-1 70]);
b(1,1).Color = 'red';
b(2,1).Color = 'red';
c(1,1).Color = 'blue';
c(2,1).Color = 'blue';
d(1,1).Color = 'green';
d(2,1).Color = 'green';
e(1,1).Color = 'magenta';
e(2,1).Color = 'magenta';
f(1,1).Color = '#A2142F';
f(2,1).Color = '#A2142F';
title('Frequency vs SNR','Fontsize',40);
xlabel('Frequency (in GHz)', 'Fontsize',40);
ylabel('SNR (in dB)', 'Fontsize',40);
set(gca,'FontSize',40);
% lgd = legend;
% lgd.NumColumns = 2;
% lgd.FontSize = 40;

