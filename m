Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KKMuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2KKMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:38 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: add simple Device Tree includes for all SoCs
Date: Sun, 11 Nov 2012 13:50:36 +0100
Message-Id: <1352638249-29298-3-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple Device Tree include files for all currently supported SoCs.
These will be populated with device definitions as driver support
gets added.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/bcm63xx/dts/bcm6328.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm6338.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm6345.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm6348.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm6358.dtsi |   33 +++++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm6368.dtsi |   33 +++++++++++++++++++++++++++++++++
 6 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/bcm63xx/dts/bcm6328.dtsi
 create mode 100644 arch/mips/bcm63xx/dts/bcm6338.dtsi
 create mode 100644 arch/mips/bcm63xx/dts/bcm6345.dtsi
 create mode 100644 arch/mips/bcm63xx/dts/bcm6348.dtsi
 create mode 100644 arch/mips/bcm63xx/dts/bcm6358.dtsi
 create mode 100644 arch/mips/bcm63xx/dts/bcm6368.dtsi

diff --git a/arch/mips/bcm63xx/dts/bcm6328.dtsi b/arch/mips/bcm63xx/dts/bcm6328.dtsi
new file mode 100644
index 0000000..a0e1835
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6328.dtsi
@@ -0,0 +1,30 @@
+/*
+ * Device Tree Include file for Broadcom BCM6328 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6328";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips4350", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@10000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x10000000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm6338.dtsi b/arch/mips/bcm63xx/dts/bcm6338.dtsi
new file mode 100644
index 0000000..21772d9
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6338.dtsi
@@ -0,0 +1,30 @@
+/*
+ * Device Tree Include file for Broadcom BCM6338 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6338";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips3300", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@fffe0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0xfffe0000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm6345.dtsi b/arch/mips/bcm63xx/dts/bcm6345.dtsi
new file mode 100644
index 0000000..f1e7153
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6345.dtsi
@@ -0,0 +1,30 @@
+/*
+ * Device Tree Include file for Broadcom BCM6345 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6345";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips3300", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@fffe0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0xfffe0000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm6348.dtsi b/arch/mips/bcm63xx/dts/bcm6348.dtsi
new file mode 100644
index 0000000..8a5a2dc
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6348.dtsi
@@ -0,0 +1,30 @@
+/*
+ * Device Tree Include file for Broadcom BCM6348 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6348";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips3300", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@fffe0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0xfffe0000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm6358.dtsi b/arch/mips/bcm63xx/dts/bcm6358.dtsi
new file mode 100644
index 0000000..1d3f20f
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6358.dtsi
@@ -0,0 +1,33 @@
+/*
+ * Device Tree Include file for Broadcom BCM6358 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6358";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips4350", "mips,mips4Kc";
+		};
+		cpu@1 {
+			compatible = "brcm,bmips4350", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@fffe0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0xfffe0000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm6368.dtsi b/arch/mips/bcm63xx/dts/bcm6368.dtsi
new file mode 100644
index 0000000..a7624b9
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm6368.dtsi
@@ -0,0 +1,33 @@
+/*
+ * Device Tree Include file for Broadcom BCM6368 SoC
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6368";
+
+	cpus {
+		cpu@0 {
+			compatible = "brcm,bmips4350", "mips,mips4Kc";
+		};
+		cpu@1 {
+			compatible = "brcm,bmips4350", "mips,mips4Kc";
+		};
+	};
+
+	memory { device_type = "memory"; reg = <0 0>; };
+
+	ubus@10000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x10000000 0x20000>;
+		compatible = "simple-bus";
+	};
+};
-- 
1.7.2.5

