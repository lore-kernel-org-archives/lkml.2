Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1KEC3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 22:29:33 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44320 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1KEC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 22:29:32 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] ARM: EXYNOS4: Fix the merge conflict
Date: Sat,  5 Nov 2011 11:08:54 +0900
Message-Id: <1320458934-8225-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mark of conflict should be removed.

This happened at the commit fba9569924e06da076cb2ad12474bbd82d69f54d
("Merge branch 'next' of git://git.infradead.org/users/vkoul/slave-dma")

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos4/clock.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
index e21952d..a52024e 100644
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -1286,11 +1286,8 @@ void __init exynos4_register_clocks(void)
 	s3c_register_clocks(init_clocks_off, ARRAY_SIZE(init_clocks_off));
 	s3c_disable_clocks(init_clocks_off, ARRAY_SIZE(init_clocks_off));
 
-<<<<<<< HEAD
 	register_syscore_ops(&exynos4_clock_syscore_ops);
-=======
 	s3c24xx_register_clock(&dummy_apb_pclk);
 
->>>>>>> 4598fc2c94b68740e0269db03c98a1e7ad5af773
 	s3c_pwmclk_init();
 }
-- 
1.7.1

