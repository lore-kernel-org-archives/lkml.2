Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2AFMI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:08:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2AFMIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:08:55 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 06 Jan 2012 12:09:32 +0000
Message-ID: <1325851772.2703.17.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

------------------------------------------------------------------------------
The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git master

Bob Peterson (7):
      GFS2: Add readahead to sequential directory traversal
      GFS2: Add non-try locks back to get_local_rgrp
      GFS2: combine gfs2_alloc_block and gfs2_alloc_di
      GFS2: remove vestigial al_alloced
      GFS2: move toward a generic multi-block allocator
      GFS2: split function rgblk_search
      GFS2: decouple quota allocations from block allocations

H Hartley Sweeten (1):
      GFS2: local functions should be static

Steven Whitehouse (8):
      GFS2: Fix up REQ flags
      GFS2: More automated code analysis fixes
      GFS2: Fix very unlikley memory leak in ACL xattr code
      GFS2: f_ra is always valid in dir readahead function
      GFS2: O_(D)SYNC support for fallocate
      GFS2: Fix up "off by one" in the previous patch
      GFS2: Fix multi-block allocation
      GFS2: We only need one ACL getting function

 fs/gfs2/acl.c        |   14 +--
 fs/gfs2/aops.c       |   18 ++--
 fs/gfs2/bmap.c       |   26 ++---
 fs/gfs2/dir.c        |   64 ++++++++++-
 fs/gfs2/dir.h        |    2 +-
 fs/gfs2/export.c     |    3 +-
 fs/gfs2/file.c       |   34 +++---
 fs/gfs2/incore.h     |   20 ++--
 fs/gfs2/inode.c      |   72 +++++++------
 fs/gfs2/log.c        |    2 +-
 fs/gfs2/main.c       |    3 +-
 fs/gfs2/meta_io.c    |    4 +-
 fs/gfs2/ops_fstype.c |    2 +-
 fs/gfs2/quota.c      |   87 ++++++---------
 fs/gfs2/rgrp.c       |  293 +++++++++++++++++++++++++++----------------------
 fs/gfs2/rgrp.h       |   16 ++--
 fs/gfs2/super.c      |   14 ++--
 fs/gfs2/trans.h      |    6 +-
 fs/gfs2/xattr.c      |   48 ++++-----
 19 files changed, 394 insertions(+), 334 deletions(-)


