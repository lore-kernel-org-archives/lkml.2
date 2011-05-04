Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1EDSR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:17:29 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52808 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1EDSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:17:28 -0400
Date: Wed, 4 May 2011 20:17:21 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 4/8] arch/x86/xen/setup: Cleanup code/data sections definitions
Message-ID: <20110504181721.GE29218@router-fw-old.local.net-space.pl>
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
 arch/x86/xen/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 90bac0a..d3663df 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -50,7 +50,7 @@ phys_addr_t xen_extra_mem_start, xen_extra_mem_size;
  */
 #define EXTRA_MEM_RATIO		(10)
 
-static __init void xen_add_extra_mem(unsigned long pages)
+static void __init xen_add_extra_mem(unsigned long pages)
 {
 	unsigned long pfn;
 
@@ -336,7 +336,7 @@ static void __init fiddle_vdso(void)
 #endif
 }
 
-static __cpuinit int register_callback(unsigned type, const void *func)
+static int __cpuinit register_callback(unsigned type, const void *func)
 {
 	struct callback_register callback = {
 		.type = type,
-- 
1.5.6.5
