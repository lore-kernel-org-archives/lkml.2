Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3AGVAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:00:11 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:45300 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3AGVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:00:09 -0500
From: Sean Paul <seanpaul@chromium.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: thomas.abraham@linaro.org, kgene.kim@samsung.com,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH] ARM: dts: exynos5250: Set HDMI version to v1.4
Date: Mon,  7 Jan 2013 16:00:00 -0500
Message-Id: <1357592400-18117-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the HDMI version to v1.4 for all exynos5250 targets. This property
was previously being inferred by the existence of the hdmi node.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 arch/arm/boot/dts/exynos5250.dtsi |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 2e3b6ef..9fb6845 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -576,6 +576,7 @@
 		compatible = "samsung,exynos5-hdmi";
 		reg = <0x14530000 0x100000>;
 		interrupts = <0 95 0>;
+		samsung,supports-hdmi-1.4;
 	};
 
 	mixer {
-- 
1.7.7.3

