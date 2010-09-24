Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0IXSVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:21:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51363 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0IXSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D9to4Qcb+1yovLygk0GqGZp6beal7WFRYaPPYTJwqxRn4g5qQsj2ud+8YujULHkXIi
         KL2fbqXrcGo96ezQj3X6DBqJbv08gewQ+MrEU0C6Q7IlLWcYD/ZRpsw0RioBYFdyVO3m
         MCrCa0B1MLaVlHKvVTxYnOVOn1qYPFtbHZQ1Q=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 10/21] Staging: rt2870: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:23 -0400
Message-Id: <1285352314-5939-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rt2870/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rt2870/Makefile b/drivers/staging/rt2870/Makefile
index 523e7e7..f6e542a 100644
--- a/drivers/staging/rt2870/Makefile
+++ b/drivers/staging/rt2870/Makefile
@@ -2,10 +2,10 @@
 obj-$(CONFIG_RT2870)	+= rt2870sta.o
 
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
-EXTRA_CFLAGS += -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRT2870 -DRTMP_TIMER_TASK_SUPPORT
-EXTRA_CFLAGS += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3070
-EXTRA_CFLAGS += -DDBG
+ccflags-y += -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
+ccflags-y += -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRT2870 -DRTMP_TIMER_TASK_SUPPORT
+ccflags-y += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3070
+ccflags-y += -DDBG
 
 rt2870sta-objs :=		\
 	common/crypt_md5.o	\
-- 
1.7.3

