Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2IKGNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:13:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34998 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2IKGNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:13:09 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <rnayak@ti.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <ohad@wizery.com>,
        <linus.walleij@linaro.org>, <myungjoo.ham@samsung.com>,
        <rusty@rustcorp.com.au>, <swarren@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] arm/dts: omap: Add omap-usb2 dt data
Date: Tue, 11 Sep 2012 11:42:12 +0530
Message-ID: <1347343932-3656-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
connected to ocp2scp, omap-usb2 dt data is added as a child node
of ocp2scp.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Applies on
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-next
 arch/arm/boot/dts/omap4.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 8a780b2..bdc21f1 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -302,6 +302,11 @@
 			#size-cells = <1>;
 			ranges;
 			ti,hwmods = "ocp2scp_usb_phy";
+			usb2phy@4a0ad080 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a0ad080 0x58>,
+				      <0x4a002300 0x4>;
+			};
 		};
 	};
 };
-- 
1.7.9.5

