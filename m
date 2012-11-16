Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KPKc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:32:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50536 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2KPKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:32:55 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 4/4] ARM: dts: add sram for imx53 and imx6q
Date: Fri, 16 Nov 2012 11:30:17 +0100
Message-Id: <1353061817-3207-5-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/boot/dts/imx53.dtsi |    5 +++++
 arch/arm/boot/dts/imx6q.dtsi |    6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 76ebb1a..7677218 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -541,5 +541,10 @@
 				status = "disabled";
 			};
 		};
+
+		ocram: ocram@f8000000 {
+			compatible = "fsl,imx-ocram", "sram";
+			reg = <0xf8000000 0x20000>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index f3990b0..855ac25 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -116,6 +116,12 @@
 			status = "disabled";
 		};
 
+		ocram: ocram@00900000 {
+			compatible = "fsl,imx-ocram", "sram";
+			reg = <0x00900000 0x3f000>;
+			clocks = <&clks 142>;
+		};
+
 		timer@00a00600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0x00a00600 0x20>;
-- 
1.7.10.4

