Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2AQVzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:55:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39420 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755118Ab2AQVzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:55:07 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120117215505.8978A426DA7@whiskey.americas.sgi.com>
Date: Tue, 17 Jan 2012 15:55:05 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull the following XFS changes for 3.3.

Thanks,
	Ben

The following changes since commit c2bc3a316a7281f67e36b34dac2802cbe36a9128:
  Linus Torvalds (1):
        Merge branch 'x86/rdrand' of git://git.kernel.org/.../tip/tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
      xfs: remove xfs_itruncate_data
      xfs: cleanup xfs_iomap_eof_align_last_fsb
      xfs: remove the unused dm_attrs structure
      xfs: remove the if_ext_max field in struct xfs_ifork
      xfs: make i_flags an unsigned long
      xfs: replace i_flock with a sleeping bitlock
      xfs: replace i_pin_wait with a bit waitqueue
      xfs: remove the i_size field in struct xfs_inode
      xfs: remove the i_new_size field in struct xfs_inode
      xfs: always return with the iolock held from xfs_file_aio_write_checks
      xfs: cleanup xfs_file_aio_write

 fs/xfs/xfs_aops.c        |   29 ++++---
 fs/xfs/xfs_attr.c        |    4 -
 fs/xfs/xfs_attr_leaf.c   |    9 --
 fs/xfs/xfs_bmap.c        |  116 +++++++++++++---------------
 fs/xfs/xfs_dfrag.c       |   43 +++++-----
 fs/xfs/xfs_file.c        |  184 ++++++++++++-------------------------------
 fs/xfs/xfs_fs_subr.c     |    2 +-
 fs/xfs/xfs_iget.c        |   24 ++++--
 fs/xfs/xfs_inode.c       |  193 +++++++++++-----------------------------------
 fs/xfs/xfs_inode.h       |  114 ++++++++++++++++-----------
 fs/xfs/xfs_inode_item.c  |    8 +-
 fs/xfs/xfs_iomap.c       |   46 ++++++------
 fs/xfs/xfs_iops.c        |   46 +++++++----
 fs/xfs/xfs_qm_syscalls.c |    8 ++-
 fs/xfs/xfs_super.c       |    8 --
 fs/xfs/xfs_sync.c        |    9 +-
 fs/xfs/xfs_trace.h       |   29 ++-----
 fs/xfs/xfs_vnodeops.c    |   44 +++++++----
 18 files changed, 374 insertions(+), 542 deletions(-)
