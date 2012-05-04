Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2EDGvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:51:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:2723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2EDGvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96284560"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, bp@amd64.org, npiggin@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, borislav.petkov@amd.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, yongjie.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATH v2 5/5] x86/tlb: remove comments for tlb_flush_range implement suggestion
Date: Fri,  4 May 2012 14:50:10 +0800
Message-Id: <1336114210-25687-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336114210-25687-1-git-send-email-alex.shi@intel.com>
References: <1336114210-25687-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to this comments that inspired me using invlpg to replace cr3
rewrite.
Now, it is time to remove from code to avoid reader confusing.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index ec30dfb..51f8b1c 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -81,10 +81,6 @@ static inline void __flush_tlb_one(unsigned long addr)
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
- *
- * x86-64 can only flush individual pages or full VMs. For a range flush
- * we always do the full VM. Might be worth trying if for a small
- * range a few INVLPGs in a row are a win.
  */
 
 #ifndef CONFIG_SMP
-- 
1.7.0.1

