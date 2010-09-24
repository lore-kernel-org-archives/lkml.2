Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0IXXbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:31:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55484 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab0IXX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LbYIkFnYxncLzHiwTvb6FUS95vLXhMXgSSwXE33Mp0cy/JRsBW+7pKsKqWysBS+MSB
         5BACadMlMHVgCxIE0wJ2gZC7cR3Gfq8azMYhdntEzaj4BplHacTCfUuCUC1yg8Hf84G8
         tDSlihq+bD64DIcTU6Kj5KOSfedGhnDlJ9JaY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 13/22] Staging: rtl8192su: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:01 -0400
Message-Id: <1285370890-8984-13-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192su/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192su/Makefile b/drivers/staging/rtl8192su/Makefile
index 7133894..88bcd97 100644
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -1,12 +1,12 @@
 NIC_SELECT = RTL8192SU
 
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
+ccflags-y := -std=gnu89
+ccflags-y := -O2
 
-EXTRA_CFLAGS += -DJACKSON_NEW_RX
-EXTRA_CFLAGS += -DTHOMAS_BEACON
+ccflags-y := -DJACKSON_NEW_RX
+ccflags-y := -DTHOMAS_BEACON
 
-#EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
+#ccflags-y := -DMUTIPLE_BULK_OUT
 
 r8192s_usb-objs :=		\
 	r8192U_wx.o		\
-- 
1.7.3

