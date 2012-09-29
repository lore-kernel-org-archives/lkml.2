Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2I2Kg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:36:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38583 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2I2Kfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:35:53 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <thierry.reding@avionic-design.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <omap@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 1/2] ARM: dts: AM33XX: Add ECAP & EHRPWM device tree nodes
Date: Sat, 29 Sep 2012 16:05:19 +0530
Message-ID: <1348914920-30737-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1348914920-30737-1-git-send-email-avinashphilip@ti.com>
References: <1348914920-30737-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ECAP and EHRPWM device tree nodes to AM33XX SoC family
by adding necessary properties like pwm-cells, base reg & set disabled
as status.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 a9c885a... 736ba0a... M	arch/arm/boot/dts/am33xx.dtsi
 arch/arm/boot/dts/am33xx.dtsi |   48 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index a9c885a..736ba0a 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -313,5 +313,53 @@
 			ti,hwmods = "timer7";
 			ti,timer-pwm;
 		};
+
+		ecap0: ecap@48300100 {
+			compatible = "ti,am33xx-ecap";
+			#pwm-cells = <3>;
+			reg = <0x48300100 0x80 0x48300000 0x10>;
+			ti,hwmods = "ecap0";
+			status = "disabled";
+		};
+
+		ecap1: ecap@48302100 {
+			compatible = "ti,am33xx-ecap";
+			#pwm-cells = <3>;
+			reg = <0x48302100 0x80 0x48302000 0x10>;
+			ti,hwmods = "ecap1";
+			status = "disabled";
+		};
+
+		ecap2: ecap@48304100 {
+			compatible = "ti,am33xx-ecap";
+			#pwm-cells = <3>;
+			reg = <0x48304100 0x80 0x48304000 0x10>;
+			ti,hwmods = "ecap2";
+			status = "disabled";
+		};
+
+		ehrpwm0: ehrpwm@48300200 {
+			compatible = "ti,am33xx-ehrpwm";
+			#pwm-cells = <3>;
+			reg = <0x48300200 0x100 0x48300000 0x10>;
+			ti,hwmods = "ehrpwm0";
+			status = "disabled";
+		};
+
+		ehrpwm1: ehrpwm@48302200 {
+			compatible = "ti,am33xx-ehrpwm";
+			#pwm-cells = <3>;
+			reg = <0x48302200 0x100 0x48302000 0x10>;
+			ti,hwmods = "ehrpwm1";
+			status = "disabled";
+		};
+
+		ehrpwm2: ehrpwm@48304200 {
+			compatible = "ti,am33xx-ehrpwm";
+			#pwm-cells = <3>;
+			reg = <0x48304200 0x100 0x48304000 0x10>;
+			ti,hwmods = "ehrpwm2";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.0.4

