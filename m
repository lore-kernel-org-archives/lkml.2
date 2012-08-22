Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2HVIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:41:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2HVIlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:41:09 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <akpm@linux-foundation.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <balbi@ti.com>, <arnd@arndb.de>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <ohad@wizery.com>,
        <linus.walleij@linaro.org>, <myungjoo.ham@samsung.com>,
        <rusty@rustcorp.com.au>, <swarren@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [RESEND PATCH v4 2/2] arm/dts: omap4: Add ocp2scp data
Date: Wed, 22 Aug 2012 14:10:03 +0530
Message-ID: <1345624803-16379-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345624803-16379-1-git-send-email-kishon@ti.com>
References: <1345624803-16379-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ocp2scp data node in omap4 device tree file.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 04cbbcb..8a780b2 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -295,5 +295,13 @@
 			interrupt-parent = <&gic>;
 			ti,hwmods = "dmic";
 		};
+
+		ocp2scp {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			ti,hwmods = "ocp2scp_usb_phy";
+		};
 	};
 };
-- 
1.7.9.5

