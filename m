Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0KFTDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:03:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58097 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0KFTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hjwjdRZfJ+GIoc0hneI2ORhWM5a5ZToeFlw+skbcmCQWYMesJ2B9hNClQVxgL0L831
         VMQaHGPkicWh3t3x41oZ988cXQmpE/KuWlDJdf49w8HyLxKTrFsc0M3aRBhrIPjO0BhS
         YKd+/Ci++q1S7JA+cXn2rm0BBCEuZs+Hh1hZY=
From: Tracey Dent <tdent48227@gmail.com>
To: dan.j.williams@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, agust@denx.de, linus.walleij@stericsson.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] Drivers: dma: Makefile: Cleaned up Makefile
Date: Sat,  6 Nov 2010 15:03:36 -0400
Message-Id: <1289070217-2513-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ccflag-y instead of EXTRA_CFLAGS.

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

