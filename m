Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2LQSA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:00:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62315 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2LQSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:00:25 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add node for MSHC controller for Exynos4
Date: Tue, 18 Dec 2012 02:59:32 +0900
Message-Id: <1355767207-18744-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MSHC controller node to the device tree (DT).
---
 arch/arm/boot/dts/exynos4.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e1347fc..1b82921 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -131,6 +131,14 @@
 		status = "disabled";
 	};
 
+	mshc@12550000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12550000 0x1000>;
+		interrupts = <0 77 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
 	serial@13800000 {
 		compatible = "samsung,exynos4210-uart";
 		reg = <0x13800000 0x100>;
-- 
1.7.9.5

