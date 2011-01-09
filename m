Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1AIDpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:45:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57806 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1AIDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:45:33 -0500
Date: Sat, 8 Jan 2011 19:38:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>
Subject: [PATCH 3/6] hrtimer.h: fix kernel-doc warning
Message-Id: <20110108193802.36387a8c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc notation warning in hrtimer.h:

Warning(include/linux/hrtimer.h:150): Excess struct/union/enum/typedef member 'first' description in 'hrtimer_clock_base'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/hrtimer.h |    1 -
 1 file changed, 1 deletion(-)

--- lnx0107.orig/include/linux/hrtimer.h
+++ lnx0107/include/linux/hrtimer.h
@@ -131,7 +131,6 @@ struct hrtimer_sleeper {
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.
  * @active:		red black tree root node for the active timers
- * @first:		pointer to the timer node which expires first
  * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
