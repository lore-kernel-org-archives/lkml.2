Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2CBWZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:25:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61356 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2CBWZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:25:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.102.230 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 2/5] ARM: tegra: select CPU_FREQ_TABLE
Date: Fri,  2 Mar 2012 17:25:44 -0500
Message-Id: <1330727144-11120-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330727075-10974-1-git-send-email-alan@signal11.us>
References: <1330727075-10974-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tegra cpufreq implementation relies on the cpu_freq_table
code, so make sure that this is always there when needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/mach-tegra/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 373652d..60f3e4b 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
@@ -23,6 +24,7 @@ config ARCH_TEGRA_3x_SOC
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
 	select USE_OF
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Support for NVIDIA Tegra T30 processor family, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
-- 
1.7.0.4

