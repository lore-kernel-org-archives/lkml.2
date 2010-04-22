Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0DVSaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:30:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57433 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0DVSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:30:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Airlie <airlied@linux.ie>
cc: linux-kernel@vger.kernel.org
Subject: dri-devel mailing list moved - update MAINTAINERS
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 22 Apr 2010 14:29:10 -0400
Message-ID: <12135.1271960950@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4BD09576.0284,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted to dri-devel@lists.sourceforge.net, and got a bounce back:

   The dri-devel list has moved to freedesktop.org (see
   http://lists.freedesktop.org/mailman/listinfo/dri-devel). If you were
   subscribed to the list here, the subscription should have been
   transferred to the new location.

   Please only post to the new list.

Fix MAINTAINERS to correspond.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6/MAINTAINERS.dist	2010-04-22 14:25:03.244700280 -0400
+++ linux-2.6/MAINTAINERS	2010-04-22 14:27:55.594669681 -0400
@@ -1960,7 +1960,7 @@ F:	lib/kobj*
 
 DRM DRIVERS
 M:	David Airlie <airlied@linux.ie>
-L:	dri-devel@lists.sourceforge.net
+L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/


