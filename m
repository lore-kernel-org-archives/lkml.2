Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab1ETINa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab1ETIN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:13:27 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 20 May 2011 09:14:33 +0100
Message-ID: <1305879273.2807.3.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 changes,

Steve.

----------------------------------------------------------------------------------
The following changes since commit 2f666bcf757cb72549f360ef6da02f03620a48b6:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-04-19 18:32:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Benjamin Marzinski (1):
      GFS2: make sure fallocate bytes is a multiple of blksize

Bob Peterson (5):
      GFS2: Dump better debug info if a bitmap inconsistency is detected
      GFS2: remove *leaf_call_t and simplify leaf_dealloc
      GFS2: Combine transaction from gfs2_dir_exhash_dealloc
      GFS2: pass leaf_bh into leaf_dealloc
      GFS2: move function foreach_leaf to gfs2_dir_exhash_dealloc

Steven Whitehouse (26):
      GFS2: Make ->write_inode() really write
      GFS2: Use filemap_fdatawrite() to write back the AIL
      GFS2: Alter point of entry to glock lru list for glocks with an address_space
      GFS2: Remove unused macro
      GFS2: Clean up fsync()
      GFS2: Improve tracing support (adds two flags)
      GFS2: Optimise glock lru and end of life inodes
      GFS2: Make writeback more responsive to system conditions
      GFS2: Add an AIL writeback tracepoint
      GFS2: Fix ail list traversal
      GFS2: Improve bug trap code in ->releasepage()
      GFS2: Double check link count under glock
      GFS2: Don't use a try lock when promoting to a higher mode
      GFS2: Don't use gfs2_change_nlink in link syscall
      GFS2: Make gfs2_dir_del update link count when required
      GFS2: When adding a new dir entry, inc link count if it is a subdir
      GFS2: Remove gfs2_dinode_print() function
      GFS2: Move gfs2_refresh_inode() and friends into glops.c
      GFS2: Move most of the remaining inode.c into ops_inode.c
      GFS2: Move final part of inode.c into super.c
      GFS2: Inode.c is empty now, remove it
      GFS2: Rename ops_inode.c to inode.c
      GFS2: Use UUID field in generic superblock
      GFS2: Clean up mkdir
      GFS2: Clean up symlink creation
      GFS2: Move all locking inside the inode creation function

 fs/gfs2/Makefile     |    4 +-
 fs/gfs2/aops.c       |    8 +-
 fs/gfs2/dir.c        |  197 +++----
 fs/gfs2/dir.h        |    4 +-
 fs/gfs2/export.c     |    2 +-
 fs/gfs2/file.c       |   46 +-
 fs/gfs2/glock.c      |   94 ++--
 fs/gfs2/glock.h      |    3 +-
 fs/gfs2/glops.c      |  172 +++++-
 fs/gfs2/glops.h      |    2 +
 fs/gfs2/incore.h     |    8 +-
 fs/gfs2/inode.c      | 1546 +++++++++++++++++++++++++++++++++++++++-----------
 fs/gfs2/inode.h      |    8 +-
 fs/gfs2/log.c        |  179 +++---
 fs/gfs2/log.h        |    2 +
 fs/gfs2/lops.c       |   39 +-
 fs/gfs2/main.c       |    1 +
 fs/gfs2/meta_io.c    |    2 +
 fs/gfs2/meta_io.h    |    2 -
 fs/gfs2/ops_fstype.c |   32 +-
 fs/gfs2/ops_inode.c  | 1344 -------------------------------------------
 fs/gfs2/rgrp.c       |   20 +-
 fs/gfs2/super.c      |  138 +++++-
 fs/gfs2/sys.c        |    6 +-
 fs/gfs2/trace_gfs2.h |   38 ++-
 25 files changed, 1865 insertions(+), 2032 deletions(-)
 delete mode 100644 fs/gfs2/ops_inode.c


