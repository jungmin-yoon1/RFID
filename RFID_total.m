% made by Jungmin Yoon
%%%%%%%%%%%%%%%%%%% 21.02.03 : RFID(Final1) %%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; 
min_tag=100;
max_tag=1000;
interval_tag=100; % 실험할 tag 수의 간격
tag_num=(min_tag:interval_tag:max_tag);   %tag 숫자
L=500;   %초기 프레임 크기, 슬롯 수

num=length(tag_num);  %실험할 tag 숫자의 종류
FSA_succ_num=zeros(1,num);  %FSA 성공 횟수
FSA_coll_num=zeros(1,num);  %FSA 충돌 횟수
FSA_idle_num=zeros(1,num);  %FSA idle 횟수

FSA_P_succ=zeros(1,num);    %FSA 성공 확률
FSA_P_coll=zeros(1,num);    %FSA 충돌 확률
FSA_P_idle=zeros(1,num);    %FSA idle 확률

sum_FSA_P_idle=zeros(1,num);  %FSA idle 확률 총합 (확률의 평균치 구하기 위함)
sum_FSA_P_succ=zeros(1,num);  %FSA 성공 확률 총합 (확률의 평균치 구하기 위함)
sum_FSA_P_coll=zeros(1,num);  %FSA 충돌 확률 총합 (확률의 평균치 구하기 위함)

DFSA_succ_num=zeros(1,num);  %DFSA 성공 횟수
DFSA_coll_num=zeros(1,num);  %DFSA 충돌 횟수
DFSA_idle_num=zeros(1,num);  %DFSA idle 횟수

DFSA_P_succ=zeros(1,num);    %DFSA 성공 확률
DFSA_P_coll=zeros(1,num);    %DFSA 충돌 확률
DFSA_P_idle=zeros(1,num);    %DFSA idle 확률

sum_DFSA_P_idle=zeros(1,num);  %DFSA idle 확률 총합 (확률의 평균치 구하기 위함)
sum_DFSA_P_succ=zeros(1,num);  %DFSA 성공 확률 총합 (확률의 평균치 구하기 위함)
sum_DFSA_P_coll=zeros(1,num);  %DFSA 충돌 확률 총합 (확률의 평균치 구하기 위함)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
iteration=500;  %평균치를 구하기 위한 반복 횟수

for iter=1:iteration  %각 확률의 평균치를 구하기 위함
    
    for tag_case=1:num     %tag수를 100~1000까지 100 단위로 10가지 경우를 실험
        tag_no = tag_num(tag_case); %새로운 변수 tag_no에 tag_num(k) 저장- 나중에 값이 변할 수 있으므로 따로 저장
        tag=zeros(1,tag_no); %각 tag 수의 경우에 맞게 tag 배열 설정

        for i_1=1:tag_no       %frame 크기(slot의 개수) 이내의 난수를 발생시켜 각 slot의 숫자를 랜덤하게 선택
            tag(i_1)=randi([1 L]); 
        end

        count=zeros(1,tag_no); %각 랜덤하게 고른 숫자의 분포를 저장-초기화=0
        for i_2=1:tag_no     %같은 tag 배열 두개를 서로 비교하여 각 숫자의 분포를 구함 
            for j_2=1:tag_no
                if tag(i_2)==tag(j_2)
                    count(j_2)=count(j_2)+1;
                end
            end
        end
        
        frame=zeros(1,L);  %L개의 slot을 가진 frame 배열 초기화
        
        for i_3=1:tag_no     %frame 배열내에 충돌/성공/idle 상황 저장(idle=0, success=1,collision>=2)  
            if count(i_3)==1  %성공
                frame(tag(i_3))=1;
            elseif count(i_3)>=2 %충돌
                frame(tag(i_3))=count(i_3);
            end
        end
        middle_succ_num=0;
        middle_coll_num=0;
        middle_idle_num=0;

        for i_4=1:L      %frame 배열을 하나씩 보면서 남은 tag 수, 충돌/성공/idle 상황 발생횟수 세기
            if frame(i_4)==1        % 성공
                FSA_succ_num(tag_case)=FSA_succ_num(tag_case)+1;
                middle_succ_num=middle_succ_num+1;
            elseif frame(i_4)>=2    % 충돌
                FSA_coll_num(tag_case)=FSA_coll_num(tag_case)+1;
                middle_coll_num=middle_coll_num+1;
            else                  % idle
                FSA_idle_num(tag_case)=FSA_idle_num(tag_case)+1;
                middle_idle_num=middle_idle_num+1;
            end
        end
        middle_idle_P=middle_idle_num/(middle_succ_num+middle_coll_num+middle_idle_num);
        tag_n=tag_no;
        L_s=L;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while tag_n>0
            current_tag_n=floor(log(middle_idle_P)/(log(1-1/L_s)));
            
            L_s=tag_n;
            for i_5=1:tag_n       %frame 크기(slot의 개수) 이내의 난수를 발생시켜 각 slot의 숫자를 랜덤하게 선택
                tag(i_5)=randi([1 L_s]); 
            end

            count=zeros(1,tag_n); %각 랜덤하게 고른 숫자의 분포를 저장-초기화=0
            for i_6=1:tag_n     %같은 tag 배열 두개를 서로 비교하여 각 숫자의 분포를 구함 
                for j_6=1:tag_n
                    if tag(i_6)==tag(j_6)
                        count(j_6)=count(j_6)+1;
                    end
                end
            end

            frame=zeros(1,L_s);  %L개의 slot을 가진 frame 배열 초기화

            for i_7=1:tag_n     %frame 배열내에 충돌/성공/idle 상황 저장(idle=0, success=1,collision>=2)  
                if count(i_7)==1  %성공
                    frame(tag(i_7))=1;
                elseif count(i_7)>=2 %충돌
                    frame(tag(i_7))=count(i_7);
                end
            end

            for i_8=1:L_s      %frame 배열을 하나씩 보면서 남은 tag 수, 충돌/성공/idle 상황 발생횟수 세기
                if frame(i_8)==1        % 성공
                    DFSA_succ_num(tag_case)=DFSA_succ_num(tag_case)+1;
                    tag_n=tag_n-1;
                elseif frame(i_8)>=2    % 충돌
                    DFSA_coll_num(tag_case)=DFSA_coll_num(tag_case)+1;
                else                  % idle
                    DFSA_idle_num(tag_case)=DFSA_idle_num(tag_case)+1;
                end
            end
            
            middle_idle_P=DFSA_idle_num(tag_case)/(DFSA_succ_num(tag_case)+DFSA_coll_num(tag_case)+DFSA_idle_num(tag_case));

        end
    end
   
    for k=1:num  %각 경우의 확률 계산 & 평균치 계산을 위한 확률의 총합 구하기
        FSA_P_succ(k)=FSA_succ_num(k)/(FSA_succ_num(k)+FSA_coll_num(k)+FSA_idle_num(k));
        FSA_P_coll(k)=FSA_coll_num(k)/(FSA_succ_num(k)+FSA_coll_num(k)+FSA_idle_num(k));
        FSA_P_idle(k)=FSA_idle_num(k)/(FSA_succ_num(k)+FSA_coll_num(k)+FSA_idle_num(k));
        sum_FSA_P_succ(k)=sum_FSA_P_succ(k)+FSA_P_succ(k);
        sum_FSA_P_coll(k)=sum_FSA_P_coll(k)+FSA_P_coll(k);
        sum_FSA_P_idle(k)=sum_FSA_P_idle(k)+FSA_P_idle(k);
        DFSA_P_succ(k)=DFSA_succ_num(k)/(DFSA_succ_num(k)+DFSA_coll_num(k)+DFSA_idle_num(k));
        DFSA_P_coll(k)=DFSA_coll_num(k)/(DFSA_succ_num(k)+DFSA_coll_num(k)+DFSA_idle_num(k));
        DFSA_P_idle(k)=DFSA_idle_num(k)/(DFSA_succ_num(k)+DFSA_coll_num(k)+DFSA_idle_num(k));
        sum_DFSA_P_succ(k)=sum_DFSA_P_succ(k)+DFSA_P_succ(k);
        sum_DFSA_P_coll(k)=sum_DFSA_P_coll(k)+DFSA_P_coll(k);
        sum_DFSA_P_idle(k)=sum_DFSA_P_idle(k)+DFSA_P_idle(k);
    end
    sum_DFSA_P_succ=(sum_DFSA_P_succ+sum_DFSA_P_idle)/2;
    sum_DFSA_P_idle=sum_DFSA_P_succ;

    if tag_no ~= 0  %남은 태그의 수가 0이 될 때까지 반복
        while tag_no>0
            tag=zeros(1,tag_no); %각 tag 수의 경우에 맞게 tag 배열 설정

            for i_9=1:tag_no       %frame 크기(slot의 개수) 이내의 난수를 발생시켜 각 slot의 숫자를 랜덤하게 선택
                tag(i_9)=randi([1 L]); 
            end

            count=zeros(1,tag_no); %각 랜덤하게 고른 숫자의 분포를 저장-초기화=0
            for i_10=1:tag_no     %같은 tag 배열 두개를 서로 비교하여 각 숫자의 분포를 구함 
                for j_10=1:tag_no
                    if tag(i_10)==tag(j_10)
                        count(j_10)=count(j_10)+1;
                    end
                end
            end

            frame=zeros(1,L);  %L개의 slot을 가진 frame 배열 초기화

            for i_11=1:tag_no     %frame 배열내에 충돌/성공/idle 상황 저장(idle=0, success=1,collision>=2)  
                if count(i_11)==1  %성공
                    frame(tag(i_11))=1;
                elseif count(i_11)>=2 %충돌
                    frame(tag(i_11))=count(i_11);
                end
            end

            for i_12=1:L      %frame 배열을 하나씩 보면서 남은 tag 수, 충돌/성공/idle 상황 발생횟수 세기
                if frame(i_12)==1        % 성공
                    tag_no=tag_no-1;  % tag의 전송 성공시 잔여 tag 수 감소
                end
            end
        end
    end
end


figure
hold on; grid on;
x=100:100:1000;

plot(x, (sum_FSA_P_succ/iteration),'-o' );  
plot(x, (sum_FSA_P_coll/iteration),'-^');  
plot(x, (sum_FSA_P_idle/iteration), '-v'); %확률 평균치 그래프로 나타내기,  , '-v'
plot(x, (sum_DFSA_P_succ/iteration),'-s');  
plot(x, (sum_DFSA_P_coll/iteration),'-*' ); 
plot(x, (sum_DFSA_P_idle/iteration),'-->' ); 
legend('FSA P_s_u_c_c','FSA P_c_o_l_l','FSA P_i_d_l_e','DFSA P_s_u_c_c', 'DFSA P_c_o_l_l', 'DFSA P_i_d_l_e');
xlim([100,1000]); ylim([0 0.9]);
xlabel('Number of tags'), ylabel('Probability');

