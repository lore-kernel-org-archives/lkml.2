Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934779Ab1IOUKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934488Ab1IOUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873431"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, lethal@linux-sh.org
Subject: [PATCH 08/27] Initconst section fixes for SH
Date: Thu, 15 Sep 2011 13:09:35 -0700
Message-Id: <1316117394-21666-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: lethal@linux-sh.org
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
1.7.4.4

