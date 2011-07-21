Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1GUVVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:21:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15375 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1GUVVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:21:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Jul 2011 14:21:01 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 3/3 v4] dt: tegra20: Add ehci overrides to Seaboard.
Date: Thu, 21 Jul 2011 14:17:47 -0700
Message-ID: <1311283067-18952-3-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311283067-18952-1-git-send-email-achew@nvidia.com>
References: <1311283067-18952-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Seaboard has different values for some of the utmi properties.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Olof Johansson <olof@lixom.net>
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

