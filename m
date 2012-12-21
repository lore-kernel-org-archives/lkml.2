Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2LURSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:18:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45857 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2LURSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:18:16 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add node for MSHC controller for Exynos4
Date: Sat, 22 Dec 2012 02:16:54 +0900
Message-Id: <1356110218-2423-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MSHC controller node to the device tree (DT).

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e1347fc..92bca86 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -131,6 +131,15 @@
 		status = "disabled";
 	};
 
+	mshc@12550000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12550000 0x1000>;
+		interrupts = <0 77 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	serial@13800000 {
 		compatible = "samsung,exynos4210-uart";
 		reg = <0x13800000 0x100>;
-- 
1.7.9.5

