Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2HRRcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab2HRRaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354050"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 23/31] sections: Fix section conflicts in drivers/net/wan
Date: Sat, 18 Aug 2012 10:30:14 -0700
Message-Id: <1345311022-26328-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/wan/z85230.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 0e57690..feacc3b 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1775,7 +1775,7 @@ EXPORT_SYMBOL(z8530_queue_xmit);
 /*
  *	Module support
  */
-static const char banner[] __initdata =
+static const char banner[] __initconst =
 	KERN_INFO "Generic Z85C30/Z85230 interface driver v0.02\n";
 
 static int __init z85230_init_driver(void)
-- 
1.7.7.6

