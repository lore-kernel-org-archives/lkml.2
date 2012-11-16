Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2KPSCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:02:31 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:46053 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2KPSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:02:28 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 2/2] arm: mvebu: armada 370/XP adding clock gating support: dt binding
Date: Fri, 16 Nov 2012 19:02:00 +0100
Message-Id: <1353088920-17458-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
 <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370.dtsi |    8 ++++++++
 arch/arm/boot/dts/armada-xp.dtsi  |    7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index dae966c..25524eb 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -82,5 +82,13 @@
 			#clock-cells = <1>;
 		};
 
+		clk_gate: clock-gating-control@d0018220 {
+			compatible = "marvell,armada-370-clock-gating";
+			reg = <0xd0018220 0x4>;
+			clocks = <&coreclk 0>;
+			#clock-cells = <1>;
+		};
+
+
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index b3c9fbc..82ea5e4 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -99,6 +99,13 @@
 			clocks = <&coreclk 1>;
 		};
 
+		clk_gate: clock-gating-control@d001821c {
+			compatible = "marvell,armada-xp-clock-gating";
+			reg = <0xd001821c 0x4>;
+			clocks = <&coreclk 0>;
+			#clock-cells = <1>;
+		};
+
 		system-controller@d0018200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0xd0018200 0x500>;
-- 
1.7.9.5

