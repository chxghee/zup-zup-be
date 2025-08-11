package com.greedy.zupzup.schoolarea.presentation.dto;

import com.greedy.zupzup.schoolarea.application.dto.FindAreaCommand;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

public record LatLngRequest(
        @NotNull(message = "위도를 입력해주세요.")
        @DecimalMin(value = "-90", message = "위도는 -90 이상이어야 합니다.")
        @DecimalMax(value = "90", message = "위도는 90 이하여야 합니다.")
        Double lat,

        @NotNull(message = "경도를 입력해주세요.")
        @DecimalMin(value = "-180", message = "경도는 -180 이상이어야 합니다.")
        @DecimalMax(value = "180", message = "경도는 180 이하여야 합니다.")
        Double lng
) {
    public FindAreaCommand toCommand() {
        return new FindAreaCommand(lat, lng);
    }
}
