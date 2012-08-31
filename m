Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2HaJ1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:27:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2HaJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:27:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 7/9] ARM: i.MX53: use generic on-chip SRAM allocator driver for OCRAM
Date: Fri, 31 Aug 2012 11:27:02 +0200
Message-Id: <1346405224-20399-8-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346405224-20399-1-git-send-email-p.zabel@pengutronix.de>
References: <1346405224-20399-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx53.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 5da342a..2767a92 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -338,8 +338,8 @@
 			};
 		};
 
-		ocram@f8000000 {
-			compatible = "fsl,imx-ocram";
+		ocram: ocram@f8000000 {
+			compatible = "fsl,imx-ocram", "sram";
 			reg = <0xf8000000 0x20000>;
 		};
 	};
-- 
1.7.10.4

