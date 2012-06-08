Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab2FHOCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:02:30 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:38599 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757180Ab2FHOC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:28 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 2/7] arm/dts: omap4: Add entry for OMAP DMIC IP
Date: Fri,  8 Jun 2012 17:02:00 +0300
Message-Id: <1339164125-32534-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMIC IP is used to connect up to 6 digital microphones directly to OMAP.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 4c43f3b..fb0287d 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -281,5 +281,14 @@
 			interrupt-parent = <&gic>;
 			ti,hwmods = "mcpdm";
 		};
+
+		dmic: dmic@4012e000 {
+			compatible = "ti,omap4-dmic";
+			reg = <0x4012e000 0x7f>, /* MPU private access */
+			      <0x4902e000 0x7f>; /* L3 Interconnect */
+			interrupts = <0 114 0x4>;
+			interrupt-parent = <&gic>;
+			ti,hwmods = "dmic";
+		};
 	};
 };
-- 
1.7.8.6

