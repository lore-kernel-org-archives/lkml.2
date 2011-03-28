Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab1C1Qds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:33:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab1C1QaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qPrTXrlNx0mZbgCgABrx+2QBi68hVBhGvhU369ockIkdw9FiawlX5uc2vaFwqTtlic
         +aVpXHpqFTj8MjcLZo/350mpKVnLtj2IVPSrmgHwk41jHTrkEuB6UEOFVACgmSZaWyET
         +Ebl1Olou1/7pQ9K4LlugUsFoD+hiTa8wsgI4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 12/25]drivers:net Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:35 -0700
Message-Id: <1301329788-3423-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/atl1c/atl1c.h              |    1 -
 drivers/net/atl1e/atl1e.h              |    1 -
 drivers/net/benet/be.h                 |    1 -
 drivers/net/bna/cna.h                  |    1 -
 drivers/net/caif/caif_serial.c         |    1 -
 drivers/net/caif/caif_shm_u5500.c      |    1 -
 drivers/net/caif/caif_spi.c            |    1 -
 drivers/net/caif/caif_spi_slave.c      |    1 -
 drivers/net/can/c_can/c_can.c          |    1 -
 drivers/net/can/c_can/c_can_platform.c |    1 -
 drivers/net/can/softing/softing_main.c |    1 -
 drivers/net/cxgb4vf/cxgb4vf_main.c     |    1 -
 drivers/net/cxgb4vf/t4vf_hw.c          |    1 -
 drivers/net/davinci_emac.c             |    1 -
 drivers/net/pptp.c                     |    1 -
 drivers/net/sfc/net_driver.h           |    1 -
 drivers/net/usb/cdc_ncm.c              |    1 -
 drivers/net/wan/farsync.c              |    1 -
 drivers/net/wireless/rtlwifi/wifi.h    |    1 -
 19 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/atl1c/atl1c.h b/drivers/net/atl1c/atl1c.h
index 7cb375e..16d886a 100644
--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -22,7 +22,6 @@
 #ifndef _ATL1C_H_
 #define _ATL1C_H_
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/drivers/net/atl1e/atl1e.h b/drivers/net/atl1e/atl1e.h
index 490d3b3..3861949 100644
--- a/drivers/net/atl1e/atl1e.h
+++ b/drivers/net/atl1e/atl1e.h
@@ -23,7 +23,6 @@
 #ifndef _ATL1E_H_
 #define _ATL1E_H_
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/drivers/net/benet/be.h b/drivers/net/benet/be.h
index f803c58..b1da25d 100644
--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -20,7 +20,6 @@
 
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <net/tcp.h>
 #include <net/ip.h>
diff --git a/drivers/net/bna/cna.h b/drivers/net/bna/cna.h
index bbd39dc..8ee9e38 100644
--- a/drivers/net/bna/cna.h
+++ b/drivers/net/bna/cna.h
@@ -19,7 +19,6 @@
 #ifndef __CNA_H__
 #define __CNA_H__
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 3df0c0f..175e134 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/types.h>
diff --git a/drivers/net/caif/caif_shm_u5500.c b/drivers/net/caif/caif_shm_u5500.c
index 5f771ab..89d76b7 100644
--- a/drivers/net/caif/caif_shm_u5500.c
+++ b/drivers/net/caif/caif_shm_u5500.c
@@ -7,7 +7,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":" fmt
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 20da199..a3fff47 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -5,7 +5,6 @@
  * License terms: GNU General Public License (GPL) version 2.
  */
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
diff --git a/drivers/net/caif/caif_spi_slave.c b/drivers/net/caif/caif_spi_slave.c
index 1b9943a..08c3570 100644
--- a/drivers/net/caif/caif_spi_slave.c
+++ b/drivers/net/caif/caif_spi_slave.c
@@ -4,7 +4,6 @@
  * Author:  Daniel Martensson / Daniel.Martensson@stericsson.com
  * License terms: GNU General Public License (GPL) version 2.
  */
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 110eda0..efd3e0f 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index e629b96..73ab459 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index aeea9f9..aa55688 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -17,7 +17,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/cxgb4vf/cxgb4vf_main.c b/drivers/net/cxgb4vf/cxgb4vf_main.c
index 6aad64d..98acbb7 100644
--- a/drivers/net/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/cxgb4vf/cxgb4vf_main.c
@@ -33,7 +33,6 @@
  * SOFTWARE.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
diff --git a/drivers/net/cxgb4vf/t4vf_hw.c b/drivers/net/cxgb4vf/t4vf_hw.c
index 192db22..fe3fd3d 100644
--- a/drivers/net/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/cxgb4vf/t4vf_hw.c
@@ -33,7 +33,6 @@
  * SOFTWARE.
  */
 
-#include <linux/version.h>
 #include <linux/pci.h>
 
 #include "t4vf_common.h"
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index baca6bf..b932e7d 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -48,7 +48,6 @@
 #include <linux/highmem.h>
 #include <linux/proc_fs.h>
 #include <linux/ctype.h>
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
diff --git a/drivers/net/pptp.c b/drivers/net/pptp.c
index 51dfcf8..7c1659f 100644
--- a/drivers/net/pptp.c
+++ b/drivers/net/pptp.c
@@ -30,7 +30,6 @@
 #include <linux/ip.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
-#include <linux/version.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 
diff --git a/drivers/net/sfc/net_driver.h b/drivers/net/sfc/net_driver.h
index 215d5c5..cb91508 100644
--- a/drivers/net/sfc/net_driver.h
+++ b/drivers/net/sfc/net_driver.h
@@ -17,7 +17,6 @@
 #define DEBUG
 #endif
 
-#include <linux/version.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 7113168..1a90d93 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -47,7 +47,6 @@
 #include <linux/mii.h>
 #include <linux/crc32.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index e050bd6..26c29e4 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 01226f8..3ef03a8 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -32,7 +32,6 @@
 
 #include <linux/sched.h>
 #include <linux/firmware.h>
-#include <linux/version.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
-- 
1.7.4.1

