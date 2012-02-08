Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2BHMx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:53:56 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50367
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932117Ab2BHMxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:53:55 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mips: Fix typo in traps.c
Date: Wed,  8 Feb 2012 21:53:14 +0900
Message-Id: <1328705594-2533-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "Schedulier" to "Scheduler" in
arch/mips/kernel/traps.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index cc4a3f1..d79ae54 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1135,7 +1135,7 @@ asmlinkage void do_mt(struct pt_regs *regs)
 		printk(KERN_DEBUG "YIELD Scheduler Exception\n");
 		break;
 	case 5:
-		printk(KERN_DEBUG "Gating Storage Schedulier Exception\n");
+		printk(KERN_DEBUG "Gating Storage Scheduler Exception\n");
 		break;
 	default:
 		printk(KERN_DEBUG "*** UNKNOWN THREAD EXCEPTION %d ***\n",
-- 
1.7.6.5

