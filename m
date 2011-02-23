Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1BWFnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:43:45 -0500
Received: from mail.perches.com ([173.55.12.10]:3855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab1BWFmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 13/18] MAINTAINERS: Update SCX200 file pattern
Date: Tue, 22 Feb 2011 21:42:06 -0800
Message-Id: <e471646b321e09e4df3ab1aa92a23fba49c1ca80.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3b3da9d25ae9d8cac99302ad66834499cf324d08
("x86: Move scx200 to platform")
moved it, convert the pattern too.

cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e4d58d..085774c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5464,7 +5464,7 @@ SCx200 CPU SUPPORT
 M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Odd Fixes
 F:	Documentation/i2c/busses/scx200_acb
-F:	arch/x86/kernel/scx200_32.c
+F:	arch/x86/platform/scx200/
 F:	drivers/watchdog/scx200_wdt.c
 F:	drivers/i2c/busses/scx200*
 F:	drivers/mtd/maps/scx200_docflash.c
-- 
1.7.4.rc3

