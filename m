Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1GUD1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 23:27:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9717 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1GUD05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 23:26:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Jul 2011 20:26:49 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 3/3 v3] dt: tegra20: Add ehci overrides to Seaboard.
Date: Wed, 20 Jul 2011 20:23:39 -0700
Message-ID: <1311218619-11174-3-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311218619-11174-1-git-send-email-achew@nvidia.com>
References: <1311218619-11174-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Seaboard has different values for some of the utmi properties.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-seaboard.dts |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 5a99b4c..adc000a 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -31,4 +31,21 @@
 	sdhci@c8000600 {
 		status = "ok";
 	};
+
+	ehci@c5000000 {
+		power-down-on-bus-suspend;
+		nvidia,hssync-start-delay = < 0 >;
+		nvidia,xcvr-setup = < 15 >;
+	};
+
+	ehci@c5004000 {
+		power-down-on-bus-suspend;
+		phy-type = "ulpi";
+	};
+
+	ehci@c5008000 {
+		power-down-on-bus-suspend;
+		nvidia,hssync-start-delay = < 0 >;
+		nvidia,xcvr-setup = < 8 >;
+	};
 };
-- 
1.7.6

