Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2LQT5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:57:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46972 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2LQT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:57:09 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        Dongjin Kim <tobetter@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ODROID-X: dts: Add fixed-regulator for peripherals.
Date: Tue, 18 Dec 2012 04:55:05 +0900
Message-Id: <1355774107-364-3-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355774107-364-1-git-send-email-tobetter@gmail.com>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com>
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
index 786ddd7..2d45dcb 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -49,4 +49,14 @@
 		pinctrl-names = "default";
 		status = "okay";
 	};
+
+	regulator_p3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "p3v3_en";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpa1 1 0>;
+		enable-active-high;
+		regulator-boot-on;
+	};
 };
-- 
1.7.9.5

