#!/bin/bash

# 명령 에러 발생 시 종료
set -e

PROJECT_ROOT="/home/ubuntu/zupzup/deploy"
APP_NAME="zupzup"

APP_LOG="/home/ubuntu/zupzup/logs/application.log"
APP_ERROR_LOG="/home/ubuntu/zupzup/logs/jvm_error.log"
DEPLOY_LOG="/home/ubuntu/zupzup/logs/deploy.log"

# 배포 중 에러 발생으로 중단 시 로그 기록 함수
on_error() {
  echo "********** [배포 중 에러 발생] : $(date +%Y-%m-%d\ %H:%M:%S) **********" >> $DEPLOY_LOG
  echo "   -> 실패한 명령어: '$BASH_COMMAND'" >> $DEPLOY_LOG
  echo "   -> 위치: ${BASH_SOURCE[1]}:${LINENO[1]}" >> $DEPLOY_LOG
  exit 1
}
trap on_error ERR

echo "=========== [배포 시작] : $(date +%Y-%m-%d\ %H:%M:%S) ===========" >> $DEPLOY_LOG

cd $PROJECT_ROOT


# 1. jar 파일 시간 순 정렬 후 가장 상단에 있는(가장 최신) plain 이 아닌 jar 파일을 선택
JAR_FILE=$PROJECT_ROOT/build/libs/*.jar


# 2. 실행 중인 애플리케이션이 있으면 종료
if pgrep -f "$APP_NAME" > /dev/null; then
  echo "  -> 실행 중인 애플리케이션에 종료 신호 전송" >> $DEPLOY_LOG
  pkill -15 -f "$APP_NAME"
  sleep 5 # 종료될 시간을 5초간 '믿고' 기다립니다.
else
  echo "  -> 현재 실행 중인 애플리케이션이 없습니다." >> $DEPLOY_LOG
fi


# 3. 새 애플리케이션 백그라운드 실행
echo "> 새 애플리케이션 실행" >> $DEPLOY_LOG
nohup java \
    -Dspring.profiles.active=prod \
    -DDB_HOST="$DB_HOST" \
    -DDB_USERNAME="$DB_USERNAME" \
    -DDB_PASSWORD="$DB_PASSWORD" \
    -DAWS_S3_ACCESS_KEY="$AWS_S3_ACCESS_KEY" \
    -DAWS_S3_SECRET_ACCESS_KEY="$AWS_S3_SECRET_ACCESS_KEY" \
    -DAWS_S3_BUCKET_NAME="$AWS_S3_BUCKET_NAME" \
    -DACCESS_TOKEN_SECRET_KEY="$ACCESS_TOKEN_SECRET_KEY" \
    -DACCESS_TOKEN_EXPIRATION="$ACCESS_TOKEN_EXPIRATION" \
    -DSTUDENT_VERIFICATION_SESSION_TIME="$STUDENT_VERIFICATION_SESSION_TIME" \
    -jar $JAR_FILE > $APP_LOG 2> $APP_ERROR_LOG &

# Logback으로 설정한 레벨별 로그 분리가 머지가 되면  $APP_LOG 는 지우고 /dev/null 로 버릴 수 있도록 (남길수도?)



# 4. 애플리케이션 실행 여부 체크
NEW_PID=$(pgrep -f "$APP_NAME")
if [ -n "$NEW_PID" ]; then
  echo "  -> 애플리케이션 실행 성공 (PID: $NEW_PID)" >> $DEPLOY_LOG
else
  echo "  -> 애플리케이션 실행 실패" >> $DEPLOY_LOG
  exit 1
fi

echo "=========== [배포 완료] : $(date +%Y-%m-%d\ %H:%M:%S) ===========" >> $DEPLOY_LOG
