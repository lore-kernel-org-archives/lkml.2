Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1GAVbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:31:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab1GAVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:31:04 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v4 2/9] KVM-HDR Add constant to represent KVM MSRs enabled bit
Date: Fri,  1 Jul 2011 17:22:42 -0400
Message-Id: <1309555369-16867-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1309555369-16867-1-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is simple, put in a different commit so it can be more easily
shared between guest and hypervisor. It just defines a named constant
to indicate the enable bit for KVM-specific MSRs.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/kvm_para.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index a427bf7..d6cd79b 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -30,6 +30,7 @@
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
+#define KVM_MSR_ENABLED 1
 /* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
-- 
1.7.3.4

