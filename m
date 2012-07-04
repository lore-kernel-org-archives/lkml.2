Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab2GDJh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:37:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3990 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2GDJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:37:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Jul 2012 02:33:14 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>, <ccross@android.com>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <arnd@arndb.de>, <grant.likely@secretlab.ca>,
        <cjb@laptop.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 2/5] ARM: dt: t20 seaboard: add pinmux, gpio for wlan
Date: Wed, 4 Jul 2012 17:34:45 +0800
Message-ID: <1341394488-13169-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341394488-13169-1-git-send-email-wni@nvidia.com>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds wlan pinmux and gpio settings to the Tegra20 Seaboard device tree.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra20-seaboard.dts |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 85e621a..f377a61 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -440,6 +440,11 @@
 		status = "okay";
 	};
 
+	sdhci@c8000000 {
+		status = "okay";
+		power-gpios = <&gpio 86 0>; /* gpio PK6 */
+	};
+
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-- 
1.7.1

