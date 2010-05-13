Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0EMCML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:12:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab0EMCMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:12:09 -0400
Message-ID: <4BEB5F38.1070508@cn.fujitsu.com>
Date: Thu, 13 May 2010 10:08:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] KVM MMU: fix two typos
References: <4BEB5E8A.7030606@cn.fujitsu.com> <4BEB5EC4.6070802@cn.fujitsu.com> <4BEB5F08.3010604@cn.fujitsu.com>
In-Reply-To: <4BEB5F08.3010604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix two typos in next branch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a474d93..68f79b0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2070,7 +2070,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = 0;
 		}
 		spin_lock(&vcpu->kvm->mmu_lock);
-		kvm_mmu_free_some_pages(vcpu->kvm);
+		kvm_mmu_free_some_pages(vcpu);
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
 				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
@@ -2101,7 +2101,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = i << 30;
 		}
 		spin_lock(&vcpu->kvm->mmu_lock);
-		kvm_mmu_free_some_pages(vcpu->kvm);
+		kvm_mmu_free_some_pages(vcpu);
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
-- 
1.6.1.2


