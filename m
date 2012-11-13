Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2KMFGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:06:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13971 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2KMFGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:06:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Nov 2012 21:06:32 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] ARM: tegra: dts: add sflash controller dt entry
Date: Tue, 13 Nov 2012 10:33:39 +0530
Message-ID: <1352783021-25393-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com>
References: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nvidia's Tegra20 have the SPI (SFLASH) controller to
interface with spi flash device which is used for system
boot. Add DT entry for this controller.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 71a650d..32cb09d 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -195,6 +195,16 @@
 		status = "disabled";
 	};
 
+	spi@7000c380 {
+		compatible = "nvidia,tegra20-sflash";
+		reg = <0x7000c380 0x80>;
+		interrupts = <0 39 0x04>;
+		nvidia,dma-request-selector = <&apbdma 11>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	spi@7000d400 {
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d400 0x200>;
-- 
1.7.1.1

