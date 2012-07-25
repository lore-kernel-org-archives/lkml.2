Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2GYAPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:15:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54698 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2GYAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:15:14 -0400
Date: Tue, 24 Jul 2012 17:15:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup changes for v3.6-rc1
Message-ID: <20120725001510.GB5304@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive cgroup changes for
v3.6-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.6

Nothing too interesting.  A minor bug fix and some cleanups.

Thanks.

Daniel Wagner (2):
      cgroup: Remove populate() documentation
      cgroup: Update remount documentation

Li Zefan (1):
      cgroup: remove hierarchy_mutex

Tejun Heo (1):
      cgroup: cgroup_rm_files() was calling simple_unlink() with the wrong inode

 Documentation/cgroups/cgroups.txt |   27 +++++---------------
 include/linux/cgroup.h            |   17 +-----------
 kernel/cgroup.c                   |   47 +------------------------------------
 3 files changed, 10 insertions(+), 81 deletions(-)

--
tejun
