Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab1F3IZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:25:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758747Ab1F3IZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:25:05 -0400
Message-ID: <4E0C3352.9010402@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:26:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 17/19] KVM: MMU: reorganize struct kvm_shadow_walk_iterator
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:24:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:24:31,
	Serialize complete at 2011-06-30 16:24:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize it for good using the cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cf02f0e..2ecbffb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -172,8 +172,8 @@ struct pte_list_desc {
 struct kvm_shadow_walk_iterator {
 	u64 addr;
 	hpa_t shadow_addr;
-	int level;
 	u64 *sptep;
+	int level;
 	unsigned index;
 };
 
-- 
1.7.5.4

