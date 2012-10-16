Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2JPH00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:26:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24428 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:26:25 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-77-507d0c1f2a68
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 02/17] backlight: atmel-pwm-bl: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:26:23 +0900
Message-id: <007301cdab6f$8bce11f0$a36a35d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAAx7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV0FntoAgztTWC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG15VjLAVLOCpO7mtia2BsYu9i5OSQEDCRmNXfzQhhi0lcuLee
	rYuRi0NIYBGjRMefHVDObCaJaT/uMoFUsQmoSXz5chisW0QgQqJ5xizmLkYODmYBH4nNszRB
	wkICthKrZ7wFK+EUsJPY+PogC4gtLOAmsX7rLjCbRUBV4s++bjYQmxeo/tPZv6wQtqDEj8n3
	wGqYBbQk1u88zgRhy0tsXvMWbJWEgLrEo7+6EBcYSVz5PheqRERi34t3jBMYhWYhmTQLyaRZ
	SCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwGD+T2sG4ssHiEKMAB6MSD2+G
	c02AEGtiWXFl7iFGCQ5mJRFej4lAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp
	2ampBalFMFkmDk6pBsag8DAp5dM9+pKpJzN/8p2pqlpZ1Gf8gGkem+COmEJv97ClO7crpboY
	2B099aPm6JzYZeUqXpttzVKWsL9M2Ph86xE+NQ1DY81m5Q2L1t+INlvbH1ka7mHpWiLEsGmD
	1F/BJxK/hZ7oixk8fVygsnD+r8qe1H95fvGXVMzunptQKr3+oPt2ISWW4oxEQy3mouJEAFLD
	2BBfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/atmel-pwm-bl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index df1cbb7..de5e5e7 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -106,10 +106,9 @@ static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
 	pwm_channel_writel(&pwmbl->pwmc, PWM_CPRD,
 			pwmbl->pdata->pwm_compare_max);
 
-	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver "
-			"(%lu Hz)\n", pwmbl->pwmc.mck /
-			pwmbl->pdata->pwm_compare_max /
-			(1 << prescale));
+	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver (%lu Hz)\n",
+		pwmbl->pwmc.mck / pwmbl->pdata->pwm_compare_max /
+		(1 << prescale));
 
 	return pwm_channel_enable(&pwmbl->pwmc);
 }
-- 
1.7.1


