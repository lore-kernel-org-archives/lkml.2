Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1KSJMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:12:53 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40496 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1KSJMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:12:49 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] kernel/power/main.c : Fix indentation and remove extraneous
 whitespaces
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Sat, 19 Nov 2011 14:42:41 +0530
Message-ID: <20111119091233.27293.34295.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111909-5564-0000-0000-0000002B94EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lack of proper indentation of the goto statement decreases the readability
of code significantly. In fact, this made me look twice at the code to check
whether it really does what it should be doing. Fix this.

And in the same file, there are some extra whitespaces. Get rid of them too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 71f49fe..670fb08 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Open Source Development Lab
- * 
+ *
  * This file is released under the GPLv2
  *
  */
@@ -240,7 +240,7 @@ struct kobject *power_kobj;
  *	'standby' (Power-On Suspend), 'mem' (Suspend-to-RAM), and
  *	'disk' (Suspend-to-Disk).
  *
- *	store() accepts one of those strings, translates it into the 
+ *	store() accepts one of those strings, translates it into the
  *	proper enumerated value, and initiates a suspend transition.
  */
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -282,7 +282,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 	/* First, check if we are requested to hibernate */
 	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
-  goto Exit;
+		goto Exit;
 	}
 
 #ifdef CONFIG_SUSPEND

