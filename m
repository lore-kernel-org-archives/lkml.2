Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2HXJSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:18:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2HXJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:18:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/5] ARM i.MX53, i.MX6q: Add IRAM to device tree
Date: Fri, 24 Aug 2012 11:17:43 +0200
Message-Id: <1345799866-19876-3-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
References: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx53.dtsi |    5 +++++
 arch/arm/boot/dts/imx6q.dtsi |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index e3e8694..6d99d8a 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -330,5 +330,10 @@
 				status = "disabled";
 			};
 		};
+
+		iram@f8000000 {
+			compatible = "fsl,imx-iram";
+			reg = <0xf8000000 0x20000>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 8c90cba..bb34a28 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -87,6 +87,11 @@
 		interrupt-parent = <&intc>;
 		ranges;
 
+		iram@00900000 {
+			compatible = "fsl,imx-iram";
+			reg = <0x00900000 0x3f000>;
+		};
+
 		timer@00a00600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0x00a00600 0x20>;
-- 
1.7.10.4

