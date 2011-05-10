Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1EJF7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:59:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39113 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1EJF7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:59:35 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2] MFD: twl4030-codec: Update e-mail address
Date: Tue, 10 May 2011 08:59:23 +0300
Message-ID: <1305007163-5931-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hello,

Instead of keeping the old Nokia mail address, just change it to my new
email address in the author line.

 drivers/mfd/twl4030-codec.c       |    4 ++--
 include/linux/mfd/twl4030-codec.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index c02fded..534cc2e 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -1,7 +1,7 @@
 /*
  * MFD driver for twl4030 codec submodule
  *
- * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * Copyright:   (C) 2009 Nokia Corporation
  *
@@ -270,6 +270,6 @@ static void __devexit twl4030_codec_exit(void)
 }
 module_exit(twl4030_codec_exit);
 
-MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@nokia.com>");
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
 MODULE_LICENSE("GPL");
 
diff --git a/include/linux/mfd/twl4030-codec.h b/include/linux/mfd/twl4030-codec.h
index 2ec317c..5cc16bb 100644
--- a/include/linux/mfd/twl4030-codec.h
+++ b/include/linux/mfd/twl4030-codec.h
@@ -1,7 +1,7 @@
 /*
  * MFD driver for twl4030 codec submodule
  *
- * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * Copyright:   (C) 2009 Nokia Corporation
  *
-- 
1.7.5.rc3

