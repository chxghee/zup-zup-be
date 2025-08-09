package com.greedy.zupzup.global.exception;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
public enum CommonException implements ExceptionCode {

    ENDPOINT_NOT_FOUND(HttpStatus.NOT_FOUND, "요청 경로를 찾을 수 없음", "요청한 URL에 해당하는 API를 찾을 수 없습니다."),
    INVALID_REQUEST_BODY(HttpStatus.BAD_REQUEST, "잘못된 요청 본문", "요청 본문의 형식이 잘못되었습니다."),
    INVALID_QUERY_PARAMETER(HttpStatus.BAD_REQUEST, "잘못된 쿼리 파라미터", "쿼리 파라미터의 형식이 잘못되었습니다."),
    QUERY_PARAMETER_TYPE_MISMATCH(HttpStatus.BAD_REQUEST, "쿼리 파라미터 타입 불일치", "요청 파라미터의 타입이 잘못되었습니다."),
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "유효하지 않은 입력값", "입력값이 유효성 검사를 통과하지 못했습니다."),
    UNSUPPORTED_MEDIA_TYPE(HttpStatus.UNSUPPORTED_MEDIA_TYPE, "지원하지 않는 미디어 타입", "서버에서 지원하지 않는 Content-Type 입니다."),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "지원하지 않는 메소드", "해당 엔드 포인트는 서버에서 지원하지 않는 HTTP 메소드 입니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "알 수 없는 오류", "서버 내부에 알 수 없는 오류가 발생했습니다. 관리자에게 문의 하세요.")
    ;

    private final HttpStatus httpStatus;
    private final String title;
    private final String detail;

    @Override
    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    @Override
    public String getTitle() {
        return title;
    }

    @Override
    public String getDetail() {
        return detail;
    }
}
