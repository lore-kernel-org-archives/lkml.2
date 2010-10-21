Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0JUJhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab0JUJhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:37:22 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 21 Oct 2010 10:43:33 +0100
Message-ID: <1287654213.2946.3.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There have been no changes in the GFS2 -nmw git tree since my recent
patch posting. Please consider pulling the following changes,

Steve.

-------------------------------------------------------------------------
The following changes since commit 2422084a94fcd5038406261b331672a13c92c050:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6 (2010-09-19 11:09:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Andrea Gelmini (1):
      GFS2: fixed typo

Benjamin Marzinski (2):
      GFS2: fallocate support
      GFS2: reserve more blocks for transactions

Bob Peterson (1):
      GFS2 fatal: filesystem consistency error on rename

Steven Whitehouse (18):
      GFS2: New truncate sequence
      GFS2: Remove i_disksize
      GFS2: No longer experimental
      GFS2: Add a bug trap in allocation code
      GFS2: Fix whitespace in previous patch
      GFS2: Don't enforce min hold time when two demotes occur in rapid succession
      GFS2: Update handling of DLM return codes to match reality
      GFS2: Use new workqueue scheme
      GFS2: Make . and .. qstrs constant
      GFS2: Remove ignore_local_fs mount argument
      GFS2: Remove localcaching mount option
      GFS2: Remove upgrade mount option
      GFS2: Fix journal check for spectator mounts
      GFS2: Fix compiler warning from previous patch
      GFS2: Fix spectator umount issue
      GFS2: Add "norecovery" mount option as a synonym for "spectator"
      GFS2: Improve journal allocation via sysfs
      GFS2: Fix type mapping for demote_rq interface

 fs/gfs2/Kconfig      |    2 +-
 fs/gfs2/aops.c       |   24 ++--
 fs/gfs2/bmap.c       |  255 +++++++++++++++++++--------------------
 fs/gfs2/bmap.h       |   20 ++--
 fs/gfs2/dentry.c     |    2 +-
 fs/gfs2/dir.c        |   31 +++--
 fs/gfs2/dir.h        |   34 +++---
 fs/gfs2/export.c     |    9 +--
 fs/gfs2/file.c       |    6 +-
 fs/gfs2/glock.c      |   23 +++-
 fs/gfs2/glock.h      |    2 +-
 fs/gfs2/glops.c      |    6 +-
 fs/gfs2/incore.h     |    8 +-
 fs/gfs2/inode.c      |    9 +-
 fs/gfs2/inode.h      |   15 +++
 fs/gfs2/lock_dlm.c   |    4 +-
 fs/gfs2/main.c       |    6 +-
 fs/gfs2/ops_fstype.c |   79 +++----------
 fs/gfs2/ops_inode.c  |  326 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/gfs2/quota.c      |   16 +--
 fs/gfs2/recovery.c   |   15 ++-
 fs/gfs2/rgrp.c       |   50 ++++++--
 fs/gfs2/rgrp.h       |    8 +-
 fs/gfs2/super.c      |   26 ++---
 fs/gfs2/sys.c        |   22 ++--
 fs/gfs2/trace_gfs2.h |    3 +-
 fs/gfs2/trans.h      |    9 ++
 fs/gfs2/xattr.c      |    2 +-
 28 files changed, 617 insertions(+), 395 deletions(-)


