Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2CBW0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:26:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52487 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab2CBW0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:26:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.165.34 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 4/5] ARM: tegra: select USB_ULPI if USB is selected
Date: Fri,  2 Mar 2012 17:26:00 -0500
Message-Id: <1330727160-11242-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330727075-10974-1-git-send-email-alan@signal11.us>
References: <1330727075-10974-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Automatically select USB_ULPI if USB is enabled on Tegra.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/mach-tegra/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 60f3e4b..fdef6b2 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -8,7 +8,7 @@ config ARCH_TEGRA_2x_SOC
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
-	select USB_ULPI if USB_SUPPORT
+	select USB_ULPI if USB
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
 	select CPU_FREQ_TABLE if CPU_FREQ
 	help
@@ -21,7 +21,7 @@ config ARCH_TEGRA_3x_SOC
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
-	select USB_ULPI if USB_SUPPORT
+	select USB_ULPI if USB
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
 	select USE_OF
 	select CPU_FREQ_TABLE if CPU_FREQ
-- 
1.7.0.4

