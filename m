Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab2FHOE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:04:58 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59181 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757175Ab2FHOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:29 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 1/7] arm/dts: omap4: Add entry for OMAP McPDM IP
Date: Fri,  8 Jun 2012 17:01:59 +0300
Message-Id: <1339164125-32534-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

McPDM is used on OMAP4 based boards to communicate with an external audio
codec (twl6040).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 359c497..4c43f3b 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -272,5 +272,14 @@
 			ti,hwmods = "mmc5";
 			ti,needs-special-reset;
 		};
+
+		mcpdm: mcpdm@40132000 {
+			compatible = "ti,omap4-mcpdm";
+			reg = <0x40132000 0x7f>, /* MPU private access */
+			      <0x49032000 0x7f>; /* L3 Interconnect */
+			interrupts = <0 112 0x4>;
+			interrupt-parent = <&gic>;
+			ti,hwmods = "mcpdm";
+		};
 	};
 };
-- 
1.7.8.6

