# helm-chart
> 조직 내 k8s 인프라 자원 관리를 위한 헬름 차트  
> 최초 환경 구성인 경우 [99. 참고](#99-참고) 를 확인하시기 바랍니다.
## 차트 관리 방법
  1. 각 차트는 디렉토리로 관리합니다.
  2. 환경 구분은 suffix 로 구분합니다.
  3. 예시 구조
     ```
     .
     ./argocd-local
     ./redis-dev
     ./mysql-prod
     ...
     ```

# 차트 목록
## Jenkins
* TBD

## SonarQube
* TBD

## Redis
* TBD

## MySQL
* TBD

<hr style="margin-top: 50px; border: 0; height: 4px; background: #ccc"/>

# 99. 참고
## k8s 설치
### local
* suffix: `local`
* 로컬 환경은 클러스터용 노드 및 스위치, 스토리지 등의 장비가 없기 때문에 미니쿠베 설치를 기준으로 합니다.
* [미니쿠베 설치 공식 가이드](https://kubernetes.io/ko/docs/tutorials/hello-minikube/)

## ArgoCd 설치
### local
* suffix: `local`
* 로컬 환경은 스위치 장비가 없어 LB ip 를 할당할 수 없기 때문에 `노드 포트` 접속을 기준으로 합니다.