Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2KKMvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:51:03 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2KKMu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:59 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: add empty Device Trees for all supported boards
Date: Sun, 11 Nov 2012 13:50:48 +0100
Message-Id: <1352638249-29298-15-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add empty board files for all boards supported by the legacy board
support.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/bcm63xx/dts/96328avng.dts   |   22 +++++++++++
 arch/mips/bcm63xx/dts/96338gw.dts     |   22 +++++++++++
 arch/mips/bcm63xx/dts/96338w.dts      |   22 +++++++++++
 arch/mips/bcm63xx/dts/96345gw2.dts    |   22 +++++++++++
 arch/mips/bcm63xx/dts/96348gw.dts     |   22 +++++++++++
 arch/mips/bcm63xx/dts/96348gw_10.dts  |   22 +++++++++++
 arch/mips/bcm63xx/dts/96348gw_11.dts  |   22 +++++++++++
 arch/mips/bcm63xx/dts/96348gw_a.dts   |   22 +++++++++++
 arch/mips/bcm63xx/dts/96348r.dts      |   22 +++++++++++
 arch/mips/bcm63xx/dts/96358vw.dts     |   22 +++++++++++
 arch/mips/bcm63xx/dts/96358vw2.dts    |   23 ++++++++++++
 arch/mips/bcm63xx/dts/Kconfig         |   64 +++++++++++++++++++++++++++++++++
 arch/mips/bcm63xx/dts/Makefile        |   18 +++++++++
 arch/mips/bcm63xx/dts/agpf_s0.dts     |   22 +++++++++++
 arch/mips/bcm63xx/dts/dv201amr.dts    |   22 +++++++++++
 arch/mips/bcm63xx/dts/dwv_s0.dts      |   22 +++++++++++
 arch/mips/bcm63xx/dts/fast2404.dts    |   22 +++++++++++
 arch/mips/bcm63xx/dts/rta1025w_16.dts |   22 +++++++++++
 18 files changed, 435 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/bcm63xx/dts/96328avng.dts
 create mode 100644 arch/mips/bcm63xx/dts/96338gw.dts
 create mode 100644 arch/mips/bcm63xx/dts/96338w.dts
 create mode 100644 arch/mips/bcm63xx/dts/96345gw2.dts
 create mode 100644 arch/mips/bcm63xx/dts/96348gw.dts
 create mode 100644 arch/mips/bcm63xx/dts/96348gw_10.dts
 create mode 100644 arch/mips/bcm63xx/dts/96348gw_11.dts
 create mode 100644 arch/mips/bcm63xx/dts/96348gw_a.dts
 create mode 100644 arch/mips/bcm63xx/dts/96348r.dts
 create mode 100644 arch/mips/bcm63xx/dts/96358vw.dts
 create mode 100644 arch/mips/bcm63xx/dts/96358vw2.dts
 create mode 100644 arch/mips/bcm63xx/dts/agpf_s0.dts
 create mode 100644 arch/mips/bcm63xx/dts/dv201amr.dts
 create mode 100644 arch/mips/bcm63xx/dts/dwv_s0.dts
 create mode 100644 arch/mips/bcm63xx/dts/fast2404.dts
 create mode 100644 arch/mips/bcm63xx/dts/rta1025w_16.dts

diff --git a/arch/mips/bcm63xx/dts/96328avng.dts b/arch/mips/bcm63xx/dts/96328avng.dts
new file mode 100644
index 0000000..c1aee15
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96328avng.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom BCM96328avng reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6328.dtsi"
+
+/ {
+	model = "96328avng";
+	compatible = "96328avng";
+
+	ubus@10000000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96338gw.dts b/arch/mips/bcm63xx/dts/96338gw.dts
new file mode 100644
index 0000000..5e4f893
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96338gw.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom BCM96338GW reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6338.dtsi"
+
+/ {
+	model = "96338GW";
+	compatible = "96338GW";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96338w.dts b/arch/mips/bcm63xx/dts/96338w.dts
new file mode 100644
index 0000000..972a530
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96338w.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom BCM963338W reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6338.dtsi"
+
+/ {
+	model = "96338W";
+	compatible = "96338W";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96345gw2.dts b/arch/mips/bcm63xx/dts/96345gw2.dts
new file mode 100644
index 0000000..0114733
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96345gw2.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom BCM96345GW2 reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6345.dtsi"
+
+/ {
+	model = "96345GW2";
+	compatible = "96345GW2";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96348gw.dts b/arch/mips/bcm63xx/dts/96348gw.dts
new file mode 100644
index 0000000..8d7f7ca
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96348gw.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96348GW reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "96348GW";
+	compatible = "96348GW";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96348gw_10.dts b/arch/mips/bcm63xx/dts/96348gw_10.dts
new file mode 100644
index 0000000..3b27b5b
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96348gw_10.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96348GW-10 reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "96348GW-10";
+	compatible = "96348GW-10";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96348gw_11.dts b/arch/mips/bcm63xx/dts/96348gw_11.dts
new file mode 100644
index 0000000..07837ac
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96348gw_11.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96348GW-11 reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "96348GW-11";
+	compatible = "96348GW-11";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96348gw_a.dts b/arch/mips/bcm63xx/dts/96348gw_a.dts
new file mode 100644
index 0000000..9b0e5bd
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96348gw_a.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96348GW-A reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "96348GW-A";
+	compatible = "96348GW-A";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96348r.dts b/arch/mips/bcm63xx/dts/96348r.dts
new file mode 100644
index 0000000..309f898
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96348r.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96348GWR reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "96348R";
+	compatible = "96348R";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96358vw.dts b/arch/mips/bcm63xx/dts/96358vw.dts
new file mode 100644
index 0000000..55c3e92
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96358vw.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96358VW reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6358.dtsi"
+
+/ {
+	model = "96358VW";
+	compatible = "96358VW";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/96358vw2.dts b/arch/mips/bcm63xx/dts/96358vw2.dts
new file mode 100644
index 0000000..88f12ba
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/96358vw2.dts
@@ -0,0 +1,23 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Broadcom 96358GWVW2 reference board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+
+/include/ "bcm6358.dtsi"
+
+/ {
+	model = "96358VW2";
+	compatible = "96358VW2";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/Kconfig b/arch/mips/bcm63xx/dts/Kconfig
index 919f3f6..1c35054 100644
--- a/arch/mips/bcm63xx/dts/Kconfig
+++ b/arch/mips/bcm63xx/dts/Kconfig
@@ -1,3 +1,67 @@
 menu "Built-in Device Tree support"
 
+config BOARD_96328AVNG
+	bool "96328avng reference board"
+	select BCM63XX_CPU_6328
+
+config BOARD_96338GW
+	bool "96338GW reference board"
+	select BCM63XX_CPU_6338
+
+config BOARD_96338W
+	bool "96338W reference board"
+	select BCM63XX_CPU_6338
+
+config BOARD_96345GW2
+	bool "96345GW2 reference board"
+	select BCM63XX_CPU_6345
+
+config BOARD_96348R
+	bool "96348R reference board"
+	select BCM63XX_CPU_6348
+
+config BOARD_96348GW
+	bool "96348GW reference board"
+	select BCM63XX_CPU_6348
+
+config BOARD_96348GW_10
+	bool "96348GW-10 reference board"
+	select BCM63XX_CPU_6348
+
+config BOARD_96348GW_11
+	bool "96348GW-11 reference board"
+	select BCM63XX_CPU_6348
+
+config BOARD_96348GW_A
+	bool "96348GW-A reference board"
+	select BCM63XX_CPU_6348
+
+config BOARD_96358VW
+	bool "96358VW2 reference board"
+	select BCM63XX_CPU_6358
+
+config BOARD_96358VW2
+	bool "96358VW2 reference board"
+	select BCM63XX_CPU_6358
+
+config BOARD_AGPF_S0
+	bool "AGPF-S0 (Pirelli Alice Gate VoIP 2 Plus Wi-Fi Business)"
+	select BCM63XX_CPU_6358
+
+config BOARD_DV201AMR
+	bool "DV201AMR (Davolink DV-201AMR)"
+	select BCM63XX_CPU_6348
+
+config BOARD_DWV_S0
+	bool "DWV-S0 (Pirelli A226G)"
+	select BCM63XX_CPU_6358
+
+config BOARD_FAST2404
+	bool "F@ST2404 (Sagem F@ST2404)"
+	select BCM63XX_CPU_6348
+
+config BOARD_RTA2015W_16
+	bool "RTA2015W_16 (Dynalink RTA2015W)"
+	select BCM63XX_CPU_6348
+
 endmenu
diff --git a/arch/mips/bcm63xx/dts/Makefile b/arch/mips/bcm63xx/dts/Makefile
index 94d1057..e4f6439 100644
--- a/arch/mips/bcm63xx/dts/Makefile
+++ b/arch/mips/bcm63xx/dts/Makefile
@@ -6,5 +6,23 @@ obj-$(CONFIG_BCM63XX_CPU_6348)		+= bcm96348_generic.dtb.o
 obj-$(CONFIG_BCM63XX_CPU_6358)		+= bcm96358_generic.dtb.o
 obj-$(CONFIG_BCM63XX_CPU_6368)		+= bcm96368_generic.dtb.o
 
+# board support
+obj-$(CONFIG_BOARD_96328AVNG)		+= 96328avng.dtb.o
+obj-$(CONFIG_BOARD_96338GW)		+= 96338gw.dtb.o
+obj-$(CONFIG_BOARD_96338G)		+= 96338g.dtb.o
+obj-$(CONFIG_BOARD_96345GW2)		+= 96345gw2.dtb.o
+obj-$(CONFIG_BOARD_96348GW)		+= 96348gw.dtb.o
+obj-$(CONFIG_BOARD_96348GW_10)		+= 96348gw_10.dtb.o
+obj-$(CONFIG_BOARD_96348GW_11)		+= 96348gw_11.dtb.o
+obj-$(CONFIG_BOARD_96348GW_A)		+= 96348gw_a.dtb.o
+obj-$(CONFIG_BOARD_96348R)		+= 96348r.dtb.o
+obj-$(CONFIG_BOARD_96358VW)		+= 96358vw.dtb.o
+obj-$(CONFIG_BOARD_96358VW2)		+= 96358vw2.dtb.o
+obj-$(CONFIG_BOARD_AGPF_S0)		+= agpf_s0.dtb.o
+obj-$(CONFIG_BOARD_DV201AMR)		+= dv201amr.dtb.o
+obj-$(CONFIG_BOARD_DWV_S0)		+= dwv_s0.dtb.o
+obj-$(CONFIG_BOARD_FAST2404)		+= fast2404.dtb.o
+obj-$(CONFIG_BOARD_RTA1025W_16)		+= rta1025w_16.dtb.o
+
 $(obj)/%.dtb: $(obj)/%.dts
 	$(call if_changed,dtc)
diff --git a/arch/mips/bcm63xx/dts/agpf_s0.dts b/arch/mips/bcm63xx/dts/agpf_s0.dts
new file mode 100644
index 0000000..bb0defd0
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/agpf_s0.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Pirelli Alice Gate VoIP 2 Plus Wi-Fi Business board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6358.dtsi"
+
+/ {
+	model = "AGPF-S0";
+	compatible = "AGPF-S0";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/dv201amr.dts b/arch/mips/bcm63xx/dts/dv201amr.dts
new file mode 100644
index 0000000..7cdb41f
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/dv201amr.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Davolink DV-201AMR
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "DV201AMR";
+	compatible = "DV201AMR";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/dwv_s0.dts b/arch/mips/bcm63xx/dts/dwv_s0.dts
new file mode 100644
index 0000000..96e79cd
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/dwv_s0.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Pirelli A226G
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6358.dtsi"
+
+/ {
+	model = "DWV-S0";
+	compatible = "DWV-S0";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/fast2404.dts b/arch/mips/bcm63xx/dts/fast2404.dts
new file mode 100644
index 0000000..55d31ce
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/fast2404.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Sagem F@ST2404 board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "F@ST2404";
+	compatible = "F@ST2404";
+
+	ubus@fffe0000 {
+
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/rta1025w_16.dts b/arch/mips/bcm63xx/dts/rta1025w_16.dts
new file mode 100644
index 0000000..825fe4e
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/rta1025w_16.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/*
+ * Device Tree Source for Dynalink RTA2015W board
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "RTA1025W_16";
+	compatible = "RTA1025W_16";
+
+	ubus@fffe0000 {
+
+	};
+};
-- 
1.7.2.5

