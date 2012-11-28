Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2K1AsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:48:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35560 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2K1AsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:48:20 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b0-50b55f5373bb
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH 2/2] thermal: exynos: Add error handling for temperature code
Date: Wed, 28 Nov 2012 09:48:19 +0900
Message-id: <001301cdcd02$0f6bbcc0$2e433640$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QAAAg6wADTi5aAD4ZQRQAEu+fZgAGMNkmA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI93g+K0BBot+G1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mhc/3MxV84qjomfOSrYFxF1sXIweHhICJxJ41EV2MnECmmMSF
	e+uBwlwcQgLLGCWm73zHDJEwkZi2dhpUYjqjxLy25ewQzjwmiZZVu9lBqtgEdCWOrd/CCmKL
	CERL/GncwwxSxCzQxCjROH8RM8g6IQFuidXNQSA1nAI8Euv+dIJtEBbwlXjTN5MFxGYRUJVY
	OP8I2ExeATuJX9vWMELYghI/Jt8Dq2EW0JJYv/M4E4QtL7F5zVtmiG/UJR791QUxRQT8JOad
	sIKoEJHY9+IdI8R0AYlvkw+xQFTLSmw6AHakhMAidomWQ5tZIf6VlDi44gbLBEaJWUgWz0Ky
	eBaSxbOQrFjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIySupHcwrmqwOMQowMGoxMPr
	4Lg1QIg1say4MvcQowQHs5IIb1okUIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgTGfVxJv
	aGxsYmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVANj4OGEG/Hvuxkfinkf
	CIs+slg8+V9szMYPNhe8nhQvujntmNzJxYUpZvfVwx5UXnlW6DfvngmPYsjLdQ22kivDNns2
	MB773GibH33i11LVm4Hlu2UWnZ/yWemnmONzu/TT7xaKS5jsTc7Wu5RjYpNq1/HsxhrpnRE/
	t8/g0+l+oxZxQedzcXuiEktxRqKhFnNRcSIAcHpbqtgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd3g+K0BBs+P6ltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIXP9zMVfOKo6Jnzkq2B
	cRdbFyMnh4SAicS0tdOgbDGJC/fWA9lcHEIC0xkl5rUtZ4dw5jFJtKzazQ5SxSagK3Fs/RZW
	EFtEIFriT+MeZpAiZoEmRonG+YuAHA6gDm6J1c1BIDWcAjwS6/50MoPYwgK+Em/6ZrKA2CwC
	qhIL5x8Bm8krYCfxa9saRghbUOLH5HtgNcwCWhLrdx5ngrDlJTaveQs2XkJAXeLRX10QU0TA
	T2LeCSuIChGJfS/eMU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBcftMegfjqgaLQ4wCHIxKPLwOjlsDhFgTy4orcw8xSnAwK4nwpkUChXhTEiurUovy
	44tKc1KLDzH6AP05kVlKNDkfmFLySuINjU3MjCyNzCyMTMzNcQgrifM2e6QECAmkJ5akZqem
	FqQWwYxj4uCUamBcdVF0mQfjjan7GwpV6hs3q/TGPtxvcrPY9cCei5Lfpx3dw6dbEDr3x8+3
	OU5RV3aX71TT0FzIJr351zPTZxwr1A+68ZVuFJ9hz5Qbs3bm1n/i263MJa58vhPVVLhnsmtb
	+iX5fR+ixSLOvwwVXtq+3l2t5U5sQMK59vU2Ux4ZsO93qV3D0b9ciaU4I9FQi7moOBEAoje1
	OAgDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If temperature code is invalid, it should be handled.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index dc2ad6c..78c5c08 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -346,15 +346,19 @@ static int exynos_get_temp(struct thermal_zone_device
*thermal,
                        unsigned long *temp)
 {
        void *data;
+       int tmp;

        if (!th_zone->sensor_conf) {
                pr_info("Temperature sensor not initialised\n");
                return -EINVAL;
        }
        data = th_zone->sensor_conf->private_data;
-       *temp = th_zone->sensor_conf->read_temperature(data);
+       tmp = th_zone->sensor_conf->read_temperature(data);
+       if (tmp < 0)
+               return tmp;
+
        /* convert the temperature into millicelsius */
-       *temp = *temp * MCELSIUS;
+       *temp = tmp * MCELSIUS;
        return 0;
 }

--
1.7.4.1

