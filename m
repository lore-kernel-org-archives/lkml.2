Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab2CUSgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:36:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759725Ab2CUSgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:36:07 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.4-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
Date: Wed, 21 Mar 2012 13:36:13 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull from git://oss.sgi.com/xfs/xfs for-linus

   Bugfixes and cleanups.

Thanks,
	Ben

The following changes since commit 31f6765266417c0d99f0e922fe82848a7c9c2ae9:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2012-03-21 10:37:25 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Amit Sahrawat (1):
      xfs: kill the unused XFS_BB_FSB_OFFSET macro

Chandra Seetharaman (4):
      Define a new function xfs_this_quota_on()
      Define a new function xfs_inode_dquot()
      Change xfs_sb_from_disk() interface to take a mount pointer
      Define new macro XFS_ALL_QUOTA_ACTIVE and simply some usage

Christoph Hellwig (1):
      xfs: use a normal shrinker for the dquot freelist

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when compare is intended

Mitsuo Hayasaka (3):
      xfs: show uuid when mount fails due to duplicate uuid
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general

 fs/xfs/kmem.h            |    6 -
 fs/xfs/xfs_dquot.c       |  164 ++++++++------------------
 fs/xfs/xfs_dquot.h       |   30 ++++-
 fs/xfs/xfs_log_recover.c |    8 +-
 fs/xfs/xfs_mount.c       |    8 +-
 fs/xfs/xfs_mount.h       |    2 +-
 fs/xfs/xfs_qm.c          |  293 ++++++++++++++++++----------------------------
 fs/xfs/xfs_qm.h          |   14 ---
 fs/xfs/xfs_qm_stats.c    |    4 +-
 fs/xfs/xfs_qm_syscalls.c |    4 +-
 fs/xfs/xfs_quota.h       |    2 +
 fs/xfs/xfs_sb.h          |    1 -
 fs/xfs/xfs_super.c       |    7 +-
 fs/xfs/xfs_trace.h       |    5 +-
 fs/xfs/xfs_trans.c       |    4 +-
 fs/xfs/xfs_trans_dquot.c |   10 +-
 16 files changed, 216 insertions(+), 346 deletions(-)
