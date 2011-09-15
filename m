Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862Ab1IOUOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:14:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934716Ab1IOUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873428"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, benh@kernel.crashing.org
Subject: [PATCH 07/27] Initconst section fixes for POWERPC
Date: Thu, 15 Sep 2011 13:09:34 -0700
Message-Id: <1316117394-21666-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: benh@kernel.crashing.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/powerpc/platforms/40x/ppc40x_simple.c    |    2 +-
 arch/powerpc/platforms/512x/mpc5121_generic.c |    2 +-
 arch/powerpc/platforms/52xx/lite5200.c        |    2 +-
 arch/powerpc/platforms/52xx/media5200.c       |    2 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c  |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c     |    2 +-
 arch/powerpc/platforms/83xx/mpc830x_rdb.c     |    2 +-
 arch/powerpc/platforms/83xx/mpc831x_rdb.c     |    2 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c     |    2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c         |    2 +-
 arch/powerpc/platforms/cell/qpace_setup.c     |    2 +-
 arch/powerpc/platforms/cell/setup.c           |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index e8dd5c5..d6ed100 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -50,7 +50,7 @@ machine_device_initcall(ppc40x_simple, ppc40x_device_probe);
  * Again, if your board needs to do things differently then create a
  * board.c file for it rather than adding it to this list.
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"amcc,acadia",
 	"amcc,haleakala",
 	"amcc,kilauea",
diff --git a/arch/powerpc/platforms/512x/mpc5121_generic.c b/arch/powerpc/platforms/512x/mpc5121_generic.c
index 926731f..ca1ca66 100644
--- a/arch/powerpc/platforms/512x/mpc5121_generic.c
+++ b/arch/powerpc/platforms/512x/mpc5121_generic.c
@@ -26,7 +26,7 @@
 /*
  * list of supported boards
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"prt,prtlvt",
 	NULL
 };
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 01ffa64..448d862 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -172,7 +172,7 @@ static void __init lite5200_setup_arch(void)
 	mpc52xx_setup_pci();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,lite5200",
 	"fsl,lite5200b",
 	NULL,
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index 96f85e5..7a1a566 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -235,7 +235,7 @@ static void __init media5200_setup_arch(void)
 }
 
 /* list of the supported boards */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,media5200",
 	NULL
 };
diff --git a/arch/powerpc/platforms/52xx/mpc5200_simple.c b/arch/powerpc/platforms/52xx/mpc5200_simple.c
index e36d6e2..660cdde 100644
--- a/arch/powerpc/platforms/52xx/mpc5200_simple.c
+++ b/arch/powerpc/platforms/52xx/mpc5200_simple.c
@@ -49,7 +49,7 @@ static void __init mpc5200_simple_setup_arch(void)
 }
 
 /* list of the supported boards */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"intercontrol,digsy-mtc",
 	"manroland,mucmc52",
 	"manroland,uc101",
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index bfb11e0..e2d401a 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -93,7 +93,7 @@ struct mpc52xx_pci {
 };
 
 /* MPC5200 device tree match tables */
-const struct of_device_id mpc52xx_pci_ids[] __initdata = {
+const struct of_device_id mpc52xx_pci_ids[] __initconst = {
 	{ .type = "pci", .compatible = "fsl,mpc5200-pci", },
 	{ .type = "pci", .compatible = "mpc5200-pci", },
 	{}
diff --git a/arch/powerpc/platforms/83xx/mpc830x_rdb.c b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
index d0c4e15..7ef06d9 100644
--- a/arch/powerpc/platforms/83xx/mpc830x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
@@ -57,7 +57,7 @@ static void __init mpc830x_rdb_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"MPC8308RDB",
 	"fsl,mpc8308rdb",
 	"denx,mpc8308_p1m",
diff --git a/arch/powerpc/platforms/83xx/mpc831x_rdb.c b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
index f859ead..92c5f9d 100644
--- a/arch/powerpc/platforms/83xx/mpc831x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
@@ -60,7 +60,7 @@ static void __init mpc831x_rdb_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"MPC8313ERDB",
 	"fsl,mpc8315erdb",
 	NULL
diff --git a/arch/powerpc/platforms/83xx/mpc837x_rdb.c b/arch/powerpc/platforms/83xx/mpc837x_rdb.c
index 7bafbf2..787cd23 100644
--- a/arch/powerpc/platforms/83xx/mpc837x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc837x_rdb.c
@@ -101,7 +101,7 @@ static void __init mpc837x_rdb_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,mpc8377rdb",
 	"fsl,mpc8378rdb",
 	"fsl,mpc8379rdb",
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index 325de77..63d41d5 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -187,7 +187,7 @@ static int __init declare_of_platform_devices(void)
 }
 machine_device_initcall(tqm85xx, declare_of_platform_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"tqc,tqm8540",
 	"tqc,tqm8541",
 	"tqc,tqm8548",
diff --git a/arch/powerpc/platforms/cell/qpace_setup.c b/arch/powerpc/platforms/cell/qpace_setup.c
index 51e2901..52354bc 100644
--- a/arch/powerpc/platforms/cell/qpace_setup.c
+++ b/arch/powerpc/platforms/cell/qpace_setup.c
@@ -60,7 +60,7 @@ static void qpace_progress(char *s, unsigned short hex)
 	printk("*** %04x : %s\n", hex, s ? s : "");
 }
 
-static const struct of_device_id qpace_bus_ids[] __initdata = {
+static const struct of_device_id qpace_bus_ids[] __initconst = {
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "spider", },
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index c73cf4c..9fd2c9b 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -139,7 +139,7 @@ static int __devinit cell_setup_phb(struct pci_controller *phb)
 	return 0;
 }
 
-static const struct of_device_id cell_bus_ids[] __initdata = {
+static const struct of_device_id cell_bus_ids[] __initconst = {
 	{ .type = "soc", },
 	{ .compatible = "soc", },
 	{ .type = "spider", },
-- 
1.7.4.4

