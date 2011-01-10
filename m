Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1AJUnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:43:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14585 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1AJUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:43:14 -0500
Date: Mon, 10 Jan 2011 21:43:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] rcutorture: Get rid of duplicate sched.h include
Message-ID: <alpine.LNX.2.00.1101102141230.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


linux/sched.h is included twice in kernel/rcutorture.c - once is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 rcutorture.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 89613f9..c224da4 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -47,7 +47,6 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <linux/sched.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

