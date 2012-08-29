Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2H2QBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:01:23 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38266 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2H2QBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:01:21 -0400
X-Greylist: delayed 4423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2012 12:01:20 EDT
Date: Wed, 29 Aug 2012 10:47:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] KBUILD: Drop exporting an empty irqnr.h.
Message-ID: <alpine.DEB.2.02.1208291043310.15542@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
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


Since the content of irqnr.h is entirely wrapped in a __KERNEL__ test,
drop exporting it, and remove the single include of that header from
random.h.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index fa21760..b9de555 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -209,7 +209,6 @@ header-y += ipv6.h
 header-y += ipv6_route.h
 header-y += ipx.h
 header-y += irda.h
-header-y += irqnr.h
 header-y += isdn.h
 header-y += isdn_divertif.h
 header-y += isdn_ppp.h
diff --git a/include/linux/random.h b/include/linux/random.h
index ac621ce..be982d6 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -9,7 +9,6 @@

 #include <linux/types.h>
 #include <linux/ioctl.h>
-#include <linux/irqnr.h>

 /* ioctl()'s for the random number generator */


-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
