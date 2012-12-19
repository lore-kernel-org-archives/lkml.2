Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2LSO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:57:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5423 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2LSO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:57:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 19 Dec 2012 06:57:22 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra30: tegra30 gpio is not compatible with tegra20 gpio
Date: Wed, 19 Dec 2012 20:27:12 +0530
Message-ID: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra30 gpio controller is not compatible with the tegra20 due to
their bank stride i.e. Tegra20 bank stride is 0x80 where Tegra30
bank stride is 0x100.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 80a0edf..dfa9f57 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -176,7 +176,7 @@
 	};
 
 	gpio: gpio {
-		compatible = "nvidia,tegra30-gpio", "nvidia,tegra20-gpio";
+		compatible = "nvidia,tegra30-gpio"
 		reg = <0x6000d000 0x1000>;
 		interrupts = <0 32 0x04
 			      0 33 0x04
-- 
1.7.1.1

