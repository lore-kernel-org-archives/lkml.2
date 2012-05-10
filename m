Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2EJUx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:53:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4928 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab2EJUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:53:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 May 2012 13:53:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <olof@lixom.net>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/4] ARM: dt: tegra: cardhu: register core regulator tps62360
Date: Fri, 11 May 2012 02:19:39 +0530
Message-ID: <1336682979-11810-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336682979-11810-1-git-send-email-ldewangan@nvidia.com>
References: <1336682979-11810-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device info for the core regulator tps62360 in tegra-cardhu
dts file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
No change from V1.
 arch/arm/boot/dts/tegra-cardhu.dts |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
index facb950..19b6e93 100644
--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -123,6 +123,20 @@
 			micdet-delay = <100>;
 			gpio-cfg = <0xffffffff 0xffffffff 0 0xffffffff 0xffffffff>;
 		};
+
+		tps62360 {
+			compatible = "ti,tps62361";
+			reg = <0x60>;
+
+			regulator-name = "tps62361-vout";
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+			ti,vsel0-state-high;
+			ti,vsel1-state-high;
+		};
+
 	};
 
 	sdhci@78000000 {
-- 
1.7.1.1

