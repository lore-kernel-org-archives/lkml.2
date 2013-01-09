Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3AIKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:06:16 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43065 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab3AIKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:06:13 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] ARM: ux500: Add Snowball pin configuration for user LED
Date: Wed,  9 Jan 2013 10:06:05 +0000
Message-Id: <1357725965-27342-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we setup the GPIO pin responsible for illuminating the user
LED on the Snowball low-cost development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 0a3f30d..d1a775c 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -747,6 +747,8 @@ static struct pinctrl_map __initdata snowball_pinmap[] = {
 	DB8500_PIN_HOG("GPIO21_AB3", out_hi),
 	/* Mux in "SM" which is used for the SMSC911x Ethernet adapter */
 	DB8500_MUX_HOG("sm_b_1", "sm"),
+	/* User LED */
+	DB8500_PIN_HOG("GPIO142_C11", gpio_out_hi),
 	/* Drive RSTn_LAN high */
 	DB8500_PIN_HOG("GPIO141_C12", gpio_out_hi),
 	/*  Accelerometer/Magnetometer */
-- 
1.7.9.5

