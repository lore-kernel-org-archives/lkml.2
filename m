Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2JPH27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:28:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33663 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2JPH26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:28:58 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-5d-507d0cb8adb4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 06/17] backlight: hp680_bl: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:28:56 +0900
Message-id: <007701cdab6f$e6f926a0$b4eb73e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAGRlQ
Content-language: ko
x-cr-hashedpuzzle: CASD DaeK Dmb6 FioV GmFO Jxtn QR8S R/LU T3KP Y2VL eU1C fHBL
 fp7p kUWX mBVg
 nt4W;4;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0AA==;Sosha1_v1;7;{4E2B2D60-5B86-47C9-89CA-28E5922591E4};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 16 Oct 2012 07:28:50
 GMT;WwBQAEEAVABDAEgAIAAwADYALwAxADcAXQAgAGIAYQBjAGsAbABpAGcAaAB0ADoAIABoAHAANgA4ADAAXwBiAGwAOgAgAGYAaQB4ACAAYwBoAGUAYwBrAHAAYQB0AGMAaAAgAGUAcgByAG8AcgAgAGEAbgBkACAAdwBhAHIAbgBpAG4AZwA=
x-cr-puzzleid: {4E2B2D60-5B86-47C9-89CA-28E5922591E4}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAd2dPLUBBpd7mSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG995XzAW7OSsebDzE1sD4n72LkZNDQsBE4sDa/ywQtpjEhXvr
	2UBsIYFFjBI3ptd3MXIB2bOZJJYsfcYEkmATUJP48uUwWLOIQIRE84xZzF2MHBzMAj4Sm2dp
	QvTaSqye8RashFPATmLj64Ng84WBSjpmvAMbwyKgKvHkcBcjiM0LVP9r11ZmCFtQ4sfke2D1
	zAJaEut3HmeCsOUlNq95C7ZKQkBd4tFfXYgLjCQOPrnIClEiIrHvxTtGkJMlBBawSmyc2McG
	8ZepxPUVa9gmMIrMQrJiFpIVs5CsmIVk1gJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wWH/TGoH48oGi0OMAhyMSjy8Gc41AUKsiWXFlbmHGCU4mJVEeD0mAoV4UxIrq1KL8uOLSnNS
	iw8xSnOwKInzNnukBAgJpCeWpGanphakFsFkmTg4pRoYl8460fbi/jyJ0mlxV+z+HmJr2zHr
	sLNB2sayiyv9n4iWTn3fY5QsUuH6u1b0uNzuc4I/a72U/0ofTWHLeTB5T6G3C4d8Ga9Mh9Au
	xu6HS57s+aw9XUlyftikDHO7j7s+y5zOCNqX/2glw6QPN9ZwnEqWTDu/aPLECM8nkp79nB8b
	j0pfOWBwU4mlOCPRUIu5qDgRALpT6jl3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
ERROR: do not initialise statics to 0 or NULL
ERROR: code indent should use tabs where possible

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/hp680_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 38aa002..191fbed 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -26,7 +26,7 @@
 #define HP680_DEFAULT_INTENSITY 10
 
 static int hp680bl_suspended;
-static int current_intensity = 0;
+static int current_intensity;
 static DEFINE_SPINLOCK(bl_lock);
 
 static void hp680bl_send_intensity(struct backlight_device *bd)
@@ -168,7 +168,7 @@ static int __init hp680bl_init(void)
 static void __exit hp680bl_exit(void)
 {
 	platform_device_unregister(hp680bl_device);
- 	platform_driver_unregister(&hp680bl_driver);
+	platform_driver_unregister(&hp680bl_driver);
 }
 
 module_init(hp680bl_init);
-- 
1.7.1


