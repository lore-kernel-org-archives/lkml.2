Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1DEPBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:44473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab1DEO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org
Subject: [PATCH 31/34] edac: Drop __DATE__ usage
Date: Tue,  5 Apr 2011 16:59:18 +0200
Message-Id: <1302015561-21047-32-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Doug Thompson <dougthompson@xmission.com>
Cc: bluesmoke-devel@lists.sourceforge.net
Cc: linux-edac@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/edac/amd76x_edac.c  |    2 +-
 drivers/edac/amd8111_edac.c |    2 +-
 drivers/edac/amd8131_edac.c |    2 +-
 drivers/edac/cpc925_edac.c  |    2 +-
 drivers/edac/e752x_edac.c   |    2 +-
 drivers/edac/e7xxx_edac.c   |    2 +-
 drivers/edac/edac_module.c  |    2 +-
 drivers/edac/i5000_edac.c   |    2 +-
 drivers/edac/i5400_edac.c   |    2 +-
 drivers/edac/i7300_edac.c   |    2 +-
 drivers/edac/i7core_edac.c  |    2 +-
 drivers/edac/i82860_edac.c  |    2 +-
 drivers/edac/i82875p_edac.c |    2 +-
 drivers/edac/i82975x_edac.c |    2 +-
 drivers/edac/mpc85xx_edac.h |    2 +-
 drivers/edac/mv64x60_edac.h |    2 +-
 drivers/edac/ppc4xx_edac.c  |    2 +-
 drivers/edac/r82600_edac.c  |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index cace0a7..e47e73b 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -19,7 +19,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define AMD76X_REVISION	" Ver: 2.0.2 "  __DATE__
+#define AMD76X_REVISION	" Ver: 2.0.2"
 #define EDAC_MOD_STR	"amd76x_edac"
 
 #define amd76x_printk(level, fmt, arg...) \
diff --git a/drivers/edac/amd8111_edac.c b/drivers/edac/amd8111_edac.c
index 35b78d0..ddd8900 100644
--- a/drivers/edac/amd8111_edac.c
+++ b/drivers/edac/amd8111_edac.c
@@ -33,7 +33,7 @@
 #include "edac_module.h"
 #include "amd8111_edac.h"
 
-#define AMD8111_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
+#define AMD8111_EDAC_REVISION	" Ver: 1.0.0"
 #define AMD8111_EDAC_MOD_STR	"amd8111_edac"
 
 #define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index b432d60..a5c6805 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -33,7 +33,7 @@
 #include "edac_module.h"
 #include "amd8131_edac.h"
 
-#define AMD8131_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
+#define AMD8131_EDAC_REVISION	" Ver: 1.0.0"
 #define AMD8131_EDAC_MOD_STR	"amd8131_edac"
 
 /* Wrapper functions for accessing PCI configuration space */
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index b9a781c..3400ae3 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -30,7 +30,7 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define CPC925_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
+#define CPC925_EDAC_REVISION	" Ver: 1.0.0"
 #define CPC925_EDAC_MOD_STR	"cpc925_edac"
 
 #define cpc925_printk(level, fmt, arg...) \
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index ec302d4..1af531a 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -24,7 +24,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define E752X_REVISION	" Ver: 2.0.2 " __DATE__
+#define E752X_REVISION	" Ver: 2.0.2"
 #define EDAC_MOD_STR	"e752x_edac"
 
 static int report_non_memory_errors;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 1731d72..6ffb6d2 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -29,7 +29,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define	E7XXX_REVISION " Ver: 2.0.2 " __DATE__
+#define	E7XXX_REVISION " Ver: 2.0.2"
 #define	EDAC_MOD_STR	"e7xxx_edac"
 
 #define e7xxx_printk(level, fmt, arg...) \
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index be4b075..5ddaa86 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -15,7 +15,7 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_VERSION "Ver: 2.1.0 " __DATE__
+#define EDAC_VERSION "Ver: 2.1.0"
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a5cefab..3d0b726 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -27,7 +27,7 @@
 /*
  * Alter this version for the I5000 module when modifications are made
  */
-#define I5000_REVISION    " Ver: 2.0.12 " __DATE__
+#define I5000_REVISION    " Ver: 2.0.12"
 #define EDAC_MOD_STR      "i5000_edac"
 
 #define i5000_printk(level, fmt, arg...) \
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 38a9be9..fd362b4 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -33,7 +33,7 @@
 /*
  * Alter this version for the I5400 module when modifications are made
  */
-#define I5400_REVISION    " Ver: 1.0.0 " __DATE__
+#define I5400_REVISION    " Ver: 1.0.0"
 
 #define EDAC_MOD_STR      "i5400_edac"
 
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 05523b5..7ffc65c 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -31,7 +31,7 @@
 /*
  * Alter this version for the I7300 module when modifications are made
  */
-#define I7300_REVISION    " Ver: 1.0.0 " __DATE__
+#define I7300_REVISION    " Ver: 1.0.0"
 
 #define EDAC_MOD_STR      "i7300_edac"
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 81154ab..3f320ba 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
 /*
  * Alter this version for the module when modifications are made
  */
-#define I7CORE_REVISION    " Ver: 1.0.0 " __DATE__
+#define I7CORE_REVISION    " Ver: 1.0.0"
 #define EDAC_MOD_STR      "i7core_edac"
 
 /*
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index b8a95cf..931a057 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -16,7 +16,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define  I82860_REVISION " Ver: 2.0.2 " __DATE__
+#define  I82860_REVISION " Ver: 2.0.2"
 #define EDAC_MOD_STR	"i82860_edac"
 
 #define i82860_printk(level, fmt, arg...) \
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index b2fd1e8..33864c6 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -20,7 +20,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define I82875P_REVISION	" Ver: 2.0.2 " __DATE__
+#define I82875P_REVISION	" Ver: 2.0.2"
 #define EDAC_MOD_STR		"i82875p_edac"
 
 #define i82875p_printk(level, fmt, arg...) \
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 3218819..4f366c2 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -16,7 +16,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define I82975X_REVISION	" Ver: 1.0.0 " __DATE__
+#define I82975X_REVISION	" Ver: 1.0.0"
 #define EDAC_MOD_STR		"i82975x_edac"
 
 #define i82975x_printk(level, fmt, arg...) \
diff --git a/drivers/edac/mpc85xx_edac.h b/drivers/edac/mpc85xx_edac.h
index cb24df8..932016f 100644
--- a/drivers/edac/mpc85xx_edac.h
+++ b/drivers/edac/mpc85xx_edac.h
@@ -11,7 +11,7 @@
 #ifndef _MPC85XX_EDAC_H_
 #define _MPC85XX_EDAC_H_
 
-#define MPC85XX_REVISION " Ver: 2.0.0 " __DATE__
+#define MPC85XX_REVISION " Ver: 2.0.0"
 #define EDAC_MOD_STR	"MPC85xx_edac"
 
 #define mpc85xx_printk(level, fmt, arg...) \
diff --git a/drivers/edac/mv64x60_edac.h b/drivers/edac/mv64x60_edac.h
index e042e2d..c7f209c 100644
--- a/drivers/edac/mv64x60_edac.h
+++ b/drivers/edac/mv64x60_edac.h
@@ -12,7 +12,7 @@
 #ifndef _MV64X60_EDAC_H_
 #define _MV64X60_EDAC_H_
 
-#define MV64x60_REVISION " Ver: 2.0.0 " __DATE__
+#define MV64x60_REVISION " Ver: 2.0.0"
 #define EDAC_MOD_STR	"MV64x60_edac"
 
 #define mv64x60_printk(level, fmt, arg...) \
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index b9f0c20..83863fd 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -113,7 +113,7 @@
 #define EDAC_OPSTATE_UNKNOWN_STR	"unknown"
 
 #define PPC4XX_EDAC_MODULE_NAME		"ppc4xx_edac"
-#define PPC4XX_EDAC_MODULE_REVISION	"v1.0.0 " __DATE__
+#define PPC4XX_EDAC_MODULE_REVISION	"v1.0.0"
 
 #define PPC4XX_EDAC_MESSAGE_SIZE	256
 
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 6a822c6..387997a 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -22,7 +22,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"
 
-#define R82600_REVISION	" Ver: 2.0.2 " __DATE__
+#define R82600_REVISION	" Ver: 2.0.2"
 #define EDAC_MOD_STR	"r82600_edac"
 
 #define r82600_printk(level, fmt, arg...) \
-- 
1.7.4.1

