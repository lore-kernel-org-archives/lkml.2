Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2KKMwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:52:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2KKMwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:52:47 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 2/3] staging: line6: drop unused DEBUG_MESSAGES() macro
Date: Sun, 11 Nov 2012 13:52:25 +0100
Message-Id: <1352638346-32273-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
References: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEBUG_MESSAGES() macro is no longer needed since dev_dbg() is now
used for debug messages.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 35246cf..9dd8ff4 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -52,12 +52,6 @@
 
 #define LINE6_CHANNEL_MASK 0x0f
 
-#ifdef CONFIG_LINE6_USB_DEBUG
-#define DEBUG_MESSAGES(x) (x)
-#else
-#define DEBUG_MESSAGES(x)
-#endif
-
 #define MISSING_CASE	\
 	printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \
 		__FILE__, __LINE__)
-- 
1.7.12.1

