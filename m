Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0HIXdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:33:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab0HIXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:33:17 -0400
Date: Mon, 9 Aug 2010 16:32:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH resend] kernel/timer.c: fix kernel-doc function parameter
 warning
Message-Id: <20100809163250.e81790e9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning, add @timer description:
Warning(kernel/timer.c:335): No description found for parameter 'timer'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.35-git8.orig/kernel/timer.c
+++ linux-2.6.35-git8/kernel/timer.c
@@ -326,6 +326,7 @@ EXPORT_SYMBOL_GPL(round_jiffies_up_relat
 
 /**
  * set_timer_slack - set the allowed slack for a timer
+ * @timer: the timer to be modified
  * @slack_hz: the amount of time (in jiffies) allowed for rounding
  *
  * Set the amount of time, in jiffies, that a certain timer has
