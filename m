Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1AaRaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:30:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1AaRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:30:23 -0500
Date: Mon, 31 Jan 2011 09:29:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] kernel.h: fix kernel-doc warning
Message-Id: <20110131092914.950be58f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning in kernel.h:
(from commit 7ef88ad561457c0346355dfd1f53e503ddfde719)

Warning(include/linux/kernel.h:605): No description found for parameter 'condition'
Warning(include/linux/kernel.h:605): Excess function parameter 'cond' description in 'BUILD_BUG_ON'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-rc2-git5.orig/include/linux/kernel.h
+++ linux-2.6.38-rc2-git5/include/linux/kernel.h
@@ -588,7 +588,7 @@ struct sysinfo {
 
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
- * @cond: the condition which the compiler should know is false.
+ * @condition: the condition which the compiler should know is false.
  *
  * If you have some code which relies on certain constants being equal, or
  * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
