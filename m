Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0JBQia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56995 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab0JBQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HP4T4jL/bBwruhnEPVcwcmB/kHCHLNFxP/BanPjAvvN5sH9bnUgdRdL9GeA4hYjrai
         jthtKQ5vXVvfUuzSZo2FcAL3aPQ+vDjVg+E8/WL7wGyjpmFfZ83acQXDwCPcgCXN1dpd
         mg4pxYEpY9kkUCU5kITgktPy24YttQA7oBaJ4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 11/20] Staging: rtl8192su: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:00 -0400
Message-Id: <1286037489-28439-11-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192su/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192su/Makefile b/drivers/staging/rtl8192su/Makefile
index 7133894..1120c04 100644
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -1,12 +1,12 @@
 NIC_SELECT = RTL8192SU
 
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
+ccflags-y := -std=gnu89
+ccflags-y += -O2
 
-EXTRA_CFLAGS += -DJACKSON_NEW_RX
-EXTRA_CFLAGS += -DTHOMAS_BEACON
+ccflags-y += -DJACKSON_NEW_RX
+ccflags-y += -DTHOMAS_BEACON
 
-#EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
+#ccflags-y += -DMUTIPLE_BULK_OUT
 
 r8192s_usb-objs :=		\
 	r8192U_wx.o		\
-- 
1.7.3.1.50.g1e633

