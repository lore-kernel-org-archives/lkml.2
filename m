Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1J1Q2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:28:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12977 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1J1Q2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:28:07 -0400
From: Taylor Hutt <thutt@chromium.org>
To: thutt@chromium.org
Cc: swarren@nvidia.com, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yufeng Shen <miletus@chromium.org>
Subject: [PATCH] arch: arm: tegra: Enable headphone detection gpio
Date: Fri, 28 Oct 2011 09:27:06 -0700
Message-Id: <1319819226-19098-1-git-send-email-thutt@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yufeng Shen <miletus@chromium.org>

Enable the headphone detection gpio on tegra platform.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 arch/arm/mach-tegra/board-seaboard-pinmux.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 9d0ba80..14e9d576 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -205,6 +205,7 @@ static struct tegra_gpio_table common_gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_NCT1008_THERM2_IRQ,.enable = true },
 	{ .gpio = TEGRA_GPIO_WLAN_POWER,	.enable = true },
 	{ .gpio = TEGRA_GPIO_AC_ONLINE,		.enable = true },
+	{ .gpio = TEGRA_GPIO_HP_DET,		.enable = true },
 	{ .gpio = TEGRA_GPIO_MXT_IRQ,		.enable = true },
 	{ .gpio = TEGRA_GPIO_HDMI_ENB,		.enable = true },
 	{ .gpio = TEGRA_GPIO_MPU3050_IRQ,	.enable = true },
-- 
1.7.3.1

