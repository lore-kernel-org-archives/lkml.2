Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1EFKyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:45 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45007
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab1EFKym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:42 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 16/16] staging: usbip: fixup MODULE_ macros
Date: Fri,  6 May 2011 03:47:56 -0700
Message-Id: <bc543454026b89f47b088b0e6fb7cf04ba6183a1.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify description and email address for usbip_common_mod; export
module version number; and modify __init messages slightly.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_main.c    |    4 ++--
 drivers/staging/usbip/usbip_common.c |   11 ++++++-----
 drivers/staging/usbip/vhci_hcd.c     |    4 ++--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 6634e07..c139f0e 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -22,7 +22,6 @@
 #include "usbip_common.h"
 #include "stub.h"
 
-/* Version Information */
 #define DRIVER_VERSION "1.0"
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
 #define DRIVER_DESC "Stub Driver for USB/IP"
@@ -279,7 +278,7 @@ static int __init usb_stub_init(void)
 		goto error_usb_register;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ":" DRIVER_DESC ":" DRIVER_VERSION
+	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC " " DRIVER_VERSION
 	       "\n");
 
 	init_busid_table();
@@ -320,3 +319,4 @@ module_exit(usb_stub_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 5d842f9..b46e9b5 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -23,13 +23,12 @@
 #include <linux/in.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
+
 #include "usbip_common.h"
 
-/* version information */
 #define DRIVER_VERSION "1.0"
-#define DRIVER_AUTHOR \
-	"Takahiro Hirofuchi <hirofuchi _at_ users.sourceforge.net>"
-#define DRIVER_DESC "usbip common driver"
+#define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>"
+#define DRIVER_DESC "USB/IP Common Driver"
 
 #ifdef CONFIG_USB_IP_DEBUG_ENABLE
 unsigned long usbip_debug_flag = 0xffffffff;
@@ -862,7 +861,8 @@ EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
 
 static int __init usbip_common_init(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "" DRIVER_VERSION);
+	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC " " DRIVER_VERSION
+	       "\n");
 	return 0;
 }
 
@@ -877,3 +877,4 @@ module_exit(usbip_common_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index da5e73a..5a07431 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -26,7 +26,6 @@
 #define DRIVER_VERSION "1.0"
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
 #define DRIVER_DESC "Virtual Host Controller Interface Driver for USB/IP"
-#define DRIVER_LICENCE "GPL"
 
 /*
  * TODO
@@ -1268,4 +1267,5 @@ module_exit(vhci_cleanup);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE(DRIVER_LICENCE);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
-- 
1.7.5.1

