Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2GPOOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:14:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58851 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab2GPOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:14:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <b-cousson@ti.com>,
        <rnayak@ti.com>, <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <ohad@wizery.com>, <linus.walleij@linaro.org>,
        <myungjoo.ham@samsung.com>, <rusty@rustcorp.com.au>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 2/2] arm/dts: omap4: Add ocp2scp data
Date: Mon, 16 Jul 2012 19:43:43 +0530
Message-ID: <1342448023-14438-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342448023-14438-1-git-send-email-kishon@ti.com>
References: <1342448023-14438-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ocp2scp data node in omap4 device tree file.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 359c497..bda5df3 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -272,5 +272,13 @@
 			ti,hwmods = "mmc5";
 			ti,needs-special-reset;
 		};
+
+		ocp2scp@4a0ad000  {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			ti,hwmods = "ocp2scp_usb_phy";
+		};
 	};
 };
-- 
1.7.5.4

