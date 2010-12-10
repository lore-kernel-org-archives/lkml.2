Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0LJKVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0LJKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:21:23 -0500
Subject: [GIT PATCH] Updated email contact details for ads7828 driver
From: Steven Hardy <shardy@redhat.com>
To: khali@linux-fr.org, lm-sensors@lm-sensors.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 10:20:16 +0000
Message-ID: <1291976416.3237.29.camel@shardy.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Trivial patch updating my email contact details due to change of
employer, and because I no longer have access to the previously used
domain.

Unfortunately I also no longer have access to any ads7828 hardware, but
am happy to support/maintain the driver if others are able to test
changes.

Thanks, 

Steve

Signed-off-by: Steve Hardy <shardy@redhat.com>

>From 3c72783100922347afe4abf2de244997b4e54c16 Mon Sep 17 00:00:00 2001
From: Steve Hardy <shardy@redhat.com>
Date: Fri, 10 Dec 2010 09:38:06 +0000
Subject: [PATCH] Updated email contact details for ads7828 driver

---
 Documentation/hwmon/ads7828 |    2 +-
 drivers/hwmon/ads7828.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/ads7828 b/Documentation/hwmon/ads7828
index 75bc4be..2bbebe6 100644
--- a/Documentation/hwmon/ads7828
+++ b/Documentation/hwmon/ads7828
@@ -9,7 +9,7 @@ Supported chips:
                http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
 Authors:
-        Steve Hardy <steve@linuxrealtime.co.uk>
+        Steve Hardy <shardy@redhat.com>
 
 Module Parameters
 -----------------
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index aac85f3..c42c5a6 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -4,7 +4,7 @@
 
 	This driver is based on the lm75 and other lm_sensors/hwmon drivers
 
-	Written by Steve Hardy <steve@linuxrealtime.co.uk>
+	Written by Steve Hardy <shardy@redhat.com>
 
 	Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
@@ -271,7 +271,7 @@ static void __exit sensors_ads7828_exit(void)
 	i2c_del_driver(&ads7828_driver);
 }
 
-MODULE_AUTHOR("Steve Hardy <steve@linuxrealtime.co.uk>");
+MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
 MODULE_DESCRIPTION("ADS7828 driver");
 MODULE_LICENSE("GPL");
 
-- 
1.7.1



