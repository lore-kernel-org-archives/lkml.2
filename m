Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1J1MP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:15:56 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37479 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260Ab1J1MPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:15:54 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/abx500: fix missing abx500 header file updates
Date: Fri, 28 Oct 2011 14:15:35 +0200
Message-ID: <1319804135-2740-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

I missed to include a patch adding the new silicon revision define
CUT3P3 and remove the retired CUT0 versions of AB8500. Also delete
the reference to the retired AB3550 from the header.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/mfd/abx500.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 896b5e4..e953b63 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -6,7 +6,7 @@
  *
  * ABX500 core access functions.
  * The abx500 interface is used for the Analog Baseband chip
- * ab3100, ab3550, ab5500, and ab8500.
+ * AB3100, AB5500, and AB8500.
  *
  * Author: Mattias Wallin <mattias.wallin@stericsson.com>
  * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
@@ -35,11 +35,11 @@
 #define AB5500_2_1	0x22
 
 /* AB8500 CIDs*/
-#define AB8500_CUTEARLY	0x00
 #define AB8500_CUT1P0	0x10
 #define AB8500_CUT1P1	0x11
 #define AB8500_CUT2P0	0x20
 #define AB8500_CUT3P0	0x30
+#define AB8500_CUT3P3	0x33
 
 /*
  * AB3100, EVENTA1, A2 and A3 event register flags
-- 
1.7.3.2

