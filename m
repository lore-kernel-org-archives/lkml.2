Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2KMRRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:17:31 -0500
Received: from sauhun.de ([89.238.76.85]:53875 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2KMRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:17:26 -0500
From: Wolfram Sang <wolfram@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-arm-kernel@lists.infradead.org, devicetree-discuss@ozlabs.org,
        Wolfram Sang <wolfram@the-dreams.de>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] bindings: i2c: use consistent naming for i2c binding descriptions
Date: Tue, 13 Nov 2012 18:16:43 +0100
Message-Id: <1352827003-24287-1-git-send-email-wolfram@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filenames of devictree binding documentation seems to be arbitrary and
for me it is unneeded hazzle to find the corresponding documentation for
a specific driver.

Naming the description the same as the driver is a lot easier and makes
sense to me since the driver defines the binding it understands.

Also, remove a reference in one source to the binding documentation, since path
information easily gets stale.

Signed-off-by: Wolfram Sang <wolfram@the-dreams.de>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---

I think it would be helpful if other subsystems would follow if we can agree on
this pattern.

Thanks,

   Wolfram

 .../bindings/i2c/{atmel-i2c.txt => i2c-at91.txt}     |    0
 .../bindings/i2c/{davinci.txt => i2c-davinci.txt}    |    0
 .../bindings/i2c/{gpio-i2c.txt => i2c-gpio.txt}      |    0
 .../bindings/i2c/{fsl-imx-i2c.txt => i2c-imx.txt}    |    0
 .../bindings/i2c/{fsl-i2c.txt => i2c-mpc.txt}        |    0
 .../devicetree/bindings/i2c/{mux.txt => i2c-mux.txt} |    0
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt          |   18 ++++++++++++++++++
 .../bindings/i2c/{nomadik.txt => i2c-nomadik.txt}    |    0
 .../bindings/i2c/{cavium-i2c.txt => i2c-octeon.txt}  |    0
 .../bindings/i2c/{omap-i2c.txt => i2c-omap.txt}      |    0
 .../devicetree/bindings/i2c/{pnx.txt => i2c-pnx.txt} |    0
 .../i2c/{ce4100-i2c.txt => i2c-pxa-pci-ce4100.txt}   |    0
 .../bindings/i2c/{mrvl-i2c.txt => i2c-pxa.txt}       |   18 ------------------
 .../i2c/{samsung-i2c.txt => i2c-s3c2410.txt}         |    0
 .../bindings/i2c/{sirf-i2c.txt => i2c-sirf.txt}      |    0
 .../i2c/{arm-versatile.txt => i2c-versatile.txt}     |    0
 .../bindings/i2c/{xiic.txt => i2c-xiic.txt}          |    0
 drivers/i2c/busses/i2c-ocores.c                      |    4 ----
 18 files changed, 18 insertions(+), 22 deletions(-)
 rename Documentation/devicetree/bindings/i2c/{atmel-i2c.txt => i2c-at91.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{davinci.txt => i2c-davinci.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{gpio-i2c.txt => i2c-gpio.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{fsl-imx-i2c.txt => i2c-imx.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{fsl-i2c.txt => i2c-mpc.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{mux.txt => i2c-mux.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
 rename Documentation/devicetree/bindings/i2c/{nomadik.txt => i2c-nomadik.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{cavium-i2c.txt => i2c-octeon.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{omap-i2c.txt => i2c-omap.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{pnx.txt => i2c-pnx.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{ce4100-i2c.txt => i2c-pxa-pci-ce4100.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{mrvl-i2c.txt => i2c-pxa.txt} (70%)
 rename Documentation/devicetree/bindings/i2c/{samsung-i2c.txt => i2c-s3c2410.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{sirf-i2c.txt => i2c-sirf.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{arm-versatile.txt => i2c-versatile.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{xiic.txt => i2c-xiic.txt} (100%)

diff --git a/Documentation/devicetree/bindings/i2c/atmel-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-at91.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/atmel-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-at91.txt
diff --git a/Documentation/devicetree/bindings/i2c/davinci.txt b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/davinci.txt
rename to Documentation/devicetree/bindings/i2c/i2c-davinci.txt
diff --git a/Documentation/devicetree/bindings/i2c/gpio-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/gpio-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-gpio.txt
diff --git a/Documentation/devicetree/bindings/i2c/fsl-imx-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-imx.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/fsl-imx-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-imx.txt
diff --git a/Documentation/devicetree/bindings/i2c/fsl-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-mpc.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/fsl-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-mpc.txt
diff --git a/Documentation/devicetree/bindings/i2c/mux.txt b/Documentation/devicetree/bindings/i2c/i2c-mux.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/mux.txt
rename to Documentation/devicetree/bindings/i2c/i2c-mux.txt
diff --git a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
new file mode 100644
index 0000000..f46d928
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
@@ -0,0 +1,18 @@
+
+* Marvell MV64XXX I2C controller
+
+Required properties :
+
+ - reg             : Offset and length of the register set for the device
+ - compatible      : Should be "marvell,mv64xxx-i2c"
+ - interrupts      : The interrupt number
+ - clock-frequency : Desired I2C bus clock frequency in Hz.
+
+Examples:
+
+	i2c@11000 {
+		compatible = "marvell,mv64xxx-i2c";
+		reg = <0x11000 0x20>;
+		interrupts = <29>;
+		clock-frequency = <100000>;
+	};
diff --git a/Documentation/devicetree/bindings/i2c/nomadik.txt b/Documentation/devicetree/bindings/i2c/i2c-nomadik.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/nomadik.txt
rename to Documentation/devicetree/bindings/i2c/i2c-nomadik.txt
diff --git a/Documentation/devicetree/bindings/i2c/cavium-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-octeon.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/cavium-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-octeon.txt
diff --git a/Documentation/devicetree/bindings/i2c/omap-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-omap.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/omap-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-omap.txt
diff --git a/Documentation/devicetree/bindings/i2c/pnx.txt b/Documentation/devicetree/bindings/i2c/i2c-pnx.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/pnx.txt
rename to Documentation/devicetree/bindings/i2c/i2c-pnx.txt
diff --git a/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-pxa-pci-ce4100.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-pxa-pci-ce4100.txt
diff --git a/Documentation/devicetree/bindings/i2c/mrvl-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-pxa.txt
similarity index 70%
rename from Documentation/devicetree/bindings/i2c/mrvl-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-pxa.txt
index 0f79450..12b78ac 100644
--- a/Documentation/devicetree/bindings/i2c/mrvl-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-pxa.txt
@@ -31,21 +31,3 @@ Examples:
 		reg = <0xd4025000 0x1000>;
 		interrupts = <58>;
 	};
-
-* Marvell MV64XXX I2C controller
-
-Required properties :
-
- - reg             : Offset and length of the register set for the device
- - compatible      : Should be "marvell,mv64xxx-i2c"
- - interrupts      : The interrupt number
- - clock-frequency : Desired I2C bus clock frequency in Hz.
-
-Examples:
-
-	i2c@11000 {
-		compatible = "marvell,mv64xxx-i2c";
-		reg = <0x11000 0x20>;
-		interrupts = <29>;
-		clock-frequency = <100000>;
-	};
diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/samsung-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-s3c2410.txt
diff --git a/Documentation/devicetree/bindings/i2c/sirf-i2c.txt b/Documentation/devicetree/bindings/i2c/i2c-sirf.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/sirf-i2c.txt
rename to Documentation/devicetree/bindings/i2c/i2c-sirf.txt
diff --git a/Documentation/devicetree/bindings/i2c/arm-versatile.txt b/Documentation/devicetree/bindings/i2c/i2c-versatile.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/arm-versatile.txt
rename to Documentation/devicetree/bindings/i2c/i2c-versatile.txt
diff --git a/Documentation/devicetree/bindings/i2c/xiic.txt b/Documentation/devicetree/bindings/i2c/i2c-xiic.txt
similarity index 100%
rename from Documentation/devicetree/bindings/i2c/xiic.txt
rename to Documentation/devicetree/bindings/i2c/i2c-xiic.txt
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..15da1ac 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -9,10 +9,6 @@
  * kind, whether express or implied.
  */
 
-/*
- * This driver can be used from the device tree, see
- *     Documentation/devicetree/bindings/i2c/ocore-i2c.txt
- */
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-- 
1.7.10.4

