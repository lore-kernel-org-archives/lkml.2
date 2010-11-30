Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0K3LbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:31:14 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:42187 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0K3LbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:31:13 -0500
Date: Tue, 30 Nov 2010 06:31:07 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] DOCUMENTATION: Correct inline docs to match parm name.
Message-ID: <alpine.DEB.2.00.1011300629580.21294@localhost6.localdomain6>
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


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  the actual parameter name is "parent", not "dparent".


diff --git a/fs/dcache.c b/fs/dcache.c
index 23702a9..eaebae4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1485,7 +1485,7 @@ out:
 /**
  * d_validate - verify dentry provided from insecure source
  * @dentry: The dentry alleged to be valid child of @dparent
- * @dparent: The parent dentry (known to be valid)
+ * @parent: The parent dentry (known to be valid)
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
