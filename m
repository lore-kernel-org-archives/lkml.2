Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2LMNW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:22:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60374 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2LMNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:27 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/8] ARM: ux500: Set correct MMCI regulator voltages in the ux5x0 Device Tree
Date: Thu, 13 Dec 2012 13:22:04 +0000
Message-Id: <1355404930-5691-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the voltage specified by the mmci regulator node in Device
Tree. Despite the MMC subsystem insisting on v3.3, we actually only
offer v2.9, and not v2.6 which must have actually been a typo.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 9f55363..6b1aa6d 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -634,7 +634,7 @@
 			compatible = "regulator-gpio";
 
 			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <2600000>;
+			regulator-max-microvolt = <2900000>;
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
-- 
1.7.9.5

