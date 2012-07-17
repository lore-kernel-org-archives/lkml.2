Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2GQNzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:55:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51237 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2GQNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:55:41 -0400
Message-ID: <50056ED6.5080907@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:55:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 8/9] KVM: remove is_error_hpa
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-6102-0000-0000-000001E43A7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove them since they are not used anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bafcc56..f1ef5fc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -378,10 +378,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }

-#define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
-#define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
-static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
-
 extern struct page *bad_page;

 int is_error_page(struct page *page);
-- 
1.7.7.6

