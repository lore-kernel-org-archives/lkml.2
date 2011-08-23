Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1HWRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:39:57 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55186 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755878Ab1HWRjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:42 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
Date: Tue, 23 Aug 2011 12:39:33 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.1-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS changes.  Their effect is to
remove the subdirectory structure from the XFS source hierarchy.
There are no functional changes to the XFS code itself.  Thanks.

					-Alex

The following changes since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:

  Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: don't expect xfs headers to be in subdirectories

Christoph Hellwig (2):
      xfs: remove subdirectories
      xfs: fix tracing builds inside the source tree

 fs/xfs/Makefile                       |  119 ++++++++++++++++-----------------
 fs/xfs/{linux-2.6 => }/kmem.c         |    0
 fs/xfs/{linux-2.6 => }/kmem.h         |    0
 fs/xfs/{linux-2.6 => }/mrlock.h       |    0
 fs/xfs/{linux-2.6 => }/time.h         |    0
 fs/xfs/{support => }/uuid.c           |    0
 fs/xfs/{support => }/uuid.h           |    0
 fs/xfs/xfs.h                          |    3 +-
 fs/xfs/{linux-2.6 => }/xfs_acl.c      |    0
 fs/xfs/{linux-2.6 => }/xfs_aops.c     |    0
 fs/xfs/{linux-2.6 => }/xfs_aops.h     |    0
 fs/xfs/{linux-2.6 => }/xfs_buf.c      |    0
 fs/xfs/{linux-2.6 => }/xfs_buf.h      |    0
 fs/xfs/{linux-2.6 => }/xfs_discard.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_discard.h  |    0
 fs/xfs/{quota => }/xfs_dquot.c        |    0
 fs/xfs/{quota => }/xfs_dquot.h        |    0
 fs/xfs/{quota => }/xfs_dquot_item.c   |    0
 fs/xfs/{quota => }/xfs_dquot_item.h   |    0
 fs/xfs/{linux-2.6 => }/xfs_export.c   |    0
 fs/xfs/{linux-2.6 => }/xfs_export.h   |    0
 fs/xfs/{linux-2.6 => }/xfs_file.c     |    0
 fs/xfs/{linux-2.6 => }/xfs_fs_subr.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_globals.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_ioctl.c    |    0
 fs/xfs/{linux-2.6 => }/xfs_ioctl.h    |    0
 fs/xfs/{linux-2.6 => }/xfs_ioctl32.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_ioctl32.h  |    0
 fs/xfs/{linux-2.6 => }/xfs_iops.c     |    0
 fs/xfs/{linux-2.6 => }/xfs_iops.h     |    0
 fs/xfs/{linux-2.6 => }/xfs_linux.h    |   27 ++++----
 fs/xfs/{linux-2.6 => }/xfs_message.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_message.h  |    0
 fs/xfs/{quota => }/xfs_qm.c           |    0
 fs/xfs/{quota => }/xfs_qm.h           |    0
 fs/xfs/{quota => }/xfs_qm_bhv.c       |    0
 fs/xfs/{quota => }/xfs_qm_stats.c     |    0
 fs/xfs/{quota => }/xfs_qm_stats.h     |    0
 fs/xfs/{quota => }/xfs_qm_syscalls.c  |    0
 fs/xfs/{quota => }/xfs_quota_priv.h   |    0
 fs/xfs/{linux-2.6 => }/xfs_quotaops.c |    2 +-
 fs/xfs/{linux-2.6 => }/xfs_stats.c    |    0
 fs/xfs/{linux-2.6 => }/xfs_stats.h    |    0
 fs/xfs/{linux-2.6 => }/xfs_super.c    |    0
 fs/xfs/{linux-2.6 => }/xfs_super.h    |    0
 fs/xfs/{linux-2.6 => }/xfs_sync.c     |    0
 fs/xfs/{linux-2.6 => }/xfs_sync.h     |    0
 fs/xfs/{linux-2.6 => }/xfs_sysctl.c   |    0
 fs/xfs/{linux-2.6 => }/xfs_sysctl.h   |    0
 fs/xfs/{linux-2.6 => }/xfs_trace.c    |    4 +-
 fs/xfs/{linux-2.6 => }/xfs_trace.h    |    0
 fs/xfs/{quota => }/xfs_trans_dquot.c  |    0
 fs/xfs/{linux-2.6 => }/xfs_vnode.h    |    0
 fs/xfs/{linux-2.6 => }/xfs_xattr.c    |    0
 kernel/sysctl_binary.c                |    2 +-
 kernel/sysctl_check.c                 |    2 +-
 56 files changed, 78 insertions(+), 81 deletions(-)
 rename fs/xfs/{linux-2.6 => }/kmem.c (100%)
 rename fs/xfs/{linux-2.6 => }/kmem.h (100%)
 rename fs/xfs/{linux-2.6 => }/mrlock.h (100%)
 rename fs/xfs/{linux-2.6 => }/time.h (100%)
 rename fs/xfs/{support => }/uuid.c (100%)
 rename fs/xfs/{support => }/uuid.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_acl.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_aops.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_aops.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_buf.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_buf.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_discard.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_discard.h (100%)
 rename fs/xfs/{quota => }/xfs_dquot.c (100%)
 rename fs/xfs/{quota => }/xfs_dquot.h (100%)
 rename fs/xfs/{quota => }/xfs_dquot_item.c (100%)
 rename fs/xfs/{quota => }/xfs_dquot_item.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_export.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_export.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_file.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_fs_subr.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_globals.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_ioctl.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_ioctl.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_ioctl32.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_ioctl32.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_iops.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_iops.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_linux.h (96%)
 rename fs/xfs/{linux-2.6 => }/xfs_message.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_message.h (100%)
 rename fs/xfs/{quota => }/xfs_qm.c (100%)
 rename fs/xfs/{quota => }/xfs_qm.h (100%)
 rename fs/xfs/{quota => }/xfs_qm_bhv.c (100%)
 rename fs/xfs/{quota => }/xfs_qm_stats.c (100%)
 rename fs/xfs/{quota => }/xfs_qm_stats.h (100%)
 rename fs/xfs/{quota => }/xfs_qm_syscalls.c (100%)
 rename fs/xfs/{quota => }/xfs_quota_priv.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_quotaops.c (99%)
 rename fs/xfs/{linux-2.6 => }/xfs_stats.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_stats.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_super.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_super.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_sync.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_sync.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_sysctl.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_sysctl.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_trace.c (96%)
 rename fs/xfs/{linux-2.6 => }/xfs_trace.h (100%)
 rename fs/xfs/{quota => }/xfs_trans_dquot.c (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_vnode.h (100%)
 rename fs/xfs/{linux-2.6 => }/xfs_xattr.c (100%)
