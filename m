Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1GKThO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883Ab1GKThA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:37:00 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH v6 2/9] KVM-HDR Add constant to represent KVM MSRs enabled bit
Date: Mon, 11 Jul 2011 15:28:12 -0400
Message-Id: <1310412499-3873-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1310412499-3873-1-git-send-email-glommer@redhat.com>
References: <1310412499-3873-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is simple, put in a different commit so it can be more easily
shared between guest and hypervisor. It just defines a named constant
to indicate the enable bit for KVM-specific MSRs.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Eric B Munson <emunson@mgebm.net>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
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

