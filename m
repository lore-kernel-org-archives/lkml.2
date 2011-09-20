Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1ITQqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:46:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38190 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1ITQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:46:35 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        nicolas.pitre@linaro.org
Cc: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
Date: Tue, 20 Sep 2011 10:46:25 -0600
Message-Id: <1316537186-26753-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings were recently updated to have separate properties for each
type of GPIO. Update the Device Tree source to match that.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Olof Johansson <olof@lixom.net>
---
I'd previously sent these to Grant assuming they'd go in his dt/next branch,
but perhaps these should go in through Arnd's arm-soc next/dt branch?

 arch/arm/boot/dts/tegra-harmony.dts  |   12 ++++++------
 arch/arm/boot/dts/tegra-seaboard.dts |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index 4c05334..e581866 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -57,14 +57,14 @@
 	};
 
 	sdhci@c8000200 {
-		gpios = <&gpio 69 0>, /* cd, gpio PI5 */
-			<&gpio 57 0>, /* wp, gpio PH1 */
-			<&gpio 155 0>; /* power, gpio PT3 */
+		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
+		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
+		power-gpios = <&gpio 155 0>; /* gpio PT3 */
 	};
 
 	sdhci@c8000600 {
-		gpios = <&gpio 58 0>, /* cd, gpio PH2 */
-			<&gpio 59 0>, /* wp, gpio PH3 */
-			<&gpio 70 0>; /* power, gpio PI6 */
+		cd-gpios = <&gpio 58 0>; /* gpio PH2 */
+		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
+		power-gpios = <&gpio 70 0>; /* gpio PI6 */
 	};
 };
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 1940cae..64cedca 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -21,8 +21,8 @@
 	};
 
 	sdhci@c8000400 {
-		gpios = <&gpio 69 0>, /* cd, gpio PI5 */
-			<&gpio 57 0>, /* wp, gpio PH1 */
-			<&gpio 70 0>; /* power, gpio PI6 */
+		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
+		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
+		power-gpios = <&gpio 70 0>; /* gpio PI6 */
 	};
 };
-- 
1.7.0.4

