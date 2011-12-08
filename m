Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1LHWNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:13:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57291 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1LHWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:13:26 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC 2/3] arm/tegra: Select PINMUX Kconfig variables
Date: Thu,  8 Dec 2011 15:13:09 -0700
Message-Id: <1323382390-14892-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXME: This needs to be rebased on top of the T30 support so that
T20 doesn't select the T30 pinmux driver.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
DO NOT MERGE this: The FIXME in the commit comment needs to be addressed
first.

 arch/arm/mach-tegra/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 91aff7c..b548688 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -13,6 +13,9 @@ config ARCH_TEGRA_2x_SOC
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_SUPPORT
 	select USB_ULPI_VIEWPORT if USB_SUPPORT
+	select PINCTRL
+	select PINCTRL_TEGRA20
+	select PINCTRL_TEGRA30
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
-- 
1.7.0.4

