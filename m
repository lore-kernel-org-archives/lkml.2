Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab1LPKSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:18:52 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33117 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab1LPKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:18:42 -0500
Message-ID: <4EEB1AFB.1090806@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:18:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 8/8] KVM: MMU: remove PT64_SECOND_AVAIL_BITS_SHIFT
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-8878-0000-0000-00000098C27E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5d0f0e3..234a32e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -91,7 +91,6 @@ module_param(dbg, bool, 0644);
 #define PTE_PREFETCH_NUM		8

 #define PT_FIRST_AVAIL_BITS_SHIFT 9
-#define PT64_SECOND_AVAIL_BITS_SHIFT 52

 #define PT64_LEVEL_BITS 9

-- 
1.7.7.4

