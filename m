Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2HULqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:46:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:49253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab2HULqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:46:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,802,1336374000"; 
   d="scan'208";a="207394361"
Date: Tue, 21 Aug 2012 19:46:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] score: select generic atomic64_t support
Message-ID: <20120821114632.GB20664@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's required for the core fs/namespace.c and many other basic features.

Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/score/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/score/Kconfig	2012-08-17 11:13:49.184134240 +0800
+++ linux/arch/score/Kconfig	2012-08-21 19:38:07.920760628 +0800
@@ -10,6 +10,7 @@ config SCORE
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
+       select GENERIC_ATOMIC64
 
 choice
 	prompt "System type"
