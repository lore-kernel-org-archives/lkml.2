Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0C1UFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:05:34 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:52952 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0C1UFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:05:33 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQ5AA9Tr0tT4vnEPGdsb2JhbACHaJNADAEBAQE1La9SjHuFAQQ
X-IronPort-AV: E=Sophos;i="4.51,323,1267398000"; 
   d="scan'208";a="56735115"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wbusb_s.h Coding style fixes.
Date: Sun, 28 Mar 2010 22:05:32 +0200
Message-Id: <1269806732-15864-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed comments and some spacing.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wbusb_s.h |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
index 0c7e6a3..8961ae5 100644
--- a/drivers/staging/winbond/wbusb_s.h
+++ b/drivers/staging/winbond/wbusb_s.h
@@ -1,16 +1,10 @@
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-// Copyright (c) 1996-2004 Winbond Electronic Corporation
-//
-//  Module Name:
-//    wbusb_s.h
-//
-//  Abstract:
-//    Linux driver.
-//
-//  Author:
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
+/* =========================================================
+ * Copyright (c) 1996-2004 Winbond Electronic Corporation
+ *
+ *  Module Name:
+ *    wbusb_s.h
+ * =========================================================
+ */
 #ifndef __WINBOND_WBUSB_S_H
 #define __WINBOND_WBUSB_S_H
 
@@ -18,8 +12,7 @@
 
 struct wb_usb {
 	u32	IsUsb20;
-	struct usb_device *udev;
+	struct	usb_device *udev;
 	u32	DetectCount;
 };
-
 #endif
-- 
1.7.0.3

