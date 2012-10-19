Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2JSKut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:50:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41811 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab2JSKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:50:48 -0400
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, Afzal Mohammed <afzal@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm/dts: am33xx rtc node
Date: Fri, 19 Oct 2012 16:20:21 +0530
Message-ID: <1350643825-9657-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add am33xx rtc node.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

Based on v3.7-rc1,
Dependent on series "rtc: omap dt support (for am33xx)",
(https://lkml.org/lkml/2012/10/19/163)
Tested on Beagle Bone.

 arch/arm/boot/dts/am33xx.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index bb31bff..356711e 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -210,5 +210,14 @@
 			interrupt-parent = <&intc>;
 			interrupts = <91>;
 		};
+
+		rtc {
+			compatible = "ti,da830-rtc";
+			ti,hwmods = "rtc";
+			reg = <0x44e3e000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <75
+				      76>;
+		};
 	};
 };
-- 
1.7.12

