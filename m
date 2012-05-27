Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2E0UXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:23:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2E0UXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:23:32 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Ben Chan <benchan@chromium.org>,
        Paul Stewart <pstew@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] [staging/gdm72xx]:  Remove version.h includes
Date: Mon, 28 May 2012 01:53:22 +0530
Message-Id: <1338150202-24542-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_qos.c   |    1 -
 drivers/staging/gdm72xx/gdm_sdio.c  |    1 -
 drivers/staging/gdm72xx/gdm_usb.c   |    1 -
 drivers/staging/gdm72xx/gdm_wimax.c |    1 -
 drivers/staging/gdm72xx/gdm_wimax.h |    1 -
 drivers/staging/gdm72xx/netlink_k.c |    1 -
 drivers/staging/gdm72xx/sdio_boot.c |    1 -
 drivers/staging/gdm72xx/usb_boot.c  |    1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 0217680..e7134e2 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/version.h>
 #include <linux/etherdevice.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index e1a3dd2..5e19b09 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 1e9dc0d..880f67d 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <asm/byteorder.h>
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index f1936b9..110bdbc 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/version.h>
 #include <linux/etherdevice.h>
 #include <asm/byteorder.h>
 #include <linux/ip.h>
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 023e649..6ec0ab4 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -15,7 +15,6 @@
 #define __GDM_WIMAX_H__
 
 #include <linux/netdevice.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include "wm_ioctl.h"
 #if defined(CONFIG_WIMAX_GDM72XX_QOS)
diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 292af0f..1c74b08 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/netlink.h>
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index 6ff4dc3..760efee 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 5a0e030..c163bcc 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -13,7 +13,6 @@
 
 #include <linux/uaccess.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/usb.h>
-- 
1.7.9.5

