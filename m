Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0KFVBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 17:01:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40250 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0KFVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 17:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZvMtFWH9MORafzgMmA1HlC44Y7gQqd8H6b672uv5V8DA0muEXU+vTtawbDjaF4yqYl
         uNOuk+5ztR5CMNyL219N6wyNiOTtk3bNWN9jwojundABw9YLgDZ1cAyZRCCZeyLZQvWj
         ubflj99gyXPfZ+If6KNEPT8W9EWDRdudc80+Y=
From: Tracey Dent <tdent48227@gmail.com>
To: dan.j.williams@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, linus.walleij@stericsson.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] drivers/dma/: Use the ccflag-y instead of EXTRA_CFLAGS
Date: Sat,  6 Nov 2010 17:01:36 -0400
Message-Id: <1289077297-1444-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.161.g3089c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ccflag-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/dma/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index a8a84f4..64b21f5 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,8 +1,8 @@
 ifeq ($(CONFIG_DMADEVICES_DEBUG),y)
-	EXTRA_CFLAGS	+= -DDEBUG
+	ccflags-y	+= -DDEBUG
 endif
 ifeq ($(CONFIG_DMADEVICES_VDEBUG),y)
-	EXTRA_CFLAGS	+= -DVERBOSE_DEBUG
+	ccflags-y	+= -DVERBOSE_DEBUG
 endif
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
-- 
1.7.3.1.104.gc752e

