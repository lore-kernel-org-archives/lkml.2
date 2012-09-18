Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2IRFuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:50:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49627 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2IRFud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:50:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <linux@arm.linux.org.uk>, <tony@atomide.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Date: Tue, 18 Sep 2012 11:00:28 +0530
Message-ID: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add McSPI data node to AM33XX device tree file. The McSPI module (and so
as the driver) is reused from OMAP4.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Tested-by: Matt Porter <mporter@ti.com>
---
Changes since v1:
        - Corrected reg offset in reg DT entry.

:100644 100644 ff3badb... 065fd54... M	arch/arm/boot/dts/am33xx.dtsi
 arch/arm/boot/dts/am33xx.dtsi |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index ff3badb..065fd54 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -219,5 +219,30 @@
 			interrupt-parent = <&intc>;
 			interrupts = <91>;
 		};
+
+		spi0: spi@48030000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x48030000 0x400>;
+			interrupt-parent = <&intc>;
+			interrupt = <65>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi0";
+			status = "disabled";
+
+		};
+
+		spi1: spi@481a0000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x481a0000 0x400>;
+			interrupt-parent = <&intc>;
+			interrupt = <125>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi1";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.4.1

