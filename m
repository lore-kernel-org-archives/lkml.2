Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1EGVS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 17:18:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34483 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1EGVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 17:18:27 -0400
Date: Sat, 7 May 2011 17:18:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] SYSFS: Fix erroneous comments for sysfs_update_group().
Message-ID: <alpine.DEB.2.00.1105071716180.25593@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix what is clearly a simple copy-and-paste error in commenting the
sysfs_update_group() routine.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c8769dc..194414f 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -101,9 +101,9 @@ int sysfs_create_group(struct kobject *kobj,
 }

 /**
- * sysfs_update_group - given a directory kobject, create an attribute group
- * @kobj:	The kobject to create the group on
- * @grp:	The attribute group to create
+ * sysfs_update_group - given a directory kobject, update an attribute group
+ * @kobj:	The kobject to update the group on
+ * @grp:	The attribute group to update
  *
  * This function updates an attribute group.  Unlike
  * sysfs_create_group(), it will explicitly not warn or error if any

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
