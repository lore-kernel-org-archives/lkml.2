Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab2FBUgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:36:47 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:52367 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab2FBUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/5] h8300/time: Add missing #include <asm/irq_regs.h>
Date: Sat,  2 Jun 2012 22:35:37 +0200
Message-Id: <1338669339-23214-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/kernel/time.c: In function 'h8300_timer_tick':
arch/h8300/kernel/time.c:39:2: error: implicit declaration of function 'get_irq_regs' [-Werror=implicit-function-declaration]
arch/h8300/kernel/time.c:39:42: error: invalid type argument of '->' (have 'int')

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/kernel/time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 32263a1..e0f7419 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -27,6 +27,7 @@
 #include <linux/profile.h>
 
 #include <asm/io.h>
+#include <asm/irq_regs.h>
 #include <asm/timer.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
-- 
1.7.0.4

