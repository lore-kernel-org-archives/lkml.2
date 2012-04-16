Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2DPP0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:26:37 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42190 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2DPP0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:26:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: Fix typo within android drivers.
Date: Tue, 17 Apr 2012 00:26:29 +0900
Message-Id: <1334589989-24090-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.130.g36e6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in comments within android drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/android/alarm-dev.c     |    2 +-
 drivers/staging/android/alarm.c         |    4 ++--
 drivers/staging/android/android_alarm.h |    2 +-
 drivers/staging/android/binder.h        |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 03efb34..1b618f3 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -54,7 +54,7 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 	ANDROID_ALARM_RTC_WAKEUP_MASK | \
 	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK)
 
-/* support old usespace code */
+/* support old userspace code */
 #define ANDROID_ALARM_SET_OLD               _IOW('a', 2, time_t) /* set alarm */
 #define ANDROID_ALARM_SET_AND_WAIT_OLD      _IOW('a', 3, time_t)
 
diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
index c68950b..d42a592 100644
--- a/drivers/staging/android/alarm.c
+++ b/drivers/staging/android/alarm.c
@@ -57,7 +57,7 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 	ANDROID_ALARM_RTC_WAKEUP_MASK | \
 	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK)
 
-/* support old usespace code */
+/* support old userspace code */
 #define ANDROID_ALARM_SET_OLD               _IOW('a', 2, time_t) /* set alarm */
 #define ANDROID_ALARM_SET_AND_WAIT_OLD      _IOW('a', 3, time_t)
 
@@ -543,7 +543,7 @@ static int __init alarm_late_init(void)
 
 	/* this needs to run after the rtc is read at boot */
 	spin_lock_irqsave(&alarm_slock, flags);
-	/* We read the current rtc and system time so we can later calulate
+	/* We read the current rtc and system time so we can later calculate
 	 * elasped realtime to be (boot_systemtime + rtc - boot_rtc) ==
 	 * (rtc - (boot_rtc - boot_systemtime))
 	 */
diff --git a/drivers/staging/android/android_alarm.h b/drivers/staging/android/android_alarm.h
index 6eecbde..e586cae 100644
--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -41,7 +41,7 @@ enum android_alarm_type {
 /*
  * The alarm interface is similar to the hrtimer interface but adds support
  * for wakeup from suspend. It also adds an elapsed realtime clock that can
- * be used for periodic timers that need to keep runing while the system is
+ * be used for periodic timers that need to keep running while the system is
  * suspended and not be disrupted when the wall time is set.
  */
 
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 25ab6f2..6602474 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -63,7 +63,7 @@ struct flat_binder_object {
 
 /*
  * On 64-bit platforms where user code may run in 32-bits the driver must
- * translate the buffer (and local binder) addresses apropriately.
+ * translate the buffer (and local binder) addresses appropriately.
  */
 
 struct binder_write_read {
-- 
1.7.10.130.g36e6c

