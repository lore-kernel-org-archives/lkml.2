Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1COAOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 20:14:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19878 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1COAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 20:14:34 -0400
Date: Tue, 15 Mar 2011 01:14:14 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: Deepak Saxena <dsaxena@mvista.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][Trivial] ARM: Remove duplicate linux/sched.h include from
 arch/arm/plat-iop/time.c
Message-ID: <alpine.LNX.2.00.1103150108510.26293@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to include linux/sched.h more than once 
in arch/arm/plat-iop/time.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 time.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 07f23bb..7cdc516 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -17,7 +17,6 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 #include <linux/timex.h>
 #include <linux/sched.h>
 #include <linux/io.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

