Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2LTGat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:30:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20389 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:30:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d5-50d2b092436f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
In-reply-to: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
Subject: [PATCH 4/5] backlight: ams369fg06: remove redundant variable
 'before_power'
Date: Thu, 20 Dec 2012 15:30:41 +0900
Message-id: <000701cdde7b$88aa0580$99fe1080$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3eeyqi7zfdOO97SfGBrHQPr76IuAAAEUvA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA91JGy4FGCy/zG1xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyzszzLFjLX9E8+SJrA+MZni5GTg4JAROJNZ2LGCFsMYkL99az
	dTFycQgJLGOU+DT3AnsXIwdY0b6nDhDxRYwSnb9vMUI4s5kkzu+ZywrSzSagJvHly2F2EFtE
	IEKiecYsZpBmZgEfic2zNEHCQgK2Eu1zDzOB2JwCdhLNH46ClQsLhEmcfPsF7AgWAVWJuefO
	gdm8QPWT5u5lh7AFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxJ3qEo/+6kJcYCSx/dEWZogS
	EYl9L95BjReQ+Db5EAtEuazEpgPMIJ9ICCxil+ja/o4ZEg6SEgdX3GCZwCgxC8nmWUg2z0Ky
	eRaSFQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525ihESV9A7GVQ0WhxgFOBiVeHgXTbsU
	IMSaWFZcmXuIUYKDWUmEd+GtiwFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M+LySeENj
	YxMzE1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGOXti3aVfLmVd2Hf35WM
	3WHWh2xlF+6W5Ui97f7h/nWWQFvpwrtfonUuqqukb3vw6MqC+lmT118/tOdSqNgSeY6XrPov
	rV+UzlHs9Ujc3PPP80ir7fbQdBOG7S3GhRtrWk1Pf/8SxnXYzUpcoVd0X/e37SyOBhFd4iFS
	Cad3dL+2vS4euG6rvxJLcUaioRZzUXEiAI+M1JvXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd1JGy4FGGzfxWpxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM87M8yxYy1/RPPkiawPj
	GZ4uRg4OCQETiX1PHboYOYFMMYkL99azdTFycQgJLGKU6Px9ixHCmc0kcX7PXFaQKjYBNYkv
	Xw6zg9giAhESzTNmMYMMYhbwkdg8SxMkLCRgK9E+9zATiM0pYCfR/OEoWLmwQJjEybdfGEFs
	FgFVibnnzoHZvED1k+buZYewBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8TN6hKP/upCXGAk
	sf3RFmaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBMftMegfjqgaLQ4wCHIxKPLyLpl0KEGJNLCuuzD3EKMHBrCTCu/DWxQAh3pTEyqrU
	ovz4otKc1OJDjD5Aj05klhJNzgemk7ySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZ
	qakFqUUw45g4OKUaGE03/G24rzn1h3LdJdujm+Uvsmy3+HFMw6RP3yP6+Iz9f7du0rPTZNjI
	/tE9yEuAgc9fkGnJy02VxumxOwWn3/ofetK890n3+XUmbBXvTJIUbHwEFghm/jslfHb+Jt3A
	RRnszp9CfQymhGzd2PQu/ghzje5OnYuarAqTnP3uyax5+8Bw7rQvd5RYijMSDbWYi4oTAV7S
	5nIGAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'before_power' was used to check the previous status when resume()
is called. However, FB_BLANK_POWERDOWN was used in suspend() all
the time, so there is no need to check the previous status.
Also, redundant return variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 22756dd..4794a9a 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -545,44 +545,26 @@ static int ams369fg06_remove(struct spi_device *spi)
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
-
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ams369fg06_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
-	/*
-	 * after suspended, if lcd panel status is FB_BLANK_UNBLANK
-	 * (at that time, before_power is FB_BLANK_UNBLANK) then
-	 * it changes that status to FB_BLANK_POWERDOWN to get lcd on.
-	 */
-	if (before_power == FB_BLANK_UNBLANK)
-		lcd->power = FB_BLANK_POWERDOWN;
+	lcd->power = FB_BLANK_POWERDOWN;
 
-	dev_dbg(&spi->dev, "before_power = %d\n", before_power);
-
-	ret = ams369fg06_power(lcd, before_power);
-
-	return ret;
+	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
 #else
 #define ams369fg06_suspend	NULL
-- 
1.7.2.5


