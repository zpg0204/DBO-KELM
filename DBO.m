function [trace,fMin , bestX, Convergence_curve ] = DBO(pop, M,c,d,dim,fobj  )
  
    P_percent = 0.2;        
    pNum = round( pop *  P_percent );    
    lb= c.*ones( 1,dim );    
    ub= d.*ones( 1,dim );    
for i = 1 : pop
    x( i, : ) = lb + (ub - lb) .* rand( 1, dim );  
    fit( i ) = fobj( x( i, : ) ) ;                       
end
pFit = fit;                       
pX = x; 
XX=pX;    
[ fMin, bestI ] = min( fit );  
bestX = x( bestI, : );            

 trace=zeros(M,2);   
for t = 1 : M    
    disp(['--------------------------DBO第 ',num2str(t),' 代种群进化-------------------'])      
        [fmax,B]=max(fit);
        worse= x(B,:);   
       r2=rand(1);

    for i = 1 : pNum    
        if(r2<0.9)
            r1=rand(1);
          a=rand(1,1);
          if (a>0.1)
           a=1;
          else
           a=-1;
          end
        x( i , : ) =  pX(  i , :)+0.3*abs(pX(i , : )-worse)+a*0.1*(XX( i , :)); % Equation 
       else
            
           aaa= randperm(180,1);
           if ( aaa==0 ||aaa==90 ||aaa==180 )
            x(  i , : ) = pX(  i , :);   
           end
         theta= aaa*pi/180;   
       
       x(  i , : ) = pX(  i , :)+tan(theta).*abs(pX(i , : )-XX( i , :));    % Equation    

        end
      
        x(  i , : ) = Bounds( x(i , : ), lb, ub );    
        fit(  i  ) = fobj( x(i , : ) );
    end 
    [ fMMin, bestII ] = min( fit );     
    bestXX = x( bestII, : );           
   
    R=1-t/M;                         
    Xnew1 = bestXX.*(1-R); 
    Xnew2 =bestXX.*(1+R);                    %%% Equation 
    Xnew1= Bounds( Xnew1, lb, ub );
    Xnew2 = Bounds( Xnew2, lb, ub );
   
   
    Xnew11 = bestX.*(1-R); 
    Xnew22 =bestX.*(1+R);                    %%% Equation 
    Xnew11= Bounds( Xnew11, lb, ub );
    Xnew22 = Bounds( Xnew22, lb, ub );



    for i = ( pNum + 1 ) :12              % Equation
        x( i, : )=bestXX+((rand(1,dim)).*(pX( i , : )-Xnew1)+(rand(1,dim)).*(pX( i , : )-Xnew2));
        x(i, : ) = Bounds( x(i, : ), Xnew1, Xnew2 );
        fit(i ) = fobj(  x(i,:) ) ;
    end
   
    for i = 13: 19                       % Equation 
        x( i, : )=pX( i , : )+((randn(1)).*(pX( i , : )-Xnew11)+((rand(1,dim)).*(pX( i , : )-Xnew22)));
        x(i, : ) = Bounds( x(i, : ),lb, ub);
        fit(i ) = fobj(  x(i,:) ) ;
    end
  
    for j = 20 : pop                     % Equation 
        x( j,: )=bestX+randn(1,dim).*((abs(( pX(j,:  )-bestXX)))+(abs(( pX(j,:  )-bestX))))./2;
        x(j, : ) = Bounds( x(j, : ), lb, ub );
        fit(j ) = fobj(  x(j,:) ) ;
    end

     XX=pX;
    for i = 1 : pop 
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
        
        if( pFit( i ) < fMin )
           fMin= pFit( i );
           bestX = pX( i, : );     
        end
    end
     Convergence_curve(t)=fMin;
     trace(t,1)=fMin;
     trace(t,2)=sum(pFit)./pop;
    
end

function s = Bounds( s, Lb, Ub)
  temp = s;
  I = temp < Lb;
  temp(I) = Lb(I);
  J = temp > Ub;
  temp(J) = Ub(J);
  s = temp;
function S = Boundss( SS, LLb, UUb)
  temp = SS;
  I = temp < LLb;
  temp(I) = LLb(I);
  J = temp > UUb;
  temp(J) = UUb(J);
  S = temp;

