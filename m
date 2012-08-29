Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2H2LSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 07:18:00 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53351
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab2H2LR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 07:17:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v4 3/7] ARM: imx6q: add anatop support into syscon
Date: Wed, 29 Aug 2012 18:56:54 +0800
Message-ID: <1346237818-9498-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346237818-9498-1-git-send-email-b29396@freescale.com>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

There're a few anatop registers need to be accessed by different modules.
Add anatop registers into syscon support for easy access.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 arch/arm/boot/dts/imx6q.dtsi |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index bea21bc..db3fa15 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -378,8 +378,8 @@
 				interrupts = <0 87 0x04 0 88 0x04>;
 			};
 
-			anatop@020c8000 {
-				compatible = "fsl,imx6q-anatop";
+			anatop: anatop@020c8000 {
+				compatible = "fsl,imx6q-anatop", "syscon";
 				reg = <0x020c8000 0x1000>;
 				interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
 
-- 
1.7.0.4


