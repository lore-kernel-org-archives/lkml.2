Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab0IXBbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:31:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43024 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0IXBbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YkmkEavgF7KXUU0XYGx15nWSpWqPs5VRiLS+xygUecwYV2wZ4k/oyZB9UgHid8ZBr7
         GzRJ8OcQyNOmieLaNpJ83NrUW17Xk/2ehKxKI/3AXAIoPOrKjjRCIC+QTBkBewGd8kc2
         WTYdIomiDA4Z/V+T34efvl9MCMid7K0d6lrDE=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Staging: rtl8187se: Makefile: cleaned up makefile cflag lines
Date: Thu, 23 Sep 2010 21:31:45 -0400
Message-Id: <1285291905-3739-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index e6adf91..3c143e3 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -1,20 +1,20 @@
 
-#EXTRA_CFLAGS += -DCONFIG_IEEE80211_NOWEP=y
-#EXTRA_CFLAGS += -std=gnu89
-#EXTRA_CFLAGS += -O2
+#ccflags-y +=  -DCONFIG_IEEE80211_NOWEP=y
+#ccflags-y += -std=gnu89
+#ccflags-y +=  -O2
 #CC            = gcc
 
-EXTRA_CFLAGS += -DSW_ANTE
-EXTRA_CFLAGS += -DTX_TRACK
-EXTRA_CFLAGS += -DHIGH_POWER
-EXTRA_CFLAGS += -DSW_DIG
-EXTRA_CFLAGS += -DRATE_ADAPT
+ccflags-y += -DSW_ANTE
+ccflags-y += -DTX_TRACK
+ccflags-y +=  -DHIGH_POWER
+ccflags-y += -DSW_DIG
+ccflags-y += -DRATE_ADAPT
 
 #enable it for legacy power save, disable it for leisure  power save
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y +=  -DENABLE_LPS
 
 
-#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
+#ccflags-y +=  -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
 r8187se-objs :=			\
 		r8180_core.o		\
-- 
1.7.3

