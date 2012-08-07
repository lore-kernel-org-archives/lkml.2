Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2HGHnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:43:40 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46989 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2HGHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:43:11 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        KVM <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 07 Aug 2012 13:10:13 +0530
Message-Id: <20120807074013.20169.18748.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
References: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH 2/3] Documentation/header : Correct vmrun to vmcall typo
x-cbid: 12080707-1618-0000-0000-000002364D1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 arch/x86/include/asm/kvm_para.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 2f7712e..20f5697 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -116,7 +116,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
 
-/* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
+/* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
  * instructions are guaranteed to be supported.
  *

