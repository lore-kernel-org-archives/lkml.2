Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2KYURx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 15:17:53 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:58114 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2KYURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 15:17:49 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, julien.boibessot@armadeus.com,
        eric.jarrige@armadeus.org, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH 4/4] apf27: add rtc ds1374 to the device tree
Date: Sun, 25 Nov 2012 21:17:05 +0100
Message-Id: <1353874625-14754-5-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 arch/arm/boot/dts/imx27-apf27.dts |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-apf27.dts b/arch/arm/boot/dts/imx27-apf27.dts
index c0327c0..20b8ef2 100644
--- a/arch/arm/boot/dts/imx27-apf27.dts
+++ b/arch/arm/boot/dts/imx27-apf27.dts
@@ -42,6 +42,16 @@
 			ethernet@1002b000 {
 				status = "okay";
 			};
+
+			i2c1: i2c@10012000 {
+				clock-frequency = <400000>;
+				status = "okay";
+
+				rtc@68 {
+					compatible = "dallas,ds1374";
+					reg = <0x68>;
+				};
+			};
 		};
 
 		nand@d8000000 {
-- 
1.7.4.4

