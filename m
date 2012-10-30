Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2J3KFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:05:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19529 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab2J3KFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:05:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Oct 2012 03:05:00 -0700
From: Pritesh Raithatha <praithatha@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>, <olof@lixom.net>,
        <hdoyu@nvidia.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <praithatha@nvidia.com>
Subject: [PATCH] arm: dt: tegra: fix length of pad control and mux registers
Date: Tue, 30 Oct 2012 15:37:09 +0530
Message-ID: <1351591629-671-1-git-send-email-praithatha@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: <stable@vger.kernel.org>
Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 3e4334d..3f96658 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -73,8 +73,8 @@
 
 	pinmux: pinmux {
 		compatible = "nvidia,tegra30-pinmux";
-		reg = <0x70000868 0xd0    /* Pad control registers */
-		       0x70003000 0x3e0>; /* Mux registers */
+		reg = <0x70000868 0xd4    /* Pad control registers */
+		       0x70003000 0x3e4>; /* Mux registers */
 	};
 
 	serial@70006000 {
-- 
1.7.1

