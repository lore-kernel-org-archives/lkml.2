Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2BAVE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:04:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13625 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2BAVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:04:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 01 Feb 2012 13:04:54 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/4] ARM: tegra: Select PINCTRL Kconfig variables
Date: Wed,  1 Feb 2012 14:04:48 -0700
Message-Id: <1328130290-17607-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes the Tegra pinctrl driver to be built whenever core Tegra
support is enabled.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-tegra/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 373652d..32b420a 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -7,6 +7,8 @@ config ARCH_TEGRA_2x_SOC
 	select CPU_V7
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
+	select PINCTRL
+	select PINCTRL_TEGRA20
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
@@ -19,6 +21,8 @@ config ARCH_TEGRA_3x_SOC
 	select CPU_V7
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
+	select PINCTRL
+	select PINCTRL_TEGRA30
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
-- 
1.7.0.4

