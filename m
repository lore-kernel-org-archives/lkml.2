Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2LTGiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:38:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63507 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2LTGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:38:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-15-50d2b257c776
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
In-reply-to: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
Subject: [PATCH 3/5] backlight: ld9040: replace EFAULT with EINVAL
Date: Thu, 20 Dec 2012 15:38:15 +0900
Message-id: <001101cdde7c$96cb4fb0$c461ef10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3efF04bK/W++SuRFi0yIAkd2rsTAAACm8g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI93wTZcCDFZfE7a4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZx7ftZS04xV7x+HUjawPjLLYuRk4OCQETiSP/5jBB2GISF+6t
	B4pzcQgJLGOUaGn5zApT9HLOH0aIxCJGidUPfzJBOLOZJE69Pc8OUsUmoCbx5cthMFtEIEKi
	ecYs5i5GDg5mAR+JzbM0QcJCArYSCzZMACvhFLCTmH17GtgCYQEnic0rvoJdwSKgKnH/40UW
	kFZeoPrpxyRBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMWbJOEgLrEo7+6EAcYSXw8cJ4N
	okREYt+Ld4wQ0wUkvk0+xAJRLiux6QAzyCMSAsvYJfbOamaGeFdS4uCKGywTGCVmIdk8C8nm
	WUg2z0KyYgEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MkLiS2sG4ssHiEKMAB6MSD++i
	aZcChFgTy4orcw8xSnAwK4nwLrx1MUCINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84Exn1cS
	b2hsbGJmYmpibmlqbopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDo+jiCS6lHE9s+08x
	/rX1SPmZ96T/h4kWT7NxpMVSyVufNovK+7N2pHYEvhevtrg19TzDAd1Fv6/erxG9wz65r+a8
	3A359gti23xD39TIpK93Pjjt6v7qYPHmZzu1FdVjQnX9shVlOzlenZn3cvEBj1qtOJdgwaU1
	le/e95pL+XteenWg5o69EktxRqKhFnNRcSIAcXqjqNgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd3wTZcCDDa94Le4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGce37WUtOMVe8fh1I2sD
	4yy2LkZODgkBE4mXc/4wQthiEhfurQeKc3EICSxilFj98CcThDObSeLU2/PsIFVsAmoSX74c
	BrNFBCIkmmfMYu5i5OBgFvCR2DxLEyQsJGArsWDDBLASTgE7idm3p7GC2MICThKbV3xlArFZ
	BFQl7n+8yALSygtUP/2YJEiYV0BQ4sfkeywgNrOAlsT6nceZIGx5ic1r3oJtkhBQl3j0Vxfi
	ACOJjwfOs0GUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAiO2mdSOxhXNlgcYhTgYFTi4V007VKAEGtiWXFl7iFGCQ5mJRHehbcuBgjxpiRW
	VqUW5ccXleakFh9i9AH6cyKzlGhyPjCh5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8s
	Sc1OTS1ILYIZx8TBKdXAeDxjzqQJP8R6Kv3PWurniAfdf9IZK/7q0sTc2oMvRItYGrsMQrsd
	WbXLiz3WyRzXuNf18w1XuKUhS9Vhlepdbtb3jzznEtYx63xkUC1+QfXyCWuHo9dzIuO+3v0c
	YPYn6mjOf78vOn1tv08djKtX1Zo3YfXZZbdC38kKcCvzaD1/J85yxkNEiaU4I9FQi7moOBEA
	tagQaQcDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces EFAULT with EINVAL, because EFAULT tends to be
for the invalid memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 45f795a..fd7bb1c 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -583,7 +583,7 @@ static int ld9040_power_on(struct ld9040 *lcd)
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -724,7 +724,7 @@ static int ld9040_probe(struct spi_device *spi)
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	mutex_init(&lcd->lock);
-- 
1.7.2.5


