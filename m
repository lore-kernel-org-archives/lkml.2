Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1CPNxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1CPNxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:53:09 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 16 Mar 2011 13:55:24 +0000
Message-ID: <1300283724.2571.5.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

-----------------------------------------------------------
The following changes since commit 2b1caf6ed7b888c95a1909d343799672731651a5:

  Merge branch 'core-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-20 18:30:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (2):
      GFS2: panics on quotacheck update
      GFS2: quota allows exceeding hard limit

Benjamin Marzinski (1):
      GFS2: fix block allocation check for fallocate

Bob Peterson (2):
      GFS2: deallocation performance patch
      GFS2: Optimize glock multiple-dequeue code

Dave Chinner (1):
      GFS2: introduce AIL lock

Maxim (1):
      GFS2: Adding missing unlock_page()

Steven Whitehouse (8):
      GFS2: Use RCU for glock hash table
      GFS2: Post-VFS scale update for RCU path walk
      GFS2: Fix glock queue trace point
      GFS2: Improve cluster mmap scalability
      GFS2: Fix glock deallocation race
      GFS2: Remove potential race in flock code
      GFS2: Update to AIL list locking
      GFS2: Don't use _raw version of RCU dereference

 fs/gfs2/acl.c        |    7 +-
 fs/gfs2/aops.c       |    1 +
 fs/gfs2/bmap.c       |   20 ++-
 fs/gfs2/file.c       |   77 ++++++----
 fs/gfs2/glock.c      |  410 +++++++++++++++++++-------------------------------
 fs/gfs2/glock.h      |   39 +++---
 fs/gfs2/glops.c      |   33 ++--
 fs/gfs2/incore.h     |    7 +-
 fs/gfs2/lock_dlm.c   |   14 +--
 fs/gfs2/log.c        |   32 ++--
 fs/gfs2/lops.c       |   10 +-
 fs/gfs2/main.c       |    6 +-
 fs/gfs2/meta_io.c    |    2 +
 fs/gfs2/ops_fstype.c |   11 +-
 fs/gfs2/ops_inode.c  |   10 +-
 fs/gfs2/quota.c      |   14 ++-
 fs/gfs2/rgrp.c       |   34 ++++-
 fs/gfs2/rgrp.h       |    2 +
 18 files changed, 351 insertions(+), 378 deletions(-)


