Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0IXSTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:19:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49879 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0IXSS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IO9VdFkwUpyHMHp0+a0cjVBMgj/FfSCkROUpy73wayg1TOrG8YAPVTcdjtjRlt5vs9
         E/v2vxE72pdTSAG3rHqxsx26gb9CvksZ65Wi1Fk3RrCDtZWZFptGOCD/CMtOHgeD8Om7
         82jCP6kqtkkOV2DbmCE1K2I9TM/aTO7hiOGOs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 11/21] Staging: rtl8192e: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:24 -0400
Message-Id: <1285352314-5939-11-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192e/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192e/Makefile b/drivers/staging/rtl8192e/Makefile
index 41cb4d3..0bad423 100644
--- a/drivers/staging/rtl8192e/Makefile
+++ b/drivers/staging/rtl8192e/Makefile
@@ -1,13 +1,13 @@
 NIC_SELECT = RTL8192E
 
-EXTRA_CFLAGS += -DRTL8192E
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DTHOMAS_TURBO
-EXTRA_CFLAGS += -DENABLE_DOT11D
+ccflags-y += -DRTL8192E
+ccflags-y += -std=gnu89
+ccflags-y += -O2
+ccflags-y += -DTHOMAS_TURBO
+ccflags-y += -DENABLE_DOT11D
 
-EXTRA_CFLAGS += -DENABLE_IPS
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y += -DENABLE_IPS
+ccflags-y += -DENABLE_LPS
 
 r8192e_pci-objs :=		\
 	r8192E_core.o		\
-- 
1.7.3

