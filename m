Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413Ab2CUG5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:57:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030281Ab2CUG45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:56:57 -0400
Subject: [PATCH 10/16] mm/powerpc: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 21 Mar 2012 10:56:54 +0400
Message-ID: <20120321065653.13852.20099.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/mman.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/mman.h b/arch/powerpc/include/asm/mman.h
index d4a7f64..451de1c 100644
--- a/arch/powerpc/include/asm/mman.h
+++ b/arch/powerpc/include/asm/mman.h
@@ -44,7 +44,7 @@ static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot)
 }
 #define arch_calc_vm_prot_bits(prot) arch_calc_vm_prot_bits(prot)
 
-static inline pgprot_t arch_vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t arch_vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return (vm_flags & VM_SAO) ? __pgprot(_PAGE_SAO) : __pgprot(0);
 }

