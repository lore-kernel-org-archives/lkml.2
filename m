Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2BYOvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 09:51:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43450 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2BYOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 09:51:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of morbidrsa@googlemail.com designates 10.14.97.70 as permitted sender) smtp.mail=morbidrsa@googlemail.com; dkim=pass header.i=morbidrsa@googlemail.com
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: olof@lixom.net, cjb@laptop.org, vrao@broadcom.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] Staging: android: timed_gpio: Removed spaces before tabs
Date: Sat, 25 Feb 2012 15:51:13 +0100
Message-Id: <1330181473-16600-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/android/timed_gpio.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.h b/drivers/staging/android/timed_gpio.h
index a0e15f8..d29e169 100644
--- a/drivers/staging/android/timed_gpio.h
+++ b/drivers/staging/android/timed_gpio.h
@@ -20,13 +20,13 @@
 
 struct timed_gpio {
 	const char *name;
-	unsigned 	gpio;
+	unsigned	gpio;
 	int		max_timeout;
-	u8 		active_low;
+	u8		active_low;
 };
 
 struct timed_gpio_platform_data {
-	int 		num_gpios;
+	int		num_gpios;
 	struct timed_gpio *gpios;
 };
 
-- 
1.7.5.4

