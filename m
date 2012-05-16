Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967217Ab2EPBCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:02:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:27394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932Ab2EPBCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:02:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143665783"
Date: Wed, 16 May 2012 09:06:24 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 1/4] Add EPT A/D bits definitions
Message-ID: <20120516010624.GB14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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
 #define VMX_EPTP_WB_BIT                (1ull << 14)
 #define VMX_EPT_2MB_PAGE_BIT           (1ull << 16)
 #define VMX_EPT_1GB_PAGE_BIT           (1ull << 17)
+#define VMX_EPT_AD_BIT                 (1ull << 21)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT      (1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT     (1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT      (1ull << 26)
@@ -415,11 +416,14 @@ enum vmcs_field {
 #define VMX_EPT_MAX_GAW                0x4
 #define VMX_EPT_MT_EPTE_SHIFT          3
 #define VMX_EPT_GAW_EPTP_SHIFT         3
+#define VMX_EPT_AD_ENABLE_BIT          (1ull << 6)
 #define VMX_EPT_DEFAULT_MT         0x6ull
 #define VMX_EPT_READABLE_MASK          0x1ull
 #define VMX_EPT_WRITABLE_MASK          0x2ull
 #define VMX_EPT_EXECUTABLE_MASK            0x4ull
 #define VMX_EPT_IPAT_BIT               (1ull << 6)
+#define VMX_EPT_ACCESS_BIT             (1ull << 8)
+#define VMX_EPT_DIRTY_BIT              (1ull << 9)

 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR        0xfffbc000ul

--
1.7.1

