Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2JPH3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:29:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33751 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2JPH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:29:28 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-30-507d0cd71d93
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 07/17] backlight: ili9320: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:29:27 +0900
Message-id: <007801cdab6f$f92b5aa0$eb820fe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAHf+Q
Content-language: ko
x-cr-hashedpuzzle: Hzlt IDB4 KUdv Kjux K2mO NZ/G Nv0H OzQW QT/7 Vlo9 YZnJ b8/z
 iU2e kwxE p6+6
 tR0j;4;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0AA==;Sosha1_v1;7;{C9D54427-B94D-4113-8817-CA86F4585727};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 16 Oct 2012 07:29:20
 GMT;WwBQAEEAVABDAEgAIAAwADcALwAxADcAXQAgAGIAYQBjAGsAbABpAGcAaAB0ADoAIABpAGwAaQA5ADMAMgAwADoAIABmAGkAeAAgAGMAaABlAGMAawBwAGEAdABjAGgAIABlAHIAcgBvAHIAIABhAG4AZAAgAHcAYQByAG4AaQBuAGcA
x-cr-puzzleid: {C9D54427-B94D-4113-8817-CA86F4585727}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd3rPLUBBhcPK1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M2Sd3sRQcEKmYe6GbrYHxg0AXIyeHhICJRMOBuSwQtpjEhXvr
	2boYuTiEBBYxSsxYsIoFwpnNJLHowh0mkCo2ATWJL18Os4PYIgIREs0zZjF3MXJwMAv4SGye
	pQkSFhKwlVg94y1YCaeAncTG1wdZQEqEBbwl9lz0BwmzCKhKtPyeywhi8wKVP3w2gxXCFpT4
	Mfke2D3MAloS63ceZ4Kw5SU2r3kLtklCQF3i0V9diAOMJA5ff8MOUSIise/FO0aIV+awSjyY
	nQJRbipxbqnvBEaRWUgWzEKyYBaSBbOQTFrAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	Izjkn0nvYFzVYHGIUYCDUYmHN8O5JkCINbGsuDL3EKMEB7OSCK/HRKAQb0piZVVqUX58UWlO
	avEhRmkOFiVx3maPlAAhgfTEktTs1NSC1CKYLBMHp1QDY2h9z1QF5T+9xntf7cjOnNl2+rxn
	8OTQpeE7n4S1ftX3Mq/smXD01AyfwCb1ColneefCzh7+aCC24/9qkZ7TQvxr3YO2XNeY3Xd5
	Rtk/izC/ENuPD/1Np6adnXviH1PDT1GuPb18d/+L6l5bIl+3fBnL36kLvq3c96v7eXmqNU+3
	aHz81/c+L5RYijMSDbWYi4oTAY79F511AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
WARNING: braces {} are not necessary for single statement blocks
ERROR: code indent should use tabs where possible

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/ili9320.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 9327cd1..a66cfd1 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -45,7 +45,7 @@ static inline int ili9320_write_spi(struct ili9320 *ili,
 	/* second message is the data to transfer */
 
 	data[0] = spi->id | ILI9320_SPI_DATA  | ILI9320_SPI_WRITE;
- 	data[1] = value >> 8;
+	data[1] = value >> 8;
 	data[2] = value;
 
 	return spi_sync(spi->dev, &spi->message);
@@ -56,7 +56,6 @@ int ili9320_write(struct ili9320 *ili, unsigned int reg, unsigned int value)
 	dev_dbg(ili->dev, "write: reg=%02x, val=%04x\n", reg, value);
 	return ili->write(ili, reg, value);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_write);
 
 int ili9320_write_regs(struct ili9320 *ili,
@@ -74,7 +73,6 @@ int ili9320_write_regs(struct ili9320 *ili,
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_write_regs);
 
 static void ili9320_reset(struct ili9320 *lcd)
@@ -260,7 +258,6 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
 
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
 int ili9320_remove(struct ili9320 *ili)
@@ -271,7 +268,6 @@ int ili9320_remove(struct ili9320 *ili)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_remove);
 
 #ifdef CONFIG_PM
@@ -296,20 +292,17 @@ int ili9320_suspend(struct ili9320 *lcd, pm_message_t state)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_suspend);
 
 int ili9320_resume(struct ili9320 *lcd)
 {
 	dev_info(lcd->dev, "resuming from power state %d\n", lcd->power);
 
-	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP)
 		ili9320_write(lcd, ILI9320_POWER1, 0x00);
-	}
 
 	return ili9320_power(lcd, FB_BLANK_UNBLANK);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_resume);
 #endif
 
@@ -318,7 +311,6 @@ void ili9320_shutdown(struct ili9320 *lcd)
 {
 	ili9320_power(lcd, FB_BLANK_POWERDOWN);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_shutdown);
 
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
-- 
1.7.1


