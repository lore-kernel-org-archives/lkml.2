Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1HCOZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:25:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47899 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1HCOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:25:07 -0400
From: Eric B Munson <emunson@mgebm.net>
To: kvm@vger.kernel.org
Cc: kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org, avi@redhat.com,
        riel@redhat.com, glommer@redhat.com, linux-kernel@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [RFC PATCH 1/3] Add flag to indicate that a vm was stopped by the host
Date: Wed,  3 Aug 2011 10:24:59 -0400
Message-Id: <1312381501-27746-2-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
References: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag will be used to check if the vm was stopped by the host when a soft
lockup was detected.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/pvclock-abi.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
index 35f2d19..10e738a 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -40,5 +40,6 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 #define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
+#define PVCLOCK_STOPPED		(1 << 1)
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PVCLOCK_ABI_H */
-- 
1.7.4.1

