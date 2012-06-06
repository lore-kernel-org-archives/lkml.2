Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2FFRXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:23:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33572 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2FFRXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:23:31 -0400
Message-ID: <201206061723.q56HNTcW016219@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 6 Jun 2012 11:23:19 -0400
Subject: [PATCH] tile: add #include to unbreak build after generic init_task conversion
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code was moved from init_task.c to setup.c but the appropriate
header needed to be moved as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6098ccc..dd87f34 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -29,6 +29,7 @@
 #include <linux/smp.h>
 #include <linux/timex.h>
 #include <linux/hugetlb.h>
+#include <linux/start_kernel.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
-- 
1.6.5.2

