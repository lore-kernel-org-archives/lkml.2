Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2JPHd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:33:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16962 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2JPHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:33:56 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-ca-507d0de17250
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 16/17] backlight: tosa: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:33:53 +0900
Message-id: <008101cdab70$9789f4e0$c69ddea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAARd+A
Content-language: ko
x-cr-hashedpuzzle: EFqX LMVE LhjF Ljvi Lu1E QV0q QeQr UAYL V8r/ cwxr f4D9 gTfT
 jKfI n+y5 qtCw
 utcM;4;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0AA==;Sosha1_v1;7;{82F3C8DF-5C94-4FE0-ABEF-779A1FA50344};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 16 Oct 2012 07:33:46
 GMT;WwBQAEEAVABDAEgAIAAxADYALwAxADcAXQAgAGIAYQBjAGsAbABpAGcAaAB0ADoAIAB0AG8AcwBhADoAIABmAGkAeAAgAGMAaABlAGMAawBwAGEAdABjAGgAIABlAHIAcgBvAHIAIABhAG4AZAAgAHcAYQByAG4AaQBuAGcA
x-cr-puzzleid: {82F3C8DF-5C94-4FE0-ABEF-779A1FA50344}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd2HvLUBBqtnCVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MPyvXMRe8Fqv4s3YFcwPjKaEuRk4OCQETif5HD1khbDGJC/fW
	s3UxcnEICSxilJj2/SIThDObSaKlfSkTSBWbgJrEly+H2UFsEYEIieYZs5i7GDk4mAV8JDbP
	0gQJCwnYSqye8RashFPATmLj64MsILawgIfEhq+9YHEWAVWJ5x/uMYLYvED1U162sEHYghI/
	Jt8Dq2cW0JJYv/M4E4QtL7F5zVuwVRIC6hKP/upCXGAk8fvHRlaIEhGJfS/eMYKcLCEwhVVi
	25UeqMdMJT5cucMygVFkFpIVs5CsmIVkxSwksxYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECA78Z1I7GFc2WBxiFOBgVOLhzXCuCRBiTSwrrsw9xCjBwawkwusxESjEm5JYWZValB9f
	VJqTWnyIUZqDRUmct9kjJUBIID2xJDU7NbUgtQgmy8TBKdXAuMWIef9RrTfS4RNqF9edOe69
	bh133Sdp9yzXw+5zO3+vvFlulj31iu+Cro5nVd1vfu+d2MqkMkfVyeTQxDMTX/xJYbkWv6ej
	fkOen+jlPYec/3tUiX2y/f7XazZrSRzXH83Mxze2eG+pfvP+nbH1xRfyd//2J53vf7T1mhlj
	t4v3hBVby6fa7VdiKc5INNRiLipOBAD+synbeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
ERROR: spaces required around that '?' (ctx:VxW)
ERROR: space required after that ',' (ctx:VxV)

Also, unnecessary lines are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/tosa_bl.c  |    4 ++--
 drivers/video/backlight/tosa_lcd.c |   16 +++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 49342e1..03c6ec2 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -90,7 +90,8 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	if (!data)
 		return -ENOMEM;
 
-	data->comadj = sharpsl_param.comadj == -1 ? COMADJ_DEFAULT : sharpsl_param.comadj;
+	data->comadj = sharpsl_param.comadj == -1 ?
+			COMADJ_DEFAULT : sharpsl_param.comadj;
 
 	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
@@ -163,7 +164,6 @@ static const struct i2c_device_id tosa_bl_id[] = {
 	{ },
 };
 
-
 static struct i2c_driver tosa_bl_driver = {
 	.driver = {
 		.name		= "tosa-bl",
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 33047a6..bcd97c5 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -63,7 +63,7 @@ static int tosa_tg_send(struct spi_device *spi, int adrs, uint8_t data)
 int tosa_bl_enable(struct spi_device *spi, int enable)
 {
 	/* bl_enable GP04=1 otherwise GP04=0*/
-	return tosa_tg_send(spi, TG_GPODR2, enable? 0x01 : 0x00);
+	return tosa_tg_send(spi, TG_GPODR2, enable ? 0x01 : 0x00);
 }
 EXPORT_SYMBOL(tosa_bl_enable);
 
@@ -91,15 +91,17 @@ static void tosa_lcd_tg_on(struct tosa_lcd_data *data)
 	tosa_tg_send(spi, TG_PNLCTL, value);
 
 	/* TG LCD pannel power up */
-	tosa_tg_send(spi, TG_PINICTL,0x4);
+	tosa_tg_send(spi, TG_PINICTL, 0x4);
 	mdelay(50);
 
 	/* TG LCD GVSS */
-	tosa_tg_send(spi, TG_PINICTL,0x0);
+	tosa_tg_send(spi, TG_PINICTL, 0x0);
 
 	if (!data->i2c) {
-		/* after the pannel is powered up the first time, we can access the i2c bus */
-		/* so probe for the DAC */
+		/*
+		 * after the pannel is powered up the first time,
+		 * we can access the i2c bus so probe for the DAC
+		 */
 		struct i2c_adapter *adap = i2c_get_adapter(0);
 		struct i2c_board_info info = {
 			.type	= "tosa-bl",
@@ -115,11 +117,11 @@ static void tosa_lcd_tg_off(struct tosa_lcd_data *data)
 	struct spi_device *spi = data->spi;
 
 	/* TG LCD VHSA off */
-	tosa_tg_send(spi, TG_PINICTL,0x4);
+	tosa_tg_send(spi, TG_PINICTL, 0x4);
 	mdelay(50);
 
 	/* TG LCD signal off */
-	tosa_tg_send(spi, TG_PINICTL,0x6);
+	tosa_tg_send(spi, TG_PINICTL, 0x6);
 	mdelay(50);
 
 	/* TG Off */
-- 
1.7.1


