Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2HGJwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:52:23 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35261 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2HGJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:52:21 -0400
Message-ID: <5020E54D.9060004@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:52:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 07/12] KVM: introduce KVM_PFN_ERR_RO_FAULT
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-4790-0000-0000-00000407037C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the later patch, it indicates failure when we try to get a writable
pfn from the readonly memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 187c9c8..8306f24 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -60,6 +60,7 @@
 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_BAD		(KVM_PFN_ERR_MASK + 2)
+#define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 3)

 static inline bool is_error_pfn(pfn_t pfn)
 {
-- 
1.7.7.6

