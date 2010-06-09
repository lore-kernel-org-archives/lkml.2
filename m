Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0FILCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:02:43 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:35677 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab0FILCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:02:42 -0400
Date: Wed, 9 Jun 2010 13:02:39 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Torez Smith <lnxtorez@linux.vnet.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 5b/5] Removing dead CONFIG_PPC47x
Message-ID: <20100609110239.GA28290@faui48a.informatik.uni-erlangen.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PPC47x should actually be spelled CONFIG_PPC_47x as reported by
Andreas Schwab.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/powerpc/mm/44x_mmu.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index d8c6efb..f70da7e 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -76,11 +76,11 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
 		"tlbwe	%1,%3,%5\n"
 		"tlbwe	%0,%3,%6\n"
 	:
-#ifdef CONFIG_PPC47x
+#ifdef CONFIG_PPC_47x
 	: "r" (PPC47x_TLB2_S_RWX),
 #else
 	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
 #endif
 	  "r" (phys),
 	  "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
 	  "r" (entry),
-- 
1.6.3.3

