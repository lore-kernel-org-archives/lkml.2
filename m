Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1AFAf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:35:57 -0500
Received: from kroah.org ([198.145.64.141]:36094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab1AFAbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:44 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.523532624@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andre Przywara <andre.przywara@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [136/152] KVM: enlarge number of possible CPUID leaves
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -79,7 +79,7 @@
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
-#define KVM_MAX_CPUID_ENTRIES 40
+#define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 


