Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1EDSQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:16:16 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52790 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:16:14 -0400
Date: Wed, 4 May 2011 20:16:07 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 2/8] arch/x86/xen/irq: Cleanup code/data sections definitions
Message-ID: <20110504181607.GC29218@router-fw-old.local.net-space.pl>
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
 arch/x86/xen/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 6a6fe89..8bbb465 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -113,7 +113,7 @@ static void xen_halt(void)
 		xen_safe_halt();
 }
 
-static const struct pv_irq_ops xen_irq_ops __initdata = {
+static const struct pv_irq_ops xen_irq_ops __initconst = {
 	.save_fl = PV_CALLEE_SAVE(xen_save_fl),
 	.restore_fl = PV_CALLEE_SAVE(xen_restore_fl),
 	.irq_disable = PV_CALLEE_SAVE(xen_irq_disable),
-- 
1.5.6.5
