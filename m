Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2KTFPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:15:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56692 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2KTFPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:15:03 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v3 09/10] ARM: dts: AM33XX: Add PWMSS device tree nodes
Date: Tue, 20 Nov 2012 10:33:50 +0530
Message-ID: <1353387831-31538-10-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
adding necessary properties like pwm-cells, base reg & set disabled as
status.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v2:
	- ranges property populated to handle child devices address range

:100644 100644 bb31bff... 75daf1d... M	arch/arm/boot/dts/am33xx.dtsi
 arch/arm/boot/dts/am33xx.dtsi |   84 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index bb31bff..75daf1d 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -210,5 +210,89 @@
 			interrupt-parent = <&intc>;
 			interrupts = <91>;
 		};
+
+		epwmss0: epwmss@48300000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48300000 0x10>;
+			ti,hwmods = "epwmss0";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48300100 0x48300100 0x80   /* ECAP */
+				  0x48300180 0x48300180 0x80   /* EQEP */
+				  0x48300200 0x48300200 0x80>; /* EHRPWM */
+
+			ecap0: ecap@48300100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48300100 0x80>;
+				ti,hwmods = "ecap0";
+				status = "disabled";
+			};
+
+			ehrpwm0: ehrpwm@48300200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48300200 0x80>;
+				ti,hwmods = "ehrpwm0";
+				status = "disabled";
+			};
+		};
+
+		epwmss1: epwmss@48302000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48302000 0x10>;
+			ti,hwmods = "epwmss1";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48302100 0x48302100 0x80   /* ECAP */
+				  0x48302180 0x48302180 0x80   /* EQEP */
+				  0x48302200 0x48302200 0x80>; /* EHRPWM */
+
+			ecap1: ecap@48302100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48302100 0x80>;
+				ti,hwmods = "ecap1";
+				status = "disabled";
+			};
+
+			ehrpwm1: ehrpwm@48302200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48302200 0x80>;
+				ti,hwmods = "ehrpwm1";
+				status = "disabled";
+			};
+		};
+
+		epwmss2: epwmss@48304000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48304000 0x10>;
+			ti,hwmods = "epwmss2";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48304100 0x48304100 0x80   /* ECAP */
+				  0x48304180 0x48304180 0x80   /* EQEP */
+				  0x48304200 0x48304200 0x80>; /* EHRPWM */
+
+			ecap2: ecap@48304100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48304100 0x80>;
+				ti,hwmods = "ecap2";
+				status = "disabled";
+			};
+
+			ehrpwm2: ehrpwm@48304200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48304200 0x80>;
+				ti,hwmods = "ehrpwm2";
+				status = "disabled";
+			};
+		};
 	};
 };
-- 
1.7.0.4

