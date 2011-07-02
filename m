Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1GBVzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:38 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48212 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755869Ab1GBVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] cris: there is no CONFIG_ETRAX_KGB_PORT2
Date: Sun,  3 Jul 2011 00:47:47 +0300
Message-Id: <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is, however, CONFIG_ETRAX_KGDB_PORT2

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/cris/arch-v32/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 5ebe6e8..f51ddd4 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -35,7 +35,7 @@
 #define IGNOREMASK (1 << (SER0_INTR_VECT - FIRST_IRQ))
 #elif defined(CONFIG_ETRAX_KGDB_PORT1)
 #define IGNOREMASK (1 << (SER1_INTR_VECT - FIRST_IRQ))
-#elif defined(CONFIG_ETRAX_KGB_PORT2)
+#elif defined(CONFIG_ETRAX_KGDB_PORT2)
 #define IGNOREMASK (1 << (SER2_INTR_VECT - FIRST_IRQ))
 #elif defined(CONFIG_ETRAX_KGDB_PORT3)
 #define IGNOREMASK (1 << (SER3_INTR_VECT - FIRST_IRQ))
-- 
1.7.2.5

