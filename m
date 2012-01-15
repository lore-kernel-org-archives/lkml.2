Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2AOUHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:07:38 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23663 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AOUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:07:37 -0500
Date: Sun, 15 Jan 2012 21:07:35 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mips@linux-mips.org
cc: linux-kernel@vger.kernel.org, Kevin Cernekee <cernekee@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, trivial@kernel.org
Subject: [PATCH] arch/mips/kernel/smp-bmips.c does not need to include
 version.h
Message-ID: <alpine.LNX.2.00.1201152105140.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'make versioncheck' nicely points out, arch/mips/kernel/smp-bmips.c
has no need to '#include <linux/version.h>'. This patch removes the
unneeded include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/mips/kernel/smp-bmips.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index 58fe71a..d5e950a 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -8,7 +8,6 @@
  * SMP support for BMIPS
  */
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

