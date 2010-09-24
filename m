Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0IXXcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:32:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab0IXX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JxlrGruEiXAO3qznwE2yV5sUWR/MJ4PFboXWhO7PfQWmGUsfFwAMe2edlhcYZb4dVt
         y6EWdeYu4mK2peca4hFQiQGH6OkR1mZcy1IeIKdIzFxcCTlPEMq8+PpPQds2t/Ju+ELc
         38yykTgJzvSZ/zLXo3Nj/ZIRrbxSJNJ1QXtNY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 08/22] Staging: otus: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:56 -0400
Message-Id: <1285370890-8984-8-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/otus/Makefile |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/otus/Makefile b/drivers/staging/otus/Makefile
index debcc5c..c4d979d 100644
--- a/drivers/staging/otus/Makefile
+++ b/drivers/staging/otus/Makefile
@@ -1,25 +1,25 @@
 obj-$(CONFIG_OTUS)	+= arusb_lnx.o
 
-EXTRA_CFLAGS += -DAMAC
-EXTRA_CFLAGS += -DGCCK
-EXTRA_CFLAGS += -DOFDM
-EXTRA_CFLAGS += -DTXQ_IN_ISR
-EXTRA_CFLAGS += -DWLAN_HOSTIF=0 #0:USB, 1:PCI
+ccflags-y := -DAMAC
+ccflags-y := -DGCCK
+ccflags-y := -DOFDM
+ccflags-y := -DTXQ_IN_ISR
+ccflags-y := -DWLAN_HOSTIF=0 #0:USB, 1:PCI
 
 #Test Mode
-EXTRA_CFLAGS += -DZM_USB_STREAM_MODE=1
-EXTRA_CFLAGS += -DZM_USB_TX_STREAM_MODE=0
-EXTRA_CFLAGS += -DZM_PCI_DMA_TEST=0
-EXTRA_CFLAGS += -DZM_LARGEPAYLOAD_TEST=0
-EXTRA_CFLAGS += -DZM_FW_LOOP_BACK=0
-EXTRA_CFLAGS += -DZM_LINUX_TPC=1
-#EXTRA_CFLAGS += -DZM_DONT_COPY_RX_BUFFER
+ccflags-y := -DZM_USB_STREAM_MODE=1
+ccflags-y := -DZM_USB_TX_STREAM_MODE=0
+ccflags-y := -DZM_PCI_DMA_TEST=0
+ccflags-y := -DZM_LARGEPAYLOAD_TEST=0
+ccflags-y := -DZM_FW_LOOP_BACK=0
+ccflags-y := -DZM_LINUX_TPC=1
+#ccflags-y := -DZM_DONT_COPY_RX_BUFFER
 
-EXTRA_CFLAGS += -DZM_HOSTAPD_SUPPORT
-#EXTRA_CFLAGS += -DfTX_GAIN_OFDM=0
-#EXTRA_CFLAGS += -DZM_CONFIG_BIG_ENDIAN -DBIG_ENDIAN
-EXTRA_CFLAGS += -DZM_HALPLUS_LOCK
-EXTRA_CFLAGS += -DZM_OTUS_LINUX_PHASE_2
+ccflags-y := -DZM_HOSTAPD_SUPPORT
+ccflags-y := -DfTX_GAIN_OFDM=0
+ccflags-y := -DZM_CONFIG_BIG_ENDIAN -DBIG_ENDIAN
+ccflags-y := -DZM_HALPLUS_LOCK
+ccflags-y := -DZM_OTUS_LINUX_PHASE_2
 
 arusb_lnx-objs := \
 	usbdrv.o \
-- 
1.7.3

