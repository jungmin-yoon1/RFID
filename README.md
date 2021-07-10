## RFID
Radio-Frequency Identification 구현 

### FSA 프로토콜 및 DFSA 프로토콜의 시뮬레이션

#### DFSA, FSA 기능 구현, Success, Collision, Idle 확률 비교 그래프 출력

(1) 리더의 인식 영역 내 태그 생성 (100개~1000개)

(2) 성능 평가 환경을 참고하여 초기 프레임 생성
- 초기 프레임 크기 설정 (임의의 프레임 크기 (슬롯 수) 가능)
- FSA는 초기 프레임의 크기로 고정됨

(3) 태그들은 프레임 내 임의의 시간 슬롯을 선택
- rand 함수로 난수를 생성하고, 생성된 난수를 이용하여 프레임 크기 내에서 태그의 시간 슬롯 선택 과정 구현

(4) 태그는 선택한 시간 슬롯에서 자신의 정보를 전송

(5) 태그 전송 수에 따라 슬롯의 상태 (success, idle, collision 여부) 판별
- 해당 시간 슬롯에서 전송을 하는 태그의 수를 count
- 0이면 idle, 1이면 success, 2 이상이면 collision slot으로 판별

(6) Estimation method를 이용하여 인식하지 못한 태그의 수 추정
- [3], [5]를 참고하여 남은 태그의 수를 추정

(7) 다음 프레임 크기 결정
- 추정한 태그의 수로부터 다음 프레임 크기 결정

(8) 남은 태그의 수가 0이 될 때까지 (3)-(7)까지의 과정을 반복 

#### 결과 그래프
<img src="https://user-images.githubusercontent.com/58179712/124858571-4ac91c00-dfe9-11eb-9747-44cae3b92784.png"  width="500">

### Dynamic Framed Slotted ALOHA (DFSA) 분석

#### DFSA 시뮬레이션

(1) [5]를 참고하여 DFSA 프로토콜 성능에 대한 수학적 분석 모델 구
- 임의의 한 시간 슬롯에서 임의의 한 태그가 전송에 성공할 확률 계산
- Binomial distribution을 이용해 성공 확률 계산

(2) 태그들을 인식하는 데 걸리는 시간 계산

(3) DFSA 프로토콜의 시뮬레이션 성능(성공 확률, 인식 시간)과 수학적 분석 모델을 통한 성능을 비교

#### 태그 인식시간 그래프 출력
<img src="https://user-images.githubusercontent.com/58179712/124858273-b363c900-dfe8-11eb-9daf-bd98942cfd13.png"  width="500">
