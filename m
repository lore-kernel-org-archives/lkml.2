Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1GTTls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:41:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1770 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1GTTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:41:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jul 2011 12:41:36 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 3/3 v2] dt: tegra20: Add ehci overrides to Seaboard.
Date: Wed, 20 Jul 2011 12:38:10 -0700
Message-ID: <1311190690-18334-3-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311190690-18334-1-git-send-email-achew@nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Seaboard has different values for some of the utmi properties.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 arch/arm/boot/dts/tegra-seaboard.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 5a99b4c..f8737ed 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -31,4 +31,16 @@
 	sdhci@c8000600 {
 		status = "ok";
 	};
+
+	ehci@c5000000 {
+		hssync_start_delay = < 0 >;
+		xcvr_setup = < 15 >;
+		xcvr_lsfslew = < 2 >;
+		xcvr_lsrslew = < 2 >;
+	};
+
+	ehci@c5008000 {
+		hssync_start_delay = < 0 >;
+		xcvr_setup = < 8 >;
+	};
 };
-- 
1.7.6

