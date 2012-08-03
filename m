Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2HCHky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:40:54 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:57743 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2HCHkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:40:49 -0400
Message-ID: <501B8077.8090200@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:40:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 06/10] KVM: remove the unused declare
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-4790-0000-0000-000003F9394F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove it since it is not used anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f604d1d..bdf2182 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -410,8 +410,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }

-extern struct page *bad_page;
-
 int is_error_page(struct page *page);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
-- 
1.7.7.6

