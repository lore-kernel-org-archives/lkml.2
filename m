Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2KZBb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:31:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10003 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2KZBb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:31:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b7-50b2c66d5232
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>
References: 
In-reply-to: 
Subject: [PATCH v4 1/2] thermal: exynos: Fix wrong bit to control tmu core
Date: Mon, 26 Nov 2012 10:31:24 +0900
Message-id: <000001cdcb75$bfb84870$3f28d950$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QA04GwQA+GV/4ABLv0GoA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zI93cY5sCDOY1KVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7RtfMhacFa24tuUuawPjQoEuRk4OCQETiSkHHzNB2GISF+6t
	Z+ti5OIQEljGKPFhxSc2mKITd29BJRYxSjSvm8AC4cxjkug/+5sdpIpNQFfi2PotrCC2iEC0
	xJ/GPcwgRcwCTYwSR1vnARVxAHVwS6xuDgKp4RTgkVj3p5MZxBYW8JI4NGk7C4jNIqAq8Wva
	IrA5vAJ2Ehc3zWWGsAUlfky+B1bDLKAlsX7ncSYIW15i85q3zCDjJQTUJR791YU4wUmiefJG
	NogSEYl9L94xQowXkPg2+RALRLmsxKYDYFdKCCxjl/jybBbUw5ISB1fcYJnAKDELyeZZSDbP
	QrJ5FpIVCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmKExJbUDsaVDRaHGAU4GJV4eA1+
	bQwQYk0sK67MPcQowcGsJMI7kWlTgBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbnA+M+ryTe
	0NjYxMzE1MTc0tTcFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQZG6fNHfuzV/Fx73Evj
	Lk/l5+gP+7kCD86U+VGueYBz563qs5dbRT7ELt4307pRd9vKjRtnntkjMuFLUIb8tuhJL1/P
	MLhxsHRun+j7B36+a9J6ez9pPDk65SbrnM6VSRvWJz9+flBOvCzsqZW/uMD/0qwbLnslvryt
	uGEyf8qlRqUTsrb1Qfl/m5RYijMSDbWYi4oTAQac4ibaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAd3cY5sCDJb8ErW4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGds3vmQsOCtacW3LXdYG
	xoUCXYycHBICJhIn7t5ig7DFJC7cWw9kc3EICSxilGheN4EFwpnHJNF/9jc7SBWbgK7EsfVb
	WEFsEYFoiT+Ne5hBipgFmhgljrbOAyriAOrglljdHARSwynAI7HuTycziC0s4CVxaNJ2FhCb
	RUBV4te0RWBzeAXsJC5umssMYQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVvmUHGSwioSzz6qwtx
	gpNE8+SNbBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYIj95nUDsaVDRaHGAU4GJV4eA1+bQwQYk0sK67MPcQowcGsJMI7kWlTgBBvSmJl
	VWpRfnxRaU5q8SFGH6BHJzJLiSbnA5NKXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS
	1OzU1ILUIphxTBycUg2Muzmc8qV0vt2/8Cx77e6SKbplTKrCtxoUJ2hNSP5x1Z6VV9HAodDX
	n70mM6B+f50F08NlunzPfnPaO3pnpJtY5U24Fhv1efbHZy8b7estGX801BZnycy3iVz8ZsPB
	U+bz3han1E+I2bWoPTGAQY+98zCT+R+eoof7XgVXvBCVunNgyrZWwTtKLMUZiYZazEXFiQDw
	X7+YCQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 6dd29e4..129e827 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -52,9 +52,12 @@

 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
+#define EXYNOS_TMU_GAIN_MASK           (0xF << EXYNOS_TMU_GAIN_SHIFT)
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
-#define EXYNOS_TMU_CORE_ON             3
-#define EXYNOS_TMU_CORE_OFF            2
+#define EXYNOS_TMU_REF_VOLTAGE_MASK    (0x1F <<
EXYNOS_TMU_REF_VOLTAGE_SHIFT)
+#define EXYNOS_TMU_CORE_ON             BIT(0)
+#define EXYNOS_TMU_CORE_ON_SHIFT       0
+#define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
EXYNOS_TMU_CORE_ON_SHIFT)
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50

 /* Exynos4210 specific registers */
@@ -85,7 +88,9 @@
 #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 16)
 #define EXYNOS_MUX_ADDR_VALUE          6
 #define EXYNOS_MUX_ADDR_SHIFT          20
+#define EXYNOS_MUX_ADDR_MASK           (0x7 << EXYNOS_MUX_ADDR_SHIFT)
 #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
+#define EXYNOS_TMU_TRIP_MODE_MASK      (0x7 << EXYNOS_TMU_TRIP_MODE_SHIFT)

 #define EFUSE_MIN_VALUE 40
 #define EFUSE_MAX_VALUE 100
@@ -650,10 +655,14 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
        mutex_lock(&data->lock);
        clk_enable(data->clk);

-       con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
+       con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
+       con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK | EXYNOS_TMU_GAIN_MASK |
+               EXYNOS_TMU_CORE_ON_MASK);
+       con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
                pdata->gain << EXYNOS_TMU_GAIN_SHIFT;

        if (data->soc == SOC_ARCH_EXYNOS) {
+               con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
                con |= pdata->noise_cancel_mode <<
EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
        }
@@ -665,7 +674,6 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
                        pdata->trigger_level1_en << 4 |
                        pdata->trigger_level0_en;
        } else {
-               con |= EXYNOS_TMU_CORE_OFF;
                interrupt_en = 0; /* Disable all interrupts */
        }
        writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
--
1.7.4.1

