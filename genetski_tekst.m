tic % POCETAK TAJMERA
tekst='neki tekst';
 
popDuzina=1000;
genome=length(tekst);
stopaMutacije=0.001;
brojac=1;
S=4;
najbolji=Inf;
maxVrijednost=max(double(tekst));
idealno=double(tekst);
 
selekcija=0;
krizanje=1;
iscrtavanje=1;
 
% POSTAVLJANJE POCETKA SLUCAJNE POPULACIJE
Pop=round(rand(popDuzina,genome)*(maxVrijednost-1)+1);
 
initF=min(sum(abs(bsxfun(@minus,Pop,idealno)),2));
 
for Gen=1:1e6
    F=sum(abs(bsxfun(@minus,Pop,idealno)),2);
    [trenutni,trenutniGen]=min(F);
    
    if trenutni<najbolji
        najbolji=trenutni;
        najboljiGen=Pop(trenutniGen);
        
        if iscrtavanje==1
            B(brojac)=najbolji;
            G(brojac)=Gen;
            brojac=brojac+1;
        end
        
        fprintf('Gen: %d  Sposonost: %d', Gen,najbolji);
        disp(char(najboljiGen));
    elseif        najbolji==0
        break
    end
    
    % ODABIR PAROVA RODITELJA
    if selekcija==0
        T=round(rand(2*popDuzina,S)*(popDuzina-1)+1);
        [~,idx]=min(F(T),[],2);
        W=T(sub2ind(size(T),(1:2*popDuzina)',idx));
        
    elseif selekcija==1
        [~,V]=sort(F,'descend');
        V=V(popDuzina/2+1:end);
        W=V(round(rand(2*popDuzina,1)*(popDuzina/2-1)+1))';
    end
    
    % KRIZANJE
    
   if krizanje==0
       idx=logical(round(rand(size(P))));
       
       Pop2=Pop(W(1:2:end),:);
       P2A=Pop(W(2:2:end),:);
       Pop2(idx)=P2A(idx);
       
   elseif krizanje==1
       Pop2=Pop(W(1:2:end),:);
       P2A=Pop(W(2:2:end),:);
       Ref=ones(popDuzina,1)*(1:genome);
       idx=(round(rand(popDuzina,1)*(genome-1)+1)*ones(1,genome))>Ref;
       Pop2(idx)=P2A(idx);
       
elseif krizanje==2
       Pop2=Pop(W(1:2:end),:);
       P2A=Pop(W(2:2:end),:);
       Ref=ones(popDuzina,1)*(1:genome);
       CP=sort(round(rand(popDuzina,2)*(genome-1)+1),2);
       idx= CP(:,1)*ones(1,genome)<Ref&CP(:,2)*ones(1,genome)>Ref;
   end
   
   % MUTACIJA
   idx=rand(size(Pop2))<stopaMutacije;
   Pop2(idx)=round(rand([1,sum(sum(idx))])*(maxVrijednost-1)+1);
   
   % RESETOVANJE POPULACIJE
   Pop=Pop2;
end
 
toc % GASENJE TAJMERA
 
% ISRTAVANJE KRIVE SPOSOBNOSTI
 
if iscrtavanje==1
    figure(1)
    plot(G(:),B(:),'-r');
    axis([0 Gen 0 initF]);
    xlabel('Sposobnost');
    ylabel('Popuplacija');
    title('Sposobnost tokom vremena');
end
