Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2HIP5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:57:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49241 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2HIP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:57:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Remove unused snowball_of_platform_devs struct
Date: Thu,  9 Aug 2012 16:57:07 +0100
Message-Id: <1344527828-6283-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was left over during a recent clean-up which removed Device Tree
helper structs. There is no longer a requirement for it, so we can just
remove it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a93b147..de10f8f 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -725,11 +725,6 @@ MACHINE_END
 
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

