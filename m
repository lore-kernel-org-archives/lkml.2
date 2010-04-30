Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab0D3RQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:16:45 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34942 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932640Ab0D3RQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:08 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004300221.o3U2LYZt009176@stout.americas.sgi.com>
Date: Thu, 29 Apr 2010 21:21:34 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.34-rc6 or -rc7
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I expect this won't make it for 2.6.34-rc6, so if not, please
pull it for 2.6.34-rc7.  This change addresses a regression
that went into 2.6.34-rc1, which can lead to memory exhaustion
in some situations.

					-Alex

The following changes since commit 79dba2eaa771c3173957eccfd288e0e0d12e4d3f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2010-04-28 20:40:17 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: add a shrinker to background inode reclaim

 fs/xfs/linux-2.6/xfs_super.c   |    5 ++
 fs/xfs/linux-2.6/xfs_sync.c    |  112 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_sync.h    |    7 ++-
 fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
 fs/xfs/xfs_ag.h                |    1 +
 fs/xfs/xfs_mount.h             |    1 +
 6 files changed, 120 insertions(+), 9 deletions(-)
