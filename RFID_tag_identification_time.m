% made by Jungmin Yoon
%%%%%%%%%%%%%%%%%%% 21.02.04 : RFID(태그 인식 시간) %%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; 
min_tag=100;
max_tag=1000;
interval_tag=100; % 실험할 tag 수의 간격
tag_num=(min_tag:interval_tag:max_tag);   %tag 숫자
num=length(tag_num);  %실험할 tag 숫자의 종류

DFSA_succ_num=zeros(1,num);  %DFSA 성공 횟수
DFSA_coll_num=zeros(1,num);  %DFSA 충돌 횟수
DFSA_idle_num=zeros(1,num);  %DFSA idle 횟수
num=length(tag_num);  %실험할 tag 숫자의 종류
L_array=[50,50,50,50,50,50,50,50,50,50]; %초기 slot수 설정
P_succ=zeros(1,num);
iteration=700; 

%%%%%%%%%%%%%%       시뮬레이션             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iter=1:iteration

    for tag_case=1:num %tag수를 100~1000까지 100 단위로 10가지 경우를 실험

            tag_no = tag_num(tag_case); %새로운 변수 tag_no에 tag_num(k) 저장- 나중에 값이 변할 수 있으므로 따로 저장
            tag=zeros(1,tag_no); %각 tag 수의 경우에 맞게 tag 배열 설정

            for i_1=1:tag_no       %frame 크기(slot의 개수) 이내의 난수를 발생시켜 각 slot의 숫자를 랜덤하게 선택
                tag(i_1)=randi([1 L_array(tag_case)]); 
            end

            count=zeros(1,tag_no); %각 랜덤하게 고른 숫자의 분포를 저장-초기화=0
            for i_2=1:tag_no     %같은 tag 배열 두개를 서로 비교하여 각 숫자의 분포를 구함 
                for j_2=1:tag_no
                    if tag(i_2)==tag(j_2)
                        count(j_2)=count(j_2)+1;
                    end
                end
            end

            frame=zeros(1,L_array(tag_case));  %L개의 slot을 가진 frame 배열 초기화

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

            for i_4=1:L_array(tag_case)      %frame 배열을 하나씩 보면서 남은 tag 수, 충돌/성공/idle 상황 발생횟수 세기
                if frame(i_4)==1        % 성공
                    middle_succ_num=middle_succ_num+1;

                elseif frame(i_4)>=2    % 충돌
                    middle_coll_num=middle_coll_num+1;
                elseif frame(i_4)==0                  % idle
                    middle_idle_num=middle_idle_num+1;
                end
            end   

            middle_idle_P=middle_idle_num/(middle_succ_num+middle_coll_num+middle_idle_num); %FSA와 같은 확률

            tag_n=tag_no;
            L=L_array(tag_case); %크기가 변해야하는 값이므로 따로 L로 설정

            while tag_n>0
                current_tag_n=round(log(middle_idle_P)/(log(1-1/L)));

                L=tag_n;
                L_array(tag_case)=L_array(tag_case)+L;
                for i_5=1:tag_n       %frame 크기(slot의 개수) 이내의 난수를 발생시켜 각 slot의 숫자를 랜덤하게 선택
                    tag(i_5)=randi([1 L]); 
                end

                count=zeros(1,tag_n); %각 랜덤하게 고른 숫자의 분포를 저장-초기화=0
                for i_6=1:tag_n     %같은 tag 배열 두개를 서로 비교하여 각 숫자의 분포를 구함 
                    for j_6=1:tag_n
                        if tag(i_6)==tag(j_6)
                            count(j_6)=count(j_6)+1;
                        end
                    end
                end

                frame=zeros(1,L);  %L개의 slot을 가진 frame 배열 초기화

                for i_7=1:tag_n     %frame 배열내에 충돌/성공/idle 상황 저장(idle=0, success=1,collision>=2)  
                    if count(i_7)==1  %성공
                        frame(tag(i_7))=1;
                    elseif count(i_7)>=2 %충돌
                        frame(tag(i_7))=count(i_7);
                    end
                end

                for i_8=1:L     %frame 배열을 하나씩 보면서 남은 tag 수, 충돌/성공/idle 상황 발생횟수 세기
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
end

%%%%%%%%%%%%%%%%%%%%%%%    이론   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=(100:100:1000);
L_array2=[50,50,50,50,50,50,50,50,50,50];

 
for i=1:length(n)
    
    tagnum=n(i);
    L_size=L_array2(i);
    
    while tagnum>0
        
        
        P_succ=round(tagnum*(1/L_size)*((1-1/L_size)^(tagnum-1)),3);
        P_idle=round((1-1/L_size)^tagnum,3);
        
        
        
        succnum=round(P_succ*tagnum);
        tagnum=round(tagnum-succnum);
        
        current_n=round(log(P_idle)/log(1-1/L_size));
        
        L_size=tagnum;
        L_array2(i)=L_array2(i)+L_size;
    end
    
end



%%%%%%%%%%%%%%%%%%%%   plot  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on; grid on;
x=100:100:1000;
plot(x,L_array2,'LineWidth',0.5);
plot(x, L_array/iteration,'^b','LineWidth',0.5); %확률 평균치 그래프로 나타내기

xlim([100,1000]); ylim([0,3000]);
legend('Analysis','Simulation')
xlabel('Number of tags'), ylabel('Number of slots to identify tags');




