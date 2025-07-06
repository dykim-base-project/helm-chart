# 🐧 Ubuntu SSH Helm Chart

이 Helm Chart는 Ubuntu 22.04 기반 컨테이너에 다음을 구성합니다:

* SSH 서버(`openssh-server`) 설치 및 시작
* 사용자(`ubuntu`) 생성 및 `sudo` 권한 부여
* RSA 키 기반 SSH 접속 설정
* Readiness, Liveness, Startup Probe 설정
* ArgoCD 및 Helm 기반 GitOps 배포 진행

---

## 포함 구조

| 구조           | 설명                                                 |
| ------------ | -------------------------------------------------- |
| `Deployment` | Ubuntu 컨테이너에 SSH 서버 및 사용자 생성, 설정 스크립트 시킵           |
| `Secret`     | 사용자 SSH 공개키 (`id_rsa.pub`) 를 주입                    |
| `ConfigMap`  | `setup.sh` 스크립트로 사용자, 권한, SSHD 설정                  |
| `Service`    | NodePort(기본: `30222`) 로 SSH 접속 가능                  |
| `Namespace`  | `sample` 네임스페이스 생성 및 모든 리소스 배포                     |
| `Probes`     | `tcpSocket` 기반 readiness/liveness/startup probe 설정 |

---

## 설치 전 요구사항

* Helm 3.x 이상
* ArgoCD 또는 Helm CLI
* SSH 키페에 (`id_rsa`, `id_rsa.pub`) 준비

---

## 설치 방법

### 1. SSH 키페에 생성 (필요 시)

```bash
ssh-keygen -t rsa -b 2048 -f id_rsa -N ""
```

### 2. `values.yaml`에 공개키 입력

```yaml
ssh:
  user: ubuntu
  port: 2222
  publicKey: |
    ssh-rsa AAAAB3NzaC1...your_key_here... user@example.com
```

### 3. Helm 설치

```bash
helm upgrade --install ubuntu-ssh ./ubuntu-ssh-chart -n sample --create-namespace
```

가능하면 ArgoCD UI에서 Application으로 배포 (Helm 방식 선택)

---

## SSH 접속 방법

1. 비공개키 저장

```bash
kubectl get secret ssh-key-secret -n sample -o jsonpath='{.data.id_rsa}' | base64 -d > id_rsa
chmod 600 id_rsa
```

2. 접속

```bash
ssh -i id_rsa ubuntu@<노드IP> -p 30222
```

> `NodePort` 서비는 기본 30222이며, 클래스터 외부 노드에서 접근 가능해야 합니다.

---

## 해시체크 (Probes)

| 유형        | 설정 방식                            |
| --------- | -------------------------------- |
| Readiness | TCP: 2222, 5초 디레이, 10초 주기        |
| Liveness  | TCP: 2222, 10초 디레이, 20초 주기       |
| Startup   | TCP: 2222, 0초 디레이, 5초 주기, 30번 시도 |

---

## 제거

```bash
helm uninstall ubuntu-ssh -n sample
kubectl delete namespace sample
```

---

## 보안 권고

* 개인키(`id_rsa`)는 가까운 Git에 포함하지 마세요
* `SealedSecrets` 또는 `ExternalSecrets`로 키 관리 자동화 가능
* 운영 환경에서는 SSH 접속을 제한하거나 인증 로그를 수집하세요

---

## 참고

* 이미지: `ubuntu:22.04`
* SSH 포트: 기본 `2222`, `NodePort: 30222`
* 사용자: `ubuntu`, sudo 권한 포함
* Helm Chart는 `templates/setup.sh`를 통해 초기화
