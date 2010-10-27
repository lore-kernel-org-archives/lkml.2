Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526Ab0J0ACx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:02:53 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49065 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0J0ACw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:02:52 -0400
Date: Tue, 26 Oct 2010 17:02:49 -0700
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Documentation: don't call the -next tree "staging"
Message-ID: <20101026170249.3ef80238@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is confusing, as we have "staging" trees for drivers/staging.  Call
them -next trees.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 Documentation/development-process/2.Process |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 97726eb..ae8127c 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -154,7 +154,7 @@ The stages that a patch goes through are, generally:
    inclusion, it should be accepted by a relevant subsystem maintainer -
    though this acceptance is not a guarantee that the patch will make it
    all the way to the mainline.  The patch will show up in the maintainer's
-   subsystem tree and into the staging trees (described below).  When the
+   subsystem tree and into the -next trees (described below).  When the
    process works, this step leads to more extensive review of the patch and
    the discovery of any problems resulting from the integration of this
    patch with work being done by others.
@@ -236,7 +236,7 @@ finding the right maintainer.  Sending patches directly to Linus is not
 normally the right way to go.
 
 
-2.4: STAGING TREES
+2.4: NEXT TREES
 
 The chain of subsystem trees guides the flow of patches into the kernel,
 but it also raises an interesting question: what if somebody wants to look
@@ -250,7 +250,7 @@ changes land in the mainline kernel.  One could pull changes from all of
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
1.7.1

