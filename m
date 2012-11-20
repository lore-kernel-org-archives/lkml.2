Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2KTA5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:57:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64958 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2KTA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:57:38 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cd-50aad57fcfc6
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
Date: Tue, 20 Nov 2012 09:57:35 +0900
Message-id: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QAAAg6wADTi5aAD4ZQRQA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI936q6sCDP59ELe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ7V8eMhfME6p4+le6gfEVTxcjJ4eEgInEmWMr2SFsMYkL99az
	dTFycQgJLGOUeHJwDStM0dErG1khEtMZJWbd/8gE4cxjkni2bSIbSBWbgK7EsfVbwDpEBKIl
	/jTuYQYpYhZoYpRonL8IyOEA6uCWWN0cBFLDKcAjse5PJzOILSzgKDFz3SEWEJtFQFVi7703
	YHN4BewkHk/ZyQZhC0r8mHwPrIZZQEti/c7jTBC2vMTmNW/BxksIqEs8+qsLYooIOEn8WqgD
	USEise/FO0aI6QIS3yaDbAKplpXYdADsSAmBZewSO872skD8KylxcMUNlglAnyJZPAvJ4llI
	Fs9CsmIBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjJC4ktrBuLLB4hCjAAejEg/vw4RV
	AUKsiWXFlbmHGCU4mJVEeJvKgUK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqcD4z5vJJ4Q2Nj
	EzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYndIeWM1kn8pyU+vQ1Xl3
	E04K/InNEDtbMTW60u71lk3tL8ymJ/uskPq/5tmJ0pMrlzDHbfD+/2ob49tdnql8PmWbJwcE
	/JHJPigpUNIi0PUuZfFDY/FzXBkd55o5pXi4t7VwPSiUDLMPqVp/TlGdYVJSz4NZ7mKRu9U4
	3t8tET7y3a+sK32tEktxRqKhFnNRcSIA2DR8ztgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd36q6sCDGZuEra4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGe1fHjIXzBOqePpXuoHx
	FU8XIyeHhICJxNErG1khbDGJC/fWs3UxcnEICUxnlJh1/yMThDOPSeLZtolsIFVsAroSx9Zv
	AesQEYiW+NO4hxmkiFmgiVGicf4iIIcDqINbYnVzEEgNpwCPxLo/ncwgtrCAo8TMdYdYQGwW
	AVWJvffegM3hFbCTeDxlJxuELSjxY/I9sBpmAS2J9TuPM0HY8hKb17wFGy8hoC7x6K8uiCki
	4CTxa6EORIWIxL4X7xgnMArNQjJoFpJBs5AMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Kh9JrWDcWWDxSFGAQ5GJR7ehwmrAoRYE8uKK3MPMUpwMCuJ8DaVA4V4UxIrq1KL
	8uOLSnNSiw8x+gD9OZFZSjQ5H5hQ8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGan
	phakFsGMY+LglGpgFL4QY1AiJ+j1bcf6mycmLZ1fXpYTLDZX6x6r0y3udTnaZv2eH/ycX205
	MHO35/M7mrqfmT4/Mrq/5JGS/mOflh07yu1vXA7lur5taXp27pYdSz9t+fPv3Urzoys3zV+s
	ZOZuFRcZ9ntqRv6x99Fyqx+ruK/9F7t6wkynFVN6YvJPurkozv22wluJpTgj0VCLuag4EQCz
	GOzRBwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU urgently sends active-high signal (thermal trip) to PMU,
and thermal tripping by hardware logic i.e PMU is performed.
Thermal tripping means that PMU cut off the whole power of SoC
by controlling external voltage regulator.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 129e827..569478d 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -58,6 +58,7 @@
 #define EXYNOS_TMU_CORE_ON             BIT(0)
 #define EXYNOS_TMU_CORE_ON_SHIFT       0
 #define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
EXYNOS_TMU_CORE_ON_SHIFT)
+#define EXYNOS_TMU_TRIP_EN             BIT(12)
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50

 /* Exynos4210 specific registers */
@@ -631,6 +632,12 @@ static int exynos_tmu_initialize(struct platform_device
*pdev)
                        goto out;
                }
                rising_threshold |= (threshold_code << 16);
+               threshold_code = temp_to_code(data,
pdata->trigger_levels[3]);
+               if (threshold_code < 0) {
+                       ret = threshold_code;
+                       goto out;
+               }
+               rising_threshold |= (threshold_code << 24);

                writel(rising_threshold,
                                data->base + EXYNOS_THD_TEMP_RISE);
@@ -665,6 +672,8 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
                con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
                con |= pdata->noise_cancel_mode <<
EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
+               if (pdata->trigger_levels[3])
+                       con |= EXYNOS_TMU_TRIP_EN;
        }

        if (on) {
@@ -770,6 +779,7 @@ static struct exynos_tmu_platform_data const
exynos_default_tmu_data = {
        .trigger_levels[0] = 85,
        .trigger_levels[1] = 103,
        .trigger_levels[2] = 110,
+       .trigger_levels[3] = 120,
        .trigger_level0_en = 1,
        .trigger_level1_en = 1,
        .trigger_level2_en = 1,
--
1.7.4.1

