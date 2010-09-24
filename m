Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0IXSVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:21:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51072 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab0IXSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FmJ9gIdEIVdJGb3BizgFQ0X6sefU2AHmwirdHJcIc7X4gyBwUZ8dt9irp5OU1JsfeU
         ROdhbE25398o3MDjmrGdeuSVHdX5KQmFzpA84r4xmRUWGRxH37MldB73H7MpbmWedCMN
         c+y77EXkLfPKr6/qu6aohzDyA2zcLUC4PS3P8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 12/21] Staging: rtl8192su: Makefile: cleaaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:25 -0400
Message-Id: <1285352314-5939-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192su/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192su/Makefile b/drivers/staging/rtl8192su/Makefile
index 7133894..cce7fed 100644
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -1,12 +1,12 @@
 NIC_SELECT = RTL8192SU
 
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
+ccflags-y += -std=gnu89
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
1.7.3

