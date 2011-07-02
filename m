Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1GBVzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:44 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48219 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755885Ab1GBVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:30 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ppc: there is no CONFIG_PPC47x
Date: Sun,  3 Jul 2011 00:47:49 +0300
Message-Id: <1309643272-364-5-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is, however, CONFIG_PPC_47x.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/powerpc/mm/44x_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 024acab..c95d6be 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -78,7 +78,7 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
 		"tlbwe	%1,%3,%5\n"
 		"tlbwe	%0,%3,%6\n"
 	:
-#ifdef CONFIG_PPC47x
+#ifdef CONFIG_PPC_47x
 	: "r" (PPC47x_TLB2_S_RWX),
 #else
 	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
-- 
1.7.2.5

