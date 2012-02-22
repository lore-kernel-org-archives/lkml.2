Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2BVCJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:09:54 -0500
Received: from tundra.namei.org ([65.99.196.166]:59476 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab2BVCJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:09:53 -0500
Date: Wed, 22 Feb 2012 13:09:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] update my MAINTAINERS entry
Message-ID: <alpine.LRH.2.02.1202221308190.12415@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

The following changes since commit 27e74da9800289e69ba907777df1e2085231eff7:
  Linus Torvalds (1):
        i387: export 'fpu_owner_task' per-cpu variable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      maintainers: update my email address

 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


commit 9b45c0d2c50e19bd73d2f5e18dd6912a6991306e
Author: James Morris <james.l.morris@oracle.com>
Date:   Wed Feb 22 12:45:07 2012 +1100

    maintainers: update my email address
    
    Update my email address.
    
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a648eb..924fb0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5861,7 +5861,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-spear.c
 
 SECURITY SUBSYSTEM
-M:	James Morris <jmorris@namei.org>
+M:	James Morris <james.l.morris@oracle.com>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
 W:	http://security.wiki.kernel.org/
@@ -5874,7 +5874,7 @@ S:	Supported
 
 SELINUX SECURITY MODULE
 M:	Stephen Smalley <sds@tycho.nsa.gov>
-M:	James Morris <jmorris@namei.org>
+M:	James Morris <james.l.morris@oracle.com>
 M:	Eric Paris <eparis@parisplace.org>
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
