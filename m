Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2LTGdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:33:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:62670 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2LTGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:33:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-91-50d2b1463e11
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
In-reply-to: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
Subject: [PATCH 2/6] backlight: s6e63m0: use sleep instead of delay
Date: Thu, 20 Dec 2012 15:33:42 +0900
Message-id: <000a01cdde7b$f4530e80$dcf92b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9AAAAfGg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA123jZcCDLq79S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGs+XbWAp+clVM3POEuYHxPkcXIweHhICJxJ11Kl2MnECmmMSF
	e+vZuhi5OIQEljFKLLzzmhkiYSJx+cZPZojEdEaJiTens0M4s5kk/t54xA5SxSagJvHly2Ew
	W0QgQqJ5xixmkA3MAj4Sm2dpgoSFBGwl7iz+xwJicwrYSTR+2A1WLizgLPH7xTGwchYBVYkX
	e6pBwrxA5ZduN7BD2IISPybfA2tlFtCSWL/zOBOELS+xec1bZohf1CUe/dWFOMBIYtn/eVAl
	IhL7XrxjBLFZBAQkvk0+xAJRLiux6QDYVxICi9glepr+M0G8KylxcMUNlgmMErOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZIVEnvYFzVYHGIUYCDUYmHd9G0
	SwFCrIllxZW5hxglOJiVRHgX3roYIMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5wIjPK4k3
	NDY2MTMxNTG3NDU3xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoHRetHtZYzMS/v+GM3Z
	KGjeF3v7rY/j9W1CTl87FafafrHr3VAaHWO07KV7eLKBxl5N53PJGcVcp75HLVg032lxO0P/
	GSGrNPU5s9WMawSTUm80HNlX5lZp5FgTu2OHg+LMUz7tL/cV1QqaX09MOu/vruS1jGNZ97TY
	N+sP3Sxfdl7E8u0LZl4lluKMREMt5qLiRABEz/6Z1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQV23jZcCDK6f1ba4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGc+Wb2Mp+MlVMXHPE+YG
	xvscXYycHBICJhKXb/xkhrDFJC7cW8/WxcjFISQwnVFi4s3p7BDObCaJvzcesYNUsQmoSXz5
	chjMFhGIkGieMQuom4ODWcBHYvMsTZCwkICtxJ3F/1hAbE4BO4nGD7vByoUFnCV+vzgGVs4i
	oCrxYk81SJgXqPzS7QZ2CFtQ4sfke2CtzAJaEut3HmeCsOUlNq95C9YqIaAu8eivLsQBRhLL
	/s+DKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yf
	u4kRHLXPpHcwrmqwOMQowMGoxMO7aNqlACHWxLLiytxDjBIczEoivAtvXQwQ4k1JrKxKLcqP
	LyrNSS0+xOgD9OdEZinR5HxgQskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKanZpa
	kFoEM46Jg1OqgTE3Y3dE6bYi1ZXbu6SSVSaq+L23EXotxBh8gFHq92LvBTYzjx4533RhS1Hz
	UotF11Z/Ta8+KhioEj07YNrhq9OuTH12wzN5yawPbq86/TQ8MhU+s3ItzHjfV77sc+n22ztj
	hd4F/2Iou5/Taj/1OSP3zJOtT7+VORvxGb9//qhAt2tewZOPLc+UWIozEg21mIuKEwEkVPm8
	BwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces mdelay with msleep to remove the busy loop
waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index cae140d..cff4515 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -406,8 +406,9 @@ static int s6e63m0_panel_send_sequence(struct s6e63m0 *lcd,
 			ret = s6e63m0_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			udelay(wbuf[i+1]*1000);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -523,7 +524,7 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
 		return -EFAULT;
 	} else {
 		pd->power_on(lcd->ld, 1);
-		mdelay(pd->power_on_delay);
+		msleep(pd->power_on_delay);
 	}
 
 	if (!pd->reset) {
@@ -531,7 +532,7 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = s6e63m0_ldi_init(lcd);
@@ -573,7 +574,7 @@ static int s6e63m0_power_off(struct s6e63m0 *lcd)
 		return -EIO;
 	}
 
-	mdelay(pd->power_off_delay);
+	msleep(pd->power_off_delay);
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-- 
1.7.2.5


