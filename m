Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1LNPav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:30:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38068 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1LNPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:30:48 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 9/9] ARM: highbank: add interrupt properties to gpio nodes
Date: Wed, 14 Dec 2011 09:28:58 -0600
Message-Id: <1323876538-20406-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add interrupt-controller properties to pl061 gpio nodes so gpio lines can
function as interrupts.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/highbank.dts |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index aeb1a75..dfe2b49 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -89,7 +89,6 @@
 			#size-cells = <0>;
 			#address-cells = <1>;
 			interrupt-controller;
-			interrupt-parent;
 			reg = <0xfff11000 0x1000>,
 			      <0xfff10100 0x100>;
 		};
@@ -129,6 +128,8 @@
 			#gpio-cells = <2>;
 			compatible = "arm,pl061", "arm,primecell";
 			gpio-controller;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			reg = <0xfff30000 0x1000>;
 			interrupts = <0 14 4>;
 		};
@@ -137,6 +138,8 @@
 			#gpio-cells = <2>;
 			compatible = "arm,pl061", "arm,primecell";
 			gpio-controller;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			reg = <0xfff31000 0x1000>;
 			interrupts = <0 15 4>;
 		};
@@ -145,6 +148,8 @@
 			#gpio-cells = <2>;
 			compatible = "arm,pl061", "arm,primecell";
 			gpio-controller;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			reg = <0xfff32000 0x1000>;
 			interrupts = <0 16 4>;
 		};
@@ -153,6 +158,8 @@
 			#gpio-cells = <2>;
 			compatible = "arm,pl061", "arm,primecell";
 			gpio-controller;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			reg = <0xfff33000 0x1000>;
 			interrupts = <0 17 4>;
 		};
-- 
1.7.5.4

