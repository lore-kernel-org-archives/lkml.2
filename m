Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2LEBj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:39:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:23962 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2LEBjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:39:05 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [v2 PATCH 7/8] ARM: dts: add the watchdog nodes for at91sam9x5 and at91sam9n12 SoC
Date: Wed,  5 Dec 2012 09:34:26 +0800
Message-Id: <1354671267-19277-8-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Dec 2012 01:38:49.0600 (UTC) FILETIME=[4655E800:01CDD289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9n12.dtsi |    6 ++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 82508d6..4c3b411 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -202,6 +202,12 @@
 				#size-cells = <0>;
 				status = "disabled";
 			};
+
+			watchdog@fffffe40 {
+				compatible = "atmel,at91sam9260-wdt";
+				reg = <0xfffffe40 0x10>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 03fc136..e8e7afe 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -263,6 +263,12 @@
 					trigger-value = <0x6>;
 				};
 			};
+
+			watchdog@fffffe40 {
+				compatible = "atmel,at91sam9260-wdt";
+				reg = <0xfffffe40 0x10>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

