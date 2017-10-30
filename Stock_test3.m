Tname=input('Ticker Name: ','s');
[fileName]=webread(Tname);
data=readtable(fileName);
%data=readtable('AAPL1.txt');
omin=data(:,2);
omin=table2array(omin);
cash=25000;
initcash=cash;
buypower=0.75*cash;
mvalue=zeros(length(omin),1);
mpercent=mvalue;mpercent(1)=0;spercent=mpercent;
tradey=mvalue;tradex=tradey;
%amount=100;
stockv=omin(1)*amount;
shares=0;
trade=0;
tb4bell=15;
tabell=7;
moveave=0;
t=1;
for i=1:length(omin)
    value=omin(i);
    if shares==0
        amount=floor(buypower/value);
    end
    if (i<=tabell)&&(i>1)
        if shares==0
            if omin(i)>omin(i-1)
                shares=amount;
                cash=cash-(amount*value);
                trade=trade+1;
                tradex(i)=i;
            end
        else
            if (omin(i)<omin(i-2))&&t
                cash=cash+(shares*value);
                shares=0;
                trade=trade+1;
                tradex(i)=i;
            end
        end
    end
    if i>tabell&&i<(length(omin)-tb4bell)
        if ((omin(i)>mean(omin((i-6):(i-2))))&&(omin(i)>mavg))
            if shares~=0
                cash=cash+(shares*value);
                shares=0;
                trade=trade+1;
                tradex(i)=i;
            end
        end
        if (omin(i)<mean(omin((i-3):(i-1)))||(omin(i)<mavg)&&(omin(i-1)<=omin(i-6)))
        %elseif (omin(i)<mavg)&&(omin(i)<=omin(i-2))
        %elseif (((omin(i)<mean(omin((i-3):(i-1)))||(omin(i)<mavg)&&(omin(i-1)<=omin(i-6)))
            if shares==0
                shares=amount;
                cash=cash-(amount*value);
                trade=trade+1;
                tradex(i)=i;
            end
        end
    elseif i>(length(omin)-tb4bell)
        if shares==0
            if omin(i)>omin(i-2)
                shares=amount;
                cash=cash-(amount*value);
                trade=trade+1;
                tradex(i)=i;
            end
        else
            if omin(i)<omin(i-2)
                cash=cash+(shares*value);
                shares=0;
                trade=trade+1;
                tradex(i)=i;
            end
        end
    end
    if (shares~=0)&&(i==length(omin))
        cash=cash+(shares*value);
        shares=0;
        trade=trade+1;
    end
    mvalue(i)=(cash+shares*value);
    mpercent(i)=(mvalue(i)/initcash-1)*100;
    spercent(i)=(omin(i)/omin(1)-1)*100;
    if(i<=moveave)
        mavg=mean(omin(1):omin(i));
    else
        mavg=mean(omin(i-moveave):omin(i));
    end
end
tradex=tradex(tradex~=0);
tradey=zeros(length(tradex),1);
for i=1:length(tradex)
    tradey(i)=mpercent(tradex(i));
end
myperc=mpercent(length(omin));
stperc=spercent(length(omin));
valinc=mvalue(length(omin))-initcash;
fprintf('Value Increase: %.4f%%\n',myperc)
fprintf('Stock Increase: %.4f%%\n',stperc)
fprintf('Cash Increase: $%.2f\n',valinc)
fprintf('Cash per Share: $%.2f\n',valinc/amount)
fprintf('Trades: %.0f\n\n',trade)
figure(2)
    plot(1:length(omin),spercent,'r-',1:length(omin),mpercent,'b-')
    hold on
    plot(tradex,tradey,'bo')
    hold off