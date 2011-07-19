Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GSWu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:50:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3880 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GSWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:50:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 15:50:14 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andrew Chew <achew@nvidia.com>
Subject: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Date: Tue, 19 Jul 2011 15:46:57 -0700
Message-ID: <1311115617-9697-3-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311115617-9697-1-git-send-email-achew@nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 arch/arm/boot/dts/tegra-seaboard.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 5a99b4c..c5a1b71 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -31,4 +31,16 @@
 	sdhci@c8000600 {
 		status = "ok";
 	};
+
+	ehci@c5000000 {
+		status = "ok";
+	};
+
+	ehci@c5004000 {
+		status = "ok";
+	};
+
+	ehci@c5008000 {
+		status = "ok";
+	};
 };
-- 
1.7.6

