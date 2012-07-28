Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2G1B7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:59:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:62634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2G1B7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188155434"
Date: Sat, 28 Jul 2012 09:59:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>
Subject: [PATCH] xtensa: select generic atomic64_t support
Message-ID: <20120728015944.GA7697@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix build errors:

block/blk-cgroup.c:609:2: error: unknown type name 'atomic64_t'
block/blk-cgroup.c:609:2: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/xtensa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/xtensa/Kconfig	2012-07-28 09:50:02.000000000 +0800
+++ linux/arch/xtensa/Kconfig	2012-07-28 09:54:16.454865449 +0800
@@ -11,6 +11,7 @@ config XTENSA
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
+	select GENERIC_ATOMIC64
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
