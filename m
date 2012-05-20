Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2ETJym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 05:54:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40767 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2ETJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 05:54:41 -0400
From: Nasir Abed <nasirabed@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        swetland@google.com, Nasir Abed <nasirabed+kernel@gmail.com>
Subject: [PATCH] Staging: android: alarm: fixed quoted string split across lines
Date: Sun, 20 May 2012 11:54:19 +0200
Message-Id: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a warning quoted string split across lines.

Signed-off-by: Nasir Abed <nasirabed+kernel@gmail.com>
---
 drivers/staging/android/alarm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
index c68950b..4ea07bb 100644
--- a/drivers/staging/android/alarm.c
+++ b/drivers/staging/android/alarm.c
@@ -302,8 +302,8 @@ int android_alarm_set_rtc(struct timespec new_time)
 	}
 	ret = rtc_set_time(alarm_rtc_dev, &rtc_new_rtc_time);
 	if (ret < 0)
-		pr_alarm(ERROR, "alarm_set_rtc: "
-			"Failed to set RTC, time will be lost on reboot\n");
+		pr_alarm(ERROR,
+			 "alarm_set_rtc: Failed to set RTC, time will be lost on reboot\n");
 err:
 	wake_unlock(&alarm_rtc_wake_lock);
 	mutex_unlock(&alarm_setrtc_mutex);
-- 
1.7.9.5

