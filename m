Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab1FWWs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:48:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24681 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab1FWWs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:48:57 -0400
Date: Fri, 24 Jun 2011 00:40:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andre Nogueira <andre.neo.net@gmail.com>, devel@driverdev.osuosl.org,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Mike McCormack <mikem@ring3k.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Julia Lawall <julia@diku.dk>,
        Joe Perches <joe@perches.com>, David Chosrova <dada2372@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 19/37] Remove unneeded version.h includes from
 drivers/staging/rtl*/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240036380.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/rtl8187se/,
drivers/staging/rtl8192e/, drivers/staging/rtl8192u/ &
drivers/staging/rtl8712/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    1 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    1 -
 drivers/staging/rtl8192e/r8192E.h                  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192u/r8192U.h                  |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    2 --
 27 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 16aa6a8..705c6cc 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index c8dbcb9..b3882ae 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 731d268..6aaaa2f 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index ee71ee9..da24e43 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index f790cd6..58f3eeb 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 9d58a42..9422573 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 736a140..f292478 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 
 #include "dot11d.h"
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211.h b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
index dbe21ab..a58519e 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
index ae50379..61fd4ce 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
index 9b8533f..48267a0 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
index b32b7e6..ed623a9 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
index e626472..5504391 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -9,7 +9,6 @@
  * more details.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 663b0b8..c1c294e 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -45,7 +45,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index ed5a380..022086d 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index 7d4cba3..45e3cc1 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 #ifdef ENABLE_DOT11D
 #include "dot11d.h"
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index 995346d..de2ed72 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192e/r8192E.h b/drivers/staging/rtl8192e/r8192E.h
index 0229031..0faa637 100644
--- a/drivers/staging/rtl8192e/r8192E.h
+++ b/drivers/staging/rtl8192e/r8192E.h
@@ -35,7 +35,6 @@
 #include <linux/proc_fs.h>	// Necessary because we use the proc fs
 #include <linux/if_arp.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include "ieee80211/rtl819x_HT.h"
 #include "ieee80211/ieee80211.h"
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index e716f7b..6f08e51 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -25,7 +25,6 @@
 #define IEEE80211_H
 #include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/kernel.h>   /* ARRAY_SIZE */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
index 8707eba..a464d11 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
@@ -12,7 +12,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
index 4b078e5..fec0176 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index a98584c..555eb80 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index 96c2c9d..3801f12 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -10,7 +10,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index fe978f3..50167b7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a414303..c9bdc7f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 4ec0a65..e9582bd 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -19,7 +19,6 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/uaccess.h>
 #include "dot11d.h"
 
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 0205079..9b81f26 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -37,7 +37,6 @@
 #include <linux/proc_fs.h>	// Necessary because we use the proc fs
 #include <linux/if_arp.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include "ieee80211/ieee80211.h"
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 3d3f73c..c2410bd 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -5,9 +5,7 @@
 #define _FAIL		0
 
 #include "basic_types.h"
-#include <linux/version.h>
 #include <linux/spinlock.h>
-
 #include <linux/semaphore.h>
 #include <linux/sem.h>
 #include <linux/netdevice.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

