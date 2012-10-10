Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2JJPUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:20:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab2JJPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] ARM: ux500: Remove unused board compatible string
Date: Wed, 10 Oct 2012 16:18:50 +0100
Message-Id: <1349882335-6786-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'st-ericsson,u8500' is too much of a broad name to be used for
any of the supported development boards supported by ST-Ericsson.
As such it was never used. It has no place to remain in the board
compatible list, hence why it's being removed.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 9f87b4d..3d8e321 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -330,7 +330,6 @@ static void __init u8500_init_machine(void)
 static const char * u8500_dt_board_compat[] = {
 	"calaosystems,snowball-a9500",
 	"st-ericsson,hrefv60+",
-	"st-ericsson,u8500",
 	"st-ericsson,mop500",
 	NULL,
 };
-- 
1.7.9.5

