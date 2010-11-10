Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0KJWn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:43:27 -0500
Received: from xenotime.net ([72.52.115.56]:47238 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757198Ab0KJWnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:25 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Andres Salomon <dilinger@queued.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/8] Documentation/development-process: use -next trees instead of staging
Message-ID: <12894188303619@xenotime.net>
In-Reply-To: <1289418830794@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>

This is confusing, as we have "staging" trees for drivers/staging.  Call
them -next trees.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/development-process/2.Process |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.37-rc1-git8.orig/Documentation/development-process/2.Process
+++ linux-2.6.37-rc1-git8/Documentation/development-process/2.Process
@@ -154,7 +154,7 @@ The stages that a patch goes through are
    inclusion, it should be accepted by a relevant subsystem maintainer -
    though this acceptance is not a guarantee that the patch will make it
    all the way to the mainline.  The patch will show up in the maintainer's
-   subsystem tree and into the staging trees (described below).  When the
+   subsystem tree and into the -next trees (described below).  When the
    process works, this step leads to more extensive review of the patch and
    the discovery of any problems resulting from the integration of this
    patch with work being done by others.
@@ -236,7 +236,7 @@ finding the right maintainer.  Sending p
 normally the right way to go.
 
 
-2.4: STAGING TREES
+2.4: NEXT TREES
 
 The chain of subsystem trees guides the flow of patches into the kernel,
 but it also raises an interesting question: what if somebody wants to look
@@ -250,7 +250,7 @@ changes land in the mainline kernel.  On
 the interesting subsystem trees, but that would be a big and error-prone
 job.
 
-The answer comes in the form of staging trees, where subsystem trees are
+The answer comes in the form of -next trees, where subsystem trees are
 collected for testing and review.  The older of these trees, maintained by
 Andrew Morton, is called "-mm" (for memory management, which is how it got
 started).  The -mm tree integrates patches from a long list of subsystem
@@ -275,7 +275,7 @@ directory at:
 Use of the MMOTM tree is likely to be a frustrating experience, though;
 there is a definite chance that it will not even compile.
 
-The other staging tree, started more recently, is linux-next, maintained by
+The other -next tree, started more recently, is linux-next, maintained by
 Stephen Rothwell.  The linux-next tree is, by design, a snapshot of what
 the mainline is expected to look like after the next merge window closes.
 Linux-next trees are announced on the linux-kernel and linux-next mailing


-- 

