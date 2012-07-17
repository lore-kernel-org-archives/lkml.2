Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2GQILy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:11:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab2GQILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:11:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 02/11] arm/dts: omap: Add omap-usb2 dt data
Date: Tue, 17 Jul 2012 13:40:02 +0530
Message-ID: <1342512611-20529-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342512611-20529-1-git-send-email-kishon@ti.com>
References: <1342512611-20529-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap-usb2 data node in omap4 device tree file.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index bda5df3..4d2dcc1 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -279,6 +279,11 @@
 			#size-cells = <1>;
 			ranges;
 			ti,hwmods = "ocp2scp_usb_phy";
+			usb2phy@0x4a0ad080 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a0ad080 0x58>,
+				      <0x4a002300 0x1>;
+			};
 		};
 	};
 };
-- 
1.7.5.4

