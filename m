Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0DFXSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:18:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37563 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab0DFXSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:18:01 -0400
Date: Tue, 6 Apr 2010 16:17:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/2] Documentation/development-process: add info on
 maintainers
Message-Id: <20100406161705.2cecd9af.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBBC122.0093:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add info on maintainers and persistent posting.
Update git home page.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/2.Process        |   15 ++++++++---
 Documentation/development-process/7.AdvancedTopics |    2 -
 2 files changed, 13 insertions(+), 4 deletions(-)

--- linux-2.6.34-rc3-git5.orig/Documentation/development-process/2.Process
+++ linux-2.6.34-rc3-git5/Documentation/development-process/2.Process
@@ -151,7 +151,7 @@ The stages that a patch goes through are
    well.
 
  - Wider review.  When the patch is getting close to ready for mainline
-   inclusion, it will be accepted by a relevant subsystem maintainer -
+   inclusion, it should be accepted by a relevant subsystem maintainer -
    though this acceptance is not a guarantee that the patch will make it
    all the way to the mainline.  The patch will show up in the maintainer's
    subsystem tree and into the staging trees (described below).  When the
@@ -159,6 +159,15 @@ The stages that a patch goes through are
    the discovery of any problems resulting from the integration of this
    patch with work being done by others.
 
+-  Please note that most maintainers also have day jobs, so merging
+   your patch may not be their highest priority.  If your patch is
+   getting feedback about changes that are needed, you should either
+   make those changes or justify why they should not be made.  If your
+   patch has no review complaints but is not being merged by its
+   appropriate subsystem or driver maintainer, you should be persistent
+   in updating the patch to the current kernel so that it applies cleanly
+   and keep sending it for review & merging.
+
  - Merging into the mainline.  Eventually, a successful patch will be
    merged into the mainline repository managed by Linus Torvalds.  More
    comments and/or problems may surface at this time; it is important that
@@ -319,9 +328,9 @@ developers; even if they do not use it f
 to keep up with what other developers (and the mainline) are doing.
 
 Git is now packaged by almost all Linux distributions.  There is a home
-page at 
+page at:
 
-	http://git.or.cz/
+	http://git-scm.com/
 
 That page has pointers to documentation and tutorials.  One should be
 aware, in particular, of the Kernel Hacker's Guide to git, which has
--- linux-2.6.34-rc3-git5.orig/Documentation/development-process/7.AdvancedTopics
+++ linux-2.6.34-rc3-git5/Documentation/development-process/7.AdvancedTopics
@@ -25,7 +25,7 @@ long document in its own right.  Instead
 fits into the kernel development process in particular.  Developers who
 wish to come up to speed with git will find more information at:
 
-	http://git.or.cz/
+	http://git-scm.com/
 
 	http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
 
