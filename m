Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab0EFRyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:54:12 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:33882 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0EFRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:54:09 -0400
X-MXL-Hash: 4be302403c6b8306-e2026db178f7c750425b520ad65f7fc1f94a6ed1
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Date: Thu, 6 May 2010 12:53:57 -0500
Subject: [PATCH] i2c: use <linux/io.h> instead of <asm/io.h>
Thread-Topic: [PATCH] i2c: use <linux/io.h> instead of <asm/io.h>
Thread-Index: AcrtRRmJ2n4Ioi5TSZuKgFomvMG4dA==
Message-ID: <0D753D10438DA54287A00B0270842697636ECB4E89@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2093003302; CM=0.500; S=0.209(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=R3SyFvRDXokA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=i00gxMtYAAAA:8 a=VVl]
X-AnalysisOut: [ED5B4AAAA:8 a=hadwmvD6Lqzq3kSl-tIA:9 a=1iXBQW1wXrhwYiC1mqg]
X-AnalysisOut: [A:7 a=YGejn-t38ANsyMIowYLEZ9gjiV8A:4 a=QEXdDO2ut3YA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10 a=BFDKbZatV3MA:10 a=2uLujLmDUDGRcv2j:21 a=6]
X-AnalysisOut: [CzALbIVHDU0_AUP:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o46IgcaS001973

As warned by checkpatch.pl, <linux/io.h> should be used instead of
<asm.io.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
index bd8f1e4..906a3ca 100644
--- a/drivers/i2c/busses/i2c-ali1535.c
+++ b/drivers/i2c/busses/i2c-ali1535.c
@@ -60,7 +60,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 
 /* ALI1535 SMBus address offsets */
diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 659f63f..b14f6d6 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -67,7 +67,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* ALI15X3 SMBus address offsets */
 #define SMBHSTSTS	(0 + ali15x3_smba)
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index c5a9fa4..03bcd07 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -43,7 +43,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* AMD756 SMBus address offsets */
 #define SMB_ADDR_OFFSET		0xE0
diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index 2fbef27..af1e5e2 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -18,7 +18,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR ("Vojtech Pavlik <vojtech@suse.cz>");
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 06e1ecb..305c075 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -23,8 +23,7 @@
 #include <linux/init.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <mach/at91_twi.h>
 #include <mach/board.h>
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 6122556..e5b1a3b 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -37,8 +37,8 @@
 #include <linux/isa.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pcf.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/irq.h>
 
 #include "../algos/i2c-algo-pcf.h"
diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
index c767295..9ff1695 100644
--- a/drivers/i2c/busses/i2c-hydra.c
+++ b/drivers/i2c/busses/i2c-hydra.c
@@ -28,7 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/init.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/hydra.h>
 
 
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index b1bc6e2..e1d175d 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -39,7 +39,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/of_platform.h>
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 5901707..112c61f 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -38,8 +38,7 @@
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include "i2c-iop3xx.h"
 
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 3623a44..1624206 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -17,8 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* Register defines */
 #define	MV64XXX_I2C_REG_SLAVE_ADDR			0x00
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 4a48dd4..b23dfe9 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -57,7 +57,7 @@
 #include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR ("Hans-Frieder Vogt <hfvogt@gmx.net>");
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index b4ed4ca..0070371 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -19,7 +19,7 @@
 #include <linux/wait.h>
 #include <linux/i2c-ocores.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 struct ocores_i2c {
 	void __iomem *base;
diff --git a/drivers/i2c/busses/i2c-parport-light.c b/drivers/i2c/busses/i2c-parport-light.c
index 5f41ec0..fc5fbd1 100644
--- a/drivers/i2c/busses/i2c-parport-light.c
+++ b/drivers/i2c/busses/i2c-parport-light.c
@@ -33,7 +33,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-smbus.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include "i2c-parport.h"
 
 #define DEFAULT_BASE 0x378
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index d3d4a4b..4174101 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -25,7 +25,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static struct pci_driver pasemi_smb_driver;
 
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index f7346a9..bbd7760 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -30,8 +30,8 @@
 #include <linux/isa.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pca.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/irq.h>
 
 #define DRIVER "i2c-pca-isa"
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 5b2213d..ef5c784 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -23,9 +23,9 @@
 #include <linux/i2c-algo-pca.h>
 #include <linux/i2c-pca-platform.h>
 #include <linux/gpio.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/io.h>
 
 struct i2c_pca_pf_data {
 	void __iomem			*reg_base;
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index ee9da6f..6d14ac2 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -39,7 +39,7 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 
 /* PIIX4 SMBus address offsets */
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 7b57d5f..dfa7ae9 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -33,7 +33,7 @@
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define DRV_NAME	"pmcmsptwi"
 
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 14d249f..525f045 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -34,9 +34,9 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/io.h>
 #include <plat/i2c.h>
 
 /*
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index d27072b..aece26b 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -35,9 +35,9 @@
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/io.h>
 
 #include <plat/regs-iic.h>
 #include <plat/iic.h>
diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
index c91359f..cadc021 100644
--- a/drivers/i2c/busses/i2c-s6000.c
+++ b/drivers/i2c/busses/i2c-s6000.c
@@ -36,8 +36,8 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include "i2c-s6000.h"
 
 #define DRV_NAME "i2c-s6000"
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index b9680f5..4f93da3 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -16,10 +16,10 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <asm/clock.h>
 #include <asm/i2c-sh7760.h>
-#include <asm/io.h>
 
 /* register offsets */
 #define I2CSCR		0x0		/* slave ctrl		*/
diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
index 98b1ec4..3d76a18 100644
--- a/drivers/i2c/busses/i2c-sibyte.c
+++ b/drivers/i2c/busses/i2c-sibyte.c
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/sibyte/sb1250_regs.h>
 #include <asm/sibyte/sb1250_smbus.h>
 
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 78b0610..2fc08fb 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -24,12 +24,11 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 
-#include <asm/io.h>
-
 struct simtec_i2c_data {
 	struct resource		*ioarea;
 	void __iomem		*reg;
diff --git a/drivers/i2c/busses/i2c-sis5595.c b/drivers/i2c/busses/i2c-sis5595.c
index 55a7137..4375866 100644
--- a/drivers/i2c/busses/i2c-sis5595.c
+++ b/drivers/i2c/busses/i2c-sis5595.c
@@ -61,7 +61,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static int blacklist[] = {
 	PCI_DEVICE_ID_SI_540,
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 2309c7f..e6f539e 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -53,7 +53,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* SIS630 SMBus registers */
 #define SMB_STS			0x80	/* status */
diff --git a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
index d43d8f8..86837f0 100644
--- a/drivers/i2c/busses/i2c-sis96x.c
+++ b/drivers/i2c/busses/i2c-sis96x.c
@@ -38,7 +38,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* base address register in PCI config space */
 #define SIS96x_BAR 0x04
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index 5c47383..6055601 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -15,8 +15,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define I2C_CONTROL	0x00
 #define I2C_CONTROLS	0x00
diff --git a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
index de78283..7799fe5 100644
--- a/drivers/i2c/busses/i2c-via.c
+++ b/drivers/i2c/busses/i2c-via.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* Power management registers */
 #define PM_CFG_REVID	0x08	/* silicon revision code */
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index d57292e..4c6fff5 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -51,7 +51,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static struct pci_dev *vt596_pdev;
 
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 684395b..dc8e524 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -32,7 +32,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <linux/scx200.h>
 
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
index 42df0ec..7ee0d50 100644
--- a/drivers/i2c/busses/scx200_i2c.c
+++ b/drivers/i2c/busses/scx200_i2c.c
@@ -27,7 +27,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <linux/scx200_gpio.h>
 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
