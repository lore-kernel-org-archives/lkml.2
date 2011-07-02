Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1GBVzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:37 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48210 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755799Ab1GBVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ppc: there is no CONFIG_PPC_CPU
Date: Sun,  3 Jul 2011 00:47:50 +0300
Message-Id: <1309643272-364-6-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-5-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-5-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is, however, CONFIG_PPC_FPU. Seems to be a typo introduced
in cd64d1697cf079bb8a67766e36e88ced38498933.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/powerpc/lib/sstep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 9a52349..e3b28e3 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1395,7 +1395,7 @@ int __kprobes emulate_step(struct pt_regs *regs, unsigned int instr)
 				regs->gpr[rd] = byterev_4(val);
 			goto ldst_done;
 
-#ifdef CONFIG_PPC_CPU
+#ifdef CONFIG_PPC_FPU
 		case 535:	/* lfsx */
 		case 567:	/* lfsux */
 			if (!(regs->msr & MSR_FP))
-- 
1.7.2.5

