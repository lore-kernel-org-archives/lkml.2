Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2KKMvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:51:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2KKMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:57 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: add serial blocks to Device Tree includes
Date: Sun, 11 Nov 2012 13:50:47 +0100
Message-Id: <1352638249-29298-14-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the serial block to the Device Tree includes for all SoCs.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/bcm63xx/dts/bcm6328.dtsi |   14 ++++++++++++++
 arch/mips/bcm63xx/dts/bcm6338.dtsi |    7 +++++++
 arch/mips/bcm63xx/dts/bcm6345.dtsi |    8 ++++++++
 arch/mips/bcm63xx/dts/bcm6348.dtsi |    7 +++++++
 arch/mips/bcm63xx/dts/bcm6358.dtsi |   14 ++++++++++++++
 arch/mips/bcm63xx/dts/bcm6368.dtsi |   14 ++++++++++++++
 6 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/mips/bcm63xx/dts/bcm6328.dtsi b/arch/mips/bcm63xx/dts/bcm6328.dtsi
index e2e92c3..d29d43c 100644
--- a/arch/mips/bcm63xx/dts/bcm6328.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6328.dtsi
@@ -140,5 +140,19 @@
 			#gpio-cells = <2>;
 			ngpio = <32>;
 		};
+
+		uart0: serial@100 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x100 0x18>;
+			interrupts = <28>;
+			status = "disabled";
+		};
+
+		uart1: serial@120 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x120 0x18>;
+			interrupts = <39>;
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6338.dtsi b/arch/mips/bcm63xx/dts/bcm6338.dtsi
index 28e7cb6..c7b45c1 100644
--- a/arch/mips/bcm63xx/dts/bcm6338.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6338.dtsi
@@ -90,6 +90,13 @@
 			};
 		};
 
+		uart0: serial@300 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x300 0x18>;
+			interrupts = <2>;
+			status = "disabled";
+		};
+
 		gpio0: gpio@400 {
 			compatible = "brcm,bcm63xx-gpio";
 			reg = <0x400 0x80>;
diff --git a/arch/mips/bcm63xx/dts/bcm6345.dtsi b/arch/mips/bcm63xx/dts/bcm6345.dtsi
index 1ebc024..055f66c 100644
--- a/arch/mips/bcm63xx/dts/bcm6345.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6345.dtsi
@@ -75,6 +75,14 @@
 				};
 			};
 		};
+
+		uart0: serial@300 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x300 0x18>;
+			interrupts = <2>;
+			status = "disabled";
+		};
+
 		gpio0: gpio@400 {
 			compatible = "brcm,bcm63xx-gpio";
 			reg = <0x400 0x80>;
diff --git a/arch/mips/bcm63xx/dts/bcm6348.dtsi b/arch/mips/bcm63xx/dts/bcm6348.dtsi
index 89acec7..5d1d10a 100644
--- a/arch/mips/bcm63xx/dts/bcm6348.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6348.dtsi
@@ -97,6 +97,13 @@
 			};
 		};
 
+		uart0: serial@300 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x300 0x18>;
+			interrupts = <2>;
+			status = "disabled";
+		};
+
 		gpio0: gpio@400 {
 			compatible = "brcm,bcm63xx-gpio";
 			regs = <0x400 0x80>;
diff --git a/arch/mips/bcm63xx/dts/bcm6358.dtsi b/arch/mips/bcm63xx/dts/bcm6358.dtsi
index 52170d6..702882d 100644
--- a/arch/mips/bcm63xx/dts/bcm6358.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6358.dtsi
@@ -138,5 +138,19 @@
 			#gpio-cells = <2>;
 			ngpio = <40>;
 		};
+
+		uart0: serial@100 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x100 0x18>;
+			interrupts = <2>;
+			status = "disabled";
+		};
+
+		uart1: serial@120 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x120 0x18>;
+			interrupts = <3>;
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/mips/bcm63xx/dts/bcm6368.dtsi b/arch/mips/bcm63xx/dts/bcm6368.dtsi
index 068231b..82cd030 100644
--- a/arch/mips/bcm63xx/dts/bcm6368.dtsi
+++ b/arch/mips/bcm63xx/dts/bcm6368.dtsi
@@ -178,5 +178,19 @@
 			#gpio-cells = <2>;
 			ngpio = <38>;
 		};
+
+		uart0: serial@100 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x100 0x18>;
+			interrupts = <2>;
+			status = "disabled";
+		};
+
+		uart1: serial@120 {
+			compatible = "brcm,bcm63xx-uart";
+			reg = <0x120 0x18>;
+			interrupts = <3>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.2.5

