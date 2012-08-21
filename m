Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2HULsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:48:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:11759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044Ab2HULsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,802,1336374000"; 
   d="scan'208";a="207394779"
Date: Tue, 21 Aug 2012 19:47:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: guanxuetao@mprc.pku.edu.cn, "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] unicore32: select generic atomic64_t support
Message-ID: <20120821114737.GC20664@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's required for the core fs/namespace.c and many other basic features.

CC: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/unicore32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/unicore32/Kconfig	2012-08-17 11:13:49.184134240 +0800
+++ linux/arch/unicore32/Kconfig	2012-08-21 19:38:15.204760801 +0800
@@ -14,6 +14,7 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
+	select GENERIC_ATOMIC64
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
