Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2E1Ldj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:33:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:61054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2E1Ldi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="149221412"
From: Xudong Hao <xudong.hao@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        xiantao.zhang@intel.com, Xudong Hao <xudong.hao@intel.com>,
        Haitao Shan <haitao.shan@intel.com>
Subject: [PATCH v3 1/4] Add EPT A/D bits definitions.
Date: Mon, 28 May 2012 19:33:34 +0800
Message-Id: <1338204816-20654-1-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EPT A/D bits definitions.

Signed-off-by: Haitao Shan <haitao.shan@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 arch/x86/include/asm/vmx.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..de007c2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -404,6 +404,7 @@ enum vmcs_field {
 #define VMX_EPTP_WB_BIT				(1ull << 14)
 #define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
 #define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
+#define VMX_EPT_AD_BIT					(1ull << 21)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
@@ -415,11 +416,14 @@ enum vmcs_field {
 #define VMX_EPT_MAX_GAW				0x4
 #define VMX_EPT_MT_EPTE_SHIFT			3
 #define VMX_EPT_GAW_EPTP_SHIFT			3
+#define VMX_EPT_AD_ENABLE_BIT			(1ull << 6)
 #define VMX_EPT_DEFAULT_MT			0x6ull
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
+#define VMX_EPT_ACCESS_BIT				(1ull << 8)
+#define VMX_EPT_DIRTY_BIT				(1ull << 9)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 
-- 
1.7.1

