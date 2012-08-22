Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2HVIXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:23:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2HVIW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:22:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 8/9] ARM: mvebu: Add pinctrl support to Armada 370 SoC
Date: Wed, 22 Aug 2012 10:22:29 +0200
Message-Id: <1345623750-10645-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This commits adds the necessary device tree information to define the
compatible property for the pinctrl driver instance of Armada 370 SoC.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/armada-370.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 3228ccc..875fcd8 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -31,5 +31,9 @@
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0xd0018200 0x100>;
 		};
+
+                pinctrl@d0018000 {
+			        compatible = "marvell,mv88f6710-pinctrl";
+	        };
 	};
 };
-- 
1.7.10.4

