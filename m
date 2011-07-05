Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1GEUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:23:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56072 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1GEUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:23:35 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: tegra: Harmony: Use engineering names in DT compatible property
Date: Tue,  5 Jul 2011 14:23:28 -0600
Message-Id: <1309897408-23085-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Engineering names are more stable than marketing names. Hence, use them
for Device Tree compatible properties instead.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Grant, this is against devicetree/arm, and only makes sense there; I'll
send a separate patch for the equivalent change in devicetree/test, since
the file is radically different there.

 arch/arm/boot/dts/tegra-harmony.dts |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index 81032e7..4ad8ade 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -3,5 +3,5 @@
 
 / {
 	model = "NVIDIA Tegra2 Harmony evaluation board";
-	compatible = "nvidia,harmony", "nvidia,tegra250";
+	compatible = "nvidia,harmony", "nvidia,tegra20";
 };
-- 
1.7.0.4

