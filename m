Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2DJMYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:24:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:33538 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2DJMYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129136469"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] irq_domain: correct the debugfs file name
Date: Tue, 10 Apr 2012 15:25:42 +0300
Message-Id: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual name of the irq_domain mapping debugfs file is
"irq_domain_mapping" not "virq_mapping".

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 kernel/irq/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index cf1a4a6..d1a758b 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -62,7 +62,7 @@ config IRQ_DOMAIN_DEBUG
 	help
 	  This option will show the mapping relationship between hardware irq
 	  numbers and Linux irq numbers. The mapping is exposed via debugfs
-	  in the file "virq_mapping".
+	  in the file "irq_domain_mapping".
 
 	  If you don't know what this means you don't need it.
 
-- 
1.7.9.1

