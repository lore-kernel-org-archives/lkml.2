Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1KRWqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:46:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41574 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1KRWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:46:12 -0500
Date: Fri, 18 Nov 2011 14:46:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>
Subject: [GIT PULL cgroup] Update maintainership
Message-ID: <20111118224606.GB27152@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Paul doesn't have enough time to maintain cgroup and we agreed that I
take over as one of the maintainers and maintain git tree.  I would be
doing standard for-next/fixes branch management.  At least until
things settle down, I wouldn't be committing any patch w/o Li Zefan's
co-ack.

At the moment, there are a few conflicting patchsets floating around
and sorting them out for the next merge window would be the first
priority.

Please pull from the following git branch to receive MAINTAINERS update.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.2-fixes

Thank you.

Paul Menage (1):
      cgroup: Replace Paul Menage with Tejun Heo as cgroups maintainer

 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f6bc29..78751bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1927,10 +1927,11 @@ S:	Maintained
 F:	drivers/connector/
 
 CONTROL GROUPS (CGROUPS)
-M:	Paul Menage <paul@paulmenage.org>
+M:	Tejun Heo <tj@kernel.org>
 M:	Li Zefan <lizf@cn.fujitsu.com>
 L:	containers@lists.linux-foundation.org
 L:	cgroups@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*

--
tejun
