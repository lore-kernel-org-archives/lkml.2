Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab0JBQic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab0JBQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OmTIUbL6hkSFQlH52BoBFhzCHWz++RZjXHWC9n4MMBvk+H4idGRRvRGJlrrtT6URPc
         VKcpqAoJk0YWT6/R9Esckt5bGA9f2+/KQv9RgyqwLi0xxMiyMeFqVZ0/qTuM2uTWVlx/
         yzbgcHoWZ2GKA5Otr+gzNECYQXrbINTDGVrgg=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 13/20] Staging: rtl8192u: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:02 -0400
Message-Id: <1286037489-28439-13-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192u/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
index 738f4a8..cba4344 100644
--- a/drivers/staging/rtl8192u/Makefile
+++ b/drivers/staging/rtl8192u/Makefile
@@ -1,16 +1,16 @@
 NIC_SELECT = RTL8192U
 
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
+ccflags-y := -std=gnu89
+ccflags-y += -O2
 
-EXTRA_CFLAGS += -DCONFIG_FORCE_HARD_FLOAT=y
-EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
-EXTRA_CFLAGS += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
-#EXTRA_CFLAGS += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
-#EXTRA_CFLAGS += -DUSB_RX_AGGREGATION_SUPPORT
-EXTRA_CFLAGS += -DUSE_ONE_PIPE
-EXTRA_CFLAGS += -DENABLE_DOT11D
-EXTRA_CFLAGS += -Idrivers/staging/rtl8192u/ieee80211
+ccflags-y += -DCONFIG_FORCE_HARD_FLOAT=y
+ccflags-y += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
+ccflags-y += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
+#ccflags-y += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
+#ccflags-y += -DUSB_RX_AGGREGATION_SUPPORT
+ccflags-y += -DUSE_ONE_PIPE
+ccflags-y += -DENABLE_DOT11D
+ccflags-y += -Idrivers/staging/rtl8192u/ieee80211
 
 r8192u_usb-objs := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
 		  r8190_rtl8256.o r819xU_phy.o r819xU_firmware.o	\
-- 
1.7.3.1.50.g1e633

