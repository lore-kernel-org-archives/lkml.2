Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2BXPgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:36:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2BXPgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:36:20 -0500
Date: Fri, 24 Feb 2012 10:36:16 -0500
From: Kyle McMartin <kyle@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: drop me from PA-RISC maintenance
Message-ID: <20120224153614.GA29597@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't even live in the same country as any of my PA-RISC hardware
these days, so the odds of me touching the code are pretty low.
(Also re-order things to ensure jejb gets CC'd since he's been the
 primary maintainer for the last few years.)

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 924fb0b..75a9a5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -269,7 +269,6 @@ S:	Orphan
 F:	drivers/platform/x86/wmi.c
 
 AD1889 ALSA SOUND DRIVER
-M:	Kyle McMartin <kyle@mcmartin.ca>
 M:	Thibaut Varene <T-Bone@parisc-linux.org>
 W:	http://wiki.parisc-linux.org/AD1889
 L:	linux-parisc@vger.kernel.org
@@ -3047,7 +3046,6 @@ F:	drivers/hwspinlock/hwspinlock_*
 F:	include/linux/hwspinlock.h
 
 HARMONY SOUND DRIVER
-M:	Kyle McMartin <kyle@mcmartin.ca>
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
@@ -5000,9 +4998,8 @@ F:	Documentation/blockdev/paride.txt
 F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
-M:	Kyle McMartin <kyle@mcmartin.ca>
-M:	Helge Deller <deller@gmx.de>
 M:	"James E.J. Bottomley" <jejb@parisc-linux.org>
+M:	Helge Deller <deller@gmx.de>
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 Q:	http://patchwork.kernel.org/project/linux-parisc/list/
