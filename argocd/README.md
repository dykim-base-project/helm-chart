# 아르고 CD 배포
> 아르고 CD 는 헬름 차트로 배포하며, 템플릿은 온라인에서 받아서 그대로 사용합니다.  
> 따라서 별도의 템플릿 관리는 없으며 설정 값만 오버라이드 합니다.  

## 1. 기본 설치
```shell
# 네임스페이스 생성
k create ns argocd

# 차트 레포지토리 추가
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

## 2. 설치
```shell
# 차트 및 아르고CD 버전 확인
helm search repo argo/argo-cd --versions
```
```shell
# 설치(원하는 아르고CD 버전에 맞게 설정할 것)
helm install argocd argo/argo-cd \
  --version 7.6.4 \
  -n argocd \
  -f values.yaml
```

## 2-2. 수정
```shell
# 차트 업데이트
helm upgrade argocd argo/argo-cd \
  -n argocd \
  --version 7.6.4 \
  -f ./values.yaml
  
# 서버 재시작
kubectl rollout restart deployment argocd-server -n argocd
```

## 3. 접속
* https://localhost:30443/
* 접속 정보는 values.yaml 참고

## 99. 참고
### 1. 삭제
```shell
helm uninstall argocd -n argocd
k delete ns argocd
```