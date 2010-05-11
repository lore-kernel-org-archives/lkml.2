Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0EKQWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0EKQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:26 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 4/9] add new KVMCLOCK cpuid feature
Date: Tue, 11 May 2010 12:17:42 -0400
Message-Id: <1273594667-17175-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-4-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <1273594667-17175-2-git-send-email-glommer@redhat.com>
 <1273594667-17175-3-git-send-email-glommer@redhat.com>
 <1273594667-17175-4-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cpuid, KVM_CPUID_CLOCKSOURCE2, will indicate to the guest
that kvmclock is available through a new set of MSRs. The old ones
are deprecated.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9734808..f019f8c 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -16,6 +16,10 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+/* This indicates that the new set of kvmclock msrs
+ * are available. The use of 0x11 and 0x12 is deprecated
+ */
+#define KVM_FEATURE_CLOCKSOURCE2        3
 
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
-- 
1.6.2.2

