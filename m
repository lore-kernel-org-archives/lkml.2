Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2AWC3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:29:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2AWC3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:29:03 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, swetland@google.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 3/3] drivers/staging/android/timed_gpio.c: Stlye fixes
Date: Sun, 22 Jan 2012 21:28:46 -0500
Message-Id: <1327285726-1949-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <1327285726-1949-1-git-send-email-tdent48227@gmail.com>
References: <1327285726-1949-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just made it more neat and not bother scripts/checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/android/timed_gpio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index a64481c..bc723ef 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -29,9 +29,9 @@ struct timed_gpio_data {
 	struct timed_output_dev dev;
 	struct hrtimer timer;
 	spinlock_t lock;
-	unsigned 	gpio;
-	int 		max_timeout;
-	u8 		active_low;
+	unsigned gpio;
+	int max_timeout;
+	u8 active_low;
 };
 
 static enum hrtimer_restart gpio_timer_func(struct hrtimer *timer)
-- 
1.7.9.rc2

