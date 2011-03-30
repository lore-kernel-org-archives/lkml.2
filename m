Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab1C3VND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:13:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:41554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965335Ab1C3VKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903737218"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, andre.przywara@amd.com, avi@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [269/275] KVM: enlarge number of possible CPUID leaves
Message-Id: <20110330210836.D6EBF3E1A07@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andre Przywara <andre.przywara@amd.com>

commit 73c1160ce377d8fc6d84cb630ebf9658808bec49 upstream.

Currently the number of CPUID leaves KVM handles is limited to 40.
My desktop machine (AthlonII) already has 35 and future CPUs will
expand this well beyond the limit. Extend the limit to 80 to make
room for future processors.

KVM-Stable-Tag.
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/include/asm/kvm_host.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/kvm_host.h	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/arch/x86/include/asm/kvm_host.h	2011-03-29 23:53:33.373683727 -0700
@@ -77,7 +77,7 @@
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
-#define KVM_MAX_CPUID_ENTRIES 40
+#define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
