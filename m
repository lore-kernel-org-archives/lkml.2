Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0KUNPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:15:09 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34291 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0KUNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:15:08 -0500
Date: Sun, 21 Nov 2010 08:15:01 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: trivial@kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix "forcably" typo.
Message-ID: <alpine.DEB.2.00.1011210814010.19629@localhost6.localdomain6>
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

  and, yes, it's the only typo of that form in the entire tree, i
checked.

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 33c270a..8f0b1ba 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -976,7 +976,7 @@ struct klist *bus_get_device_klist(struct bus_type *bus)
 EXPORT_SYMBOL_GPL(bus_get_device_klist);

 /*
- * Yes, this forcably breaks the klist abstraction temporarily.  It
+ * Yes, this forcibly breaks the klist abstraction temporarily.  It
  * just wants to sort the klist, not change reference counts and
  * take/drop locks rapidly in the process.  It does all this while
  * holding the lock for the list, so objects can't otherwise be

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
