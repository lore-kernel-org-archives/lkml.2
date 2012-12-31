Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2LaCiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:38:19 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52570 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2LaCiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:38:09 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] ODROID-X: dts: Add fixed-regulator for peripherals.
Date: Mon, 31 Dec 2012 11:35:11 +0900
Message-Id: <1356921314-12595-3-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
References: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the node to support fixed voltage for peripherals like LED,
ethernet controller.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index 4915580..213b152 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -44,4 +44,14 @@
 		pinctrl-names = "default";
 		status = "okay";
 	};
+
+	regulator_p3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "p3v3_en";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpa1 1 1>;
+		enable-active-high;
+		regulator-boot-on;
+	};
 };
-- 
1.7.10.4

