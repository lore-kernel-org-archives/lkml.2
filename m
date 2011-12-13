Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1LMGvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:51:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35674 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1LMGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:51:08 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: gregkh@suse.de, Larry.Finger@lwfinger.net, seanm@seanm.ca, thomas@m3y3r.de,
        jj@chaosbits.net, mikem@ring3k.org, imirkin@alum.mit.edu,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/1] remove version.h includes in rtl8192e
Date: Tue, 13 Dec 2011 01:49:29 -0500
Message-Id: <1323758969-13539-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h |    1 -
 drivers/staging/rtl8192e/rtllib.h            |    1 -
 drivers/staging/rtl8192e/rtllib_crypt.c      |    1 -
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c |    1 -
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c |    1 -
 drivers/staging/rtl8192e/rtllib_crypt_wep.c  |    1 -
 drivers/staging/rtl8192e/rtllib_module.c     |    1 -
 drivers/staging/rtl8192e/rtllib_rx.c         |    1 -
 drivers/staging/rtl8192e/rtllib_softmac.c    |    1 -
 drivers/staging/rtl8192e/rtllib_tx.c         |    1 -
 drivers/staging/rtl8192e/rtllib_wx.c         |    1 -
 11 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index 93478df..2a2519c 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -44,7 +44,6 @@
 #include <linux/proc_fs.h>
 #include <linux/if_arp.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <linux/io.h>

 /* Need this defined before including local include files */
diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index a8cae9b..9a31935 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -25,7 +25,6 @@
 #define RTLLIB_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
diff --git a/drivers/staging/rtl8192e/rtllib_crypt.c b/drivers/staging/rtl8192e/rtllib_crypt.c
index 4665712..c6e2440 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt.c
@@ -11,7 +11,6 @@
  *
  */

-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
index 7b62ab2..0419c77 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
@@ -9,7 +9,6 @@
  * more details.
  */

-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 9dd4029..f68cda2 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -9,7 +9,6 @@
  * more details.
  */

-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_wep.c b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
index d06d15d..f5e11b4 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_wep.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
@@ -9,7 +9,6 @@
  * more details.
  */

-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index d5515df..c92ad9f 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -45,7 +45,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index b640c87..e662fd6 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 8565365..44b466b 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -18,7 +18,6 @@

 #include <linux/random.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/uaccess.h>
 #include "dot11d.h"

diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index eb3c472..b8135be 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
index c7f8d9c..5e81734 100644
--- a/drivers/staging/rtl8192e/rtllib_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_wx.c
@@ -30,7 +30,6 @@

 ******************************************************************************/
 #include <linux/wireless.h>
-#include <linux/version.h>
 #include <linux/kmod.h>
 #include <linux/module.h>

--
1.7.4.1
