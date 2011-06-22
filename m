Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1FVOdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:33:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab1FVOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:33:53 -0400
Message-ID: <4E01FDC7.9050802@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:35:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 20/22] KVM: MMU: reorganize struct kvm_shadow_walk_iterator
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:26,
	Serialize complete at 2011-06-22 22:33:26
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
index dad7ad9..1319050 100644
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

