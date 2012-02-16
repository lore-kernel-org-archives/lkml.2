Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2BPNU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:20:29 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:47410
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2BPNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:20:28 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: tony.luck@intel.com, linux-ia64@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] ia64: Fix typo in irq_xen.c
Date: Thu, 16 Feb 2012 22:20:03 +0900
Message-Id: <1329398403-1701-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "vecotr" to "vector" in
arch/ia64/xen/irq_xen.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/ia64/xen/irq_xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index b279e14..3bb1223 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -58,7 +58,7 @@ xen_free_irq_vector(int vector)
 
 	irq_op.vector = vector;
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_free_irq_vector, &irq_op))
-		printk(KERN_WARNING "%s: xen_free_irq_vecotr fail vector=%d\n",
+		printk(KERN_WARNING "%s: xen_free_irq_vector fail vector=%d\n",
 		       __func__, vector);
 }
 
-- 
1.7.4.4

