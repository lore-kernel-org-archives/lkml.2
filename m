Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1JYT02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:26:28 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:57218 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752212Ab1JYT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:26:22 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, mtosatti@redhat.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 1/6] Add flag to indicate that a vm was stopped by the host
Date: Tue, 25 Oct 2011 15:26:14 -0400
Message-Id: <1319570779-8907-2-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
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
index 35f2d19..6167fd7 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -40,5 +40,6 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 #define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
+#define PVCLOCK_GUEST_STOPPED	(1 << 1)
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PVCLOCK_ABI_H */
-- 
1.7.5.4

