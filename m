Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1EDSTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:19:25 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52832 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1EDSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:19:24 -0400
Date: Wed, 4 May 2011 20:19:15 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 7/8] arch/x86/xen/xen-ops: Cleanup code/data sections definitions
Message-ID: <20110504181915.GH29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/xen-ops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 3112f55..97dfdc8 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -74,7 +74,7 @@ static inline void xen_hvm_smp_init(void) {}
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init xen_init_spinlocks(void);
-__cpuinit void xen_init_lock_cpu(int cpu);
+void __cpuinit xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 #else
 static inline void xen_init_spinlocks(void)
-- 
1.5.6.5
