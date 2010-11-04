Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0KDKZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:25:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0KDKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:25:17 -0400
Message-ID: <4CD28B16.4050009@cn.fujitsu.com>
Date: Thu, 04 Nov 2010 18:29:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: remove unused function declaration
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:25:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:25:48,
	Serialize complete at 2010-11-04 18:25:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the declaration of kvm_mmu_set_base_ptes()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1be0058..7f20f2c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -611,7 +611,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
-void kvm_mmu_set_base_ptes(u64 base_pte);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
-- 
1.7.0.4
