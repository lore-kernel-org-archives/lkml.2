Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2JRTwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:52:02 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:19552 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2JRTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:52:00 -0400
Date: Thu, 18 Oct 2012 21:51:56 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Priit Laes <plaes@plaes.org>, Devendra Naga <develkernel412222@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: csr: remove a number of unneeded includes of
 version.h
Message-ID: <alpine.LNX.2.00.1210182150020.17217@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/csr/csr_framework_ext.c    |    1 -
 drivers/staging/csr/csr_time.c             |    1 -
 drivers/staging/csr/io.c                   |    1 -
 drivers/staging/csr/monitor.c              |    1 -
 drivers/staging/csr/netdev.c               |    1 -
 drivers/staging/csr/sdio_mmc.c             |    1 -
 drivers/staging/csr/sme_native.c           |    1 -
 drivers/staging/csr/sme_sys.c              |    1 -
 drivers/staging/csr/ul_int.c               |    1 -
 drivers/staging/csr/unifi_pdu_processing.c |    1 -
 drivers/staging/csr/unifi_priv.h           |    1 -
 drivers/staging/csr/unifi_wext.h           |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.c b/drivers/staging/csr/csr_framework_ext.c
index f91a4bf..e203f60 100644
--- a/drivers/staging/csr/csr_framework_ext.c
+++ b/drivers/staging/csr/csr_framework_ext.c
@@ -9,7 +9,6 @@
 *****************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/freezer.h>
diff --git a/drivers/staging/csr/csr_time.c b/drivers/staging/csr/csr_time.c
index 7b597f7..f4ff98c 100644
--- a/drivers/staging/csr/csr_time.c
+++ b/drivers/staging/csr/csr_time.c
@@ -9,7 +9,6 @@
 *****************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/time.h>
 #include <linux/module.h>
 
diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index caf48e3..5206cba 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -31,7 +31,6 @@
  * ---------------------------------------------------------------------------
  */
 #include <linux/proc_fs.h>
-#include <linux/version.h>
 
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_unifiversion.h"
diff --git a/drivers/staging/csr/monitor.c b/drivers/staging/csr/monitor.c
index 7c524a1..7b76f07 100644
--- a/drivers/staging/csr/monitor.c
+++ b/drivers/staging/csr/monitor.c
@@ -10,7 +10,6 @@
  * ---------------------------------------------------------------------------
  */
 
-#include <linux/version.h>
 #include "unifi_priv.h"
 
 #ifdef UNIFI_SNIFF_ARPHRD
diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 9a52ab4..8a53171 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -47,7 +47,6 @@
 #include <linux/etherdevice.h>
 #include <linux/mutex.h>
 #include <linux/semaphore.h>
-#include <linux/version.h>
 #include <linux/vmalloc.h>
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
diff --git a/drivers/staging/csr/sdio_mmc.c b/drivers/staging/csr/sdio_mmc.c
index af3e40b..6b96df1 100644
--- a/drivers/staging/csr/sdio_mmc.c
+++ b/drivers/staging/csr/sdio_mmc.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
-#include <linux/version.h>
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/staging/csr/sme_native.c b/drivers/staging/csr/sme_native.c
index d7a5125..26f10bc 100644
--- a/drivers/staging/csr/sme_native.c
+++ b/drivers/staging/csr/sme_native.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/netdevice.h>
-#include <linux/version.h>
 #include "unifi_priv.h"
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 5b26c41..90a30dc 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -14,7 +14,6 @@
  * ---------------------------------------------------------------------------
  */
 
-#include <linux/version.h>
 #include "csr_wifi_hip_unifiversion.h"
 #include "unifi_priv.h"
 #include "csr_wifi_hip_conversions.h"
diff --git a/drivers/staging/csr/ul_int.c b/drivers/staging/csr/ul_int.c
index 4013d02..0fae6f4 100644
--- a/drivers/staging/csr/ul_int.c
+++ b/drivers/staging/csr/ul_int.c
@@ -12,7 +12,6 @@
  *
  * ***************************************************************************
  */
-#include <linux/version.h>
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
 #include "unifi_priv.h"
diff --git a/drivers/staging/csr/unifi_pdu_processing.c b/drivers/staging/csr/unifi_pdu_processing.c
index ae7c8fc..a762939 100644
--- a/drivers/staging/csr/unifi_pdu_processing.c
+++ b/drivers/staging/csr/unifi_pdu_processing.c
@@ -14,7 +14,6 @@
  * ---------------------------------------------------------------------------
  */
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index aec8e28..f25b92a 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -17,7 +17,6 @@
 #ifndef __LINUX_UNIFI_PRIV_H__
 #define __LINUX_UNIFI_PRIV_H__ 1
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff --git a/drivers/staging/csr/unifi_wext.h b/drivers/staging/csr/unifi_wext.h
index 6834c43..beba089 100644
--- a/drivers/staging/csr/unifi_wext.h
+++ b/drivers/staging/csr/unifi_wext.h
@@ -16,7 +16,6 @@
 #define __LINUX_UNIFI_WEXT_H__ 1
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <net/iw_handler.h>
 #include "csr_wifi_sme_prim.h"
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

