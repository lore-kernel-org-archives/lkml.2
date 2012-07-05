Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2GEJ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:56:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13494 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2GEJ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:56:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jul 2012 02:52:20 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <olof@lixom.net>, <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v3 3/6] ARM: tegra: Rename tegra20 clock file
Date: Thu, 5 Jul 2012 15:25:17 +0530
Message-ID: <1341482120-3317-4-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com>
References: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the name consistent with other files.
s/tegra2/tegra20

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/Makefile                       |    2 +-
 .../{tegra2_clocks.c => tegra20_clocks.c}          |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/arm/mach-tegra/{tegra2_clocks.c => tegra20_clocks.c} (100%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 1ab285b..4d5214f 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -11,7 +11,7 @@ obj-y					+= flowctrl.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_CPU_IDLE)			+= sleep.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks_data.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra20_clocks.c
similarity index 100%
rename from arch/arm/mach-tegra/tegra2_clocks.c
rename to arch/arm/mach-tegra/tegra20_clocks.c
-- 
1.7.4.1

