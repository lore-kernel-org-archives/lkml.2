Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2ITMTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:19:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2ITMNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/32] ARM: ux500: Remove unused snowball_of_platform_devs struct
Date: Thu, 20 Sep 2012 14:12:27 +0200
Message-Id: <1348143170-2130-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was left over during a recent clean-up which removed Device Tree
helper structs. There is no longer a requirement for it, so we can just
remove it.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5d9600b..5d0f135 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -726,11 +726,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_UX500_DT
 
-static struct platform_device *snowball_of_platform_devs[] __initdata = {
-	&snowball_led_dev,
-	&snowball_key_dev,
-};
-
 struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
-- 
1.7.9.5

