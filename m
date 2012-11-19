Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2KSFj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:39:56 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58858 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2KSF3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:32 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 15/58] kernel/time/timekeeping.c: Include tick-internal.h for do_timer prototype
Date: Sun, 18 Nov 2012 21:27:54 -0800
Message-Id: <1353302917-13995-16-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.
This keeps the types in sync, and eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e424970..4d0a195 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 
+#include "tick-internal.h"
 
 static struct timekeeper timekeeper;
 
-- 
1.7.10.4

