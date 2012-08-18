Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2HRRbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:60444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab2HRRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330065"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/31] sections: Fix section conflicts in arch/sh
Date: Sat, 18 Aug 2012 10:30:00 -0700
Message-Id: <1345311022-26328-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/sh/kernel/ioport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/ioport.c b/arch/sh/kernel/ioport.c
index e3ad610..cca14ba 100644
--- a/arch/sh/kernel/ioport.c
+++ b/arch/sh/kernel/ioport.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 
-const unsigned long sh_io_port_base __read_mostly = -1;
+unsigned long sh_io_port_base __read_mostly = -1;
 EXPORT_SYMBOL(sh_io_port_base);
 
 void __iomem *__ioport_map(unsigned long addr, unsigned int size)
-- 
1.7.7.6

