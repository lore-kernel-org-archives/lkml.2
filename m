Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0DLICN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:02:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0DLICJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:02:09 -0400
Message-ID: <4BC2D2E2.1030604@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 15:59:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] KVM MMU: remove unused struct
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 'struct kvm_unsync_walk' since it's not used now

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b44380b..a23ca75 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -172,11 +172,6 @@ struct kvm_shadow_walk_iterator {
 	     shadow_walk_okay(&(_walker));			\
 	     shadow_walk_next(&(_walker)))
 
-
-struct kvm_unsync_walk {
-	int (*entry) (struct kvm_mmu_page *sp, struct kvm_unsync_walk *walk);
-};
-
 typedef int (*mmu_parent_walk_fn) (struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
 
 static struct kmem_cache *pte_chain_cache;
-- 
1.6.1.2

