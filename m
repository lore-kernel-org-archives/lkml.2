Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2J2RWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:22:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11453 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262Ab2J2RVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:21:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 29 Oct 2012 10:21:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/4] ARM: tegra: dts: cardhu: enable SLINK4
Date: Mon, 29 Oct 2012 22:49:39 +0530
Message-ID: <1351531180-1652-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1351531180-1652-1-git-send-email-ldewangan@nvidia.com>
References: <1351531180-1652-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable SLINK4 in Tegra30 based platform Cardhu.
Setting maximum spi frequency to 25MHz.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
rename the max freq prop to spi-max-frequency
 arch/arm/boot/dts/tegra30-cardhu.dtsi |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index b245e6c..1bd73ea 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -275,6 +275,11 @@
 		};
 	};
 
+	slink@7000da00 {
+		status = "okay";
+		spi-max-frequency = <25000000>;
+	};
+
 	ahub {
 		i2s@70080400 {
 			status = "okay";
-- 
1.7.1.1

