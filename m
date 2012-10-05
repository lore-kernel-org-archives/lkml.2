Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2JEWKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:10:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52116 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2JEWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:09:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] USB: usb.h: remove dbg() macro
Date: Fri,  5 Oct 2012 15:09:38 -0700
Message-Id: <1349474978-869-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users of this macro anymore in the kernel tree, so finally
delete it.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index 07915a3..10278d1 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1778,17 +1778,6 @@ static inline int usb_translate_errors(int error_code)
 extern void usb_register_notify(struct notifier_block *nb);
 extern void usb_unregister_notify(struct notifier_block *nb);
 
-#ifdef DEBUG
-#define dbg(format, arg...)						\
-	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
-#else
-#define dbg(format, arg...)						\
-do {									\
-	if (0)								\
-		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg); \
-} while (0)
-#endif
-
 /* debugfs stuff */
 extern struct dentry *usb_debug_root;
 
-- 
1.7.12.2.421.g261b511

