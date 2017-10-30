function [fileName,webpage]=webread(Tname)
Tname=upper(Tname);
url=sprintf('http://www.google.com/finance/getprices?i=60&p=1d&f=d,o&df=cpct&q=%s',Tname);
webpage=sprintf('<a href="http://www.google.com/finance?q=%s">%s</a>',Tname,Tname);
disp(webpage)
html=urlread(url);
if strcmpi(html(12:17),'NASDAQ')
    html(1:121)=[];
elseif strcmpi (html(12:15),'NYSE')
    html(1:119)=[];
elseif strcmpi(html(12:18),'NYSEMKT')||strcmpi(html(12:18),'OTCMKTS')
    html(1:122)=[];
elseif strcmpi(html(12:14),'HKG')||strcmpi(html(12:14),'SHA')||strcmpi(html(12:14),'TYO')
    html(1:191)=[];
end
html=['DATE,OPEN ' html];
fileName=[Tname '.txt'];
fileName1=fopen(fileName,'w');
fprintf(fileName1,html);
fclose(fileName1);
end