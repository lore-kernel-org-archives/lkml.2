Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2G2IP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:15:56 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49112 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2G2IPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:15:54 -0400
Message-ID: <5014F134.1070207@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:15:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/9] KVM: remove the unused declare
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-2000-0000-0000-00000886E36D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove it since it is not used anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 98255ce..387ecc5 100644
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

