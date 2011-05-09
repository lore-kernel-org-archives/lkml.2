Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1EIIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:52:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49703 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1EIIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:52:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] MFD: twl4030-codec: Update e-mail address
Date: Mon, 9 May 2011 11:52:11 +0300
Message-ID: <1304931131-2825-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-codec.c       |    3 ++-
 include/linux/mfd/twl4030-codec.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index c02fded..3641a6f 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -2,6 +2,7 @@
  * MFD driver for twl4030 codec submodule
  *
  * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ * Contact:	Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * Copyright:   (C) 2009 Nokia Corporation
  *
@@ -270,6 +271,6 @@ static void __devexit twl4030_codec_exit(void)
 }
 module_exit(twl4030_codec_exit);
 
-MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@nokia.com>");
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
 MODULE_LICENSE("GPL");
 
diff --git a/include/linux/mfd/twl4030-codec.h b/include/linux/mfd/twl4030-codec.h
index 2ec317c..89a6820 100644
--- a/include/linux/mfd/twl4030-codec.h
+++ b/include/linux/mfd/twl4030-codec.h
@@ -2,6 +2,7 @@
  * MFD driver for twl4030 codec submodule
  *
  * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ * Contact:	Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * Copyright:   (C) 2009 Nokia Corporation
  *
-- 
1.7.5.rc3

