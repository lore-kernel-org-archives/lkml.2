Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab0KRUdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:33:07 -0500
Received: from xenotime.net ([72.52.115.56]:55561 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760239Ab0KRUdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:33:03 -0500
Date: Thu, 18 Nov 2010 12:27:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Andres Salomon <dilinger@queued.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/7] Documentation/development-process: more staging info
Message-ID: <12901120543285@xenotime.net>
In-Reply-To: <12901120542939@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>

Document things that I would've liked to have known when submitting a driver
to gregkh for staging.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/development-process/2.Process |   23 ++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- linux-2.6.37-rc2-git4.orig/Documentation/development-process/2.Process
+++ linux-2.6.37-rc2-git4/Documentation/development-process/2.Process
@@ -303,12 +303,25 @@ volatility of linux-next tends to make i
 See http://lwn.net/Articles/289013/ for more information on this topic, and
 stay tuned; much is still in flux where linux-next is involved.
 
-Besides the mmotm and linux-next trees, the kernel source tree now contains
-the drivers/staging/ directory and many sub-directories for drivers or
-filesystems that are on their way to being added to the kernel tree
-proper, but they remain in drivers/staging/ while they still need more
-work.
+2.4.1: STAGING TREES
 
+The kernel source tree now contains the drivers/staging/ directory, where
+many sub-directories for drivers or filesystems that are on their way to
+being added to the kernel tree live.  They remain in drivers/staging while
+they still need more work; once complete, they can be moved into the
+kernel proper.  This is a way to keep track of drivers that aren't
+up to Linux kernel coding or quality standards, but people may want to use
+them and track development.
+
+Greg Kroah-Hartman currently (as of 2.6.36) maintains the staging tree.
+Drivers that still need work are sent to him, with each driver having
+its own subdirectory in drivers/staging/.  Along with the driver source
+files, a TODO file should be present in the directory as well.  The TODO
+file lists the pending work that the driver needs for acceptance into
+the kernel proper, as well as a list of people that should be Cc'd for any
+patches to the driver.  Staging drivers that don't currently build should
+have their config entries depend upon CONFIG_BROKEN.  Once they can
+be successfully built without outside patches, CONFIG_BROKEN can be removed.
 
 2.5: TOOLS
 


-- 

