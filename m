Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1AEKVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:21:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1AEKVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:21:35 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 05 Jan 2011 10:22:35 +0000
Message-ID: <1294222955.2459.13.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When you are ready to start merging, please consider pulling the
following changes. There have been no updates since I posted the patches
before Christmas,

Steve.

------------------------------------------------------------------------------

The following changes since commit 0fcdcfbbc98f70f559e4b36773a69972489a6d8f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq (2010-12-14 18:50:10 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (1):
      GFS2: Allow gfs2 to update quota usage values through the quotactl interface

Benjamin Marzinski (2):
      GFS2: reread rindex when necessary to grow rindex
      GFS2: fix recursive locking during rindex truncates

Bob Peterson (1):
      GFS2: fsck.gfs2 reported statfs error after gfs2_grow

Joe Perches (3):
      GFS2: fs/gfs2/glock.c: Convert sprintf_symbol to %pS
      GFS2: fs/gfs2/glock.c: Use printf extension %pV
      GFS2: fs/gfs2/glock.h: Add __attribute__((format(printf,2,3)) to gfs2_print_dbg

Steven Whitehouse (8):
      GFS2: Change two WQ_RESCUERs into WQ_MEM_RECLAIM
      GFS2: Remove unreachable calls to vmtruncate
      GFS2: Clean up duplicated setattr code
      GFS2: Clean up of gdlm_lock function
      GFS2: Remove duplicate #defines from glock.h
      GFS2: Fix uninitialised error value in previous patch
      GFS2: Merge glock state fields into a bitfield
      GFS2: Don't flush delete workqueue when releasing the transaction lock

 fs/gfs2/bmap.c      |   11 ++++++--
 fs/gfs2/glock.c     |   71 ++++++++++++++++++++++++--------------------------
 fs/gfs2/glock.h     |   28 ++++----------------
 fs/gfs2/glops.c     |    1 -
 fs/gfs2/incore.h    |   12 +++++---
 fs/gfs2/inode.c     |    9 ------
 fs/gfs2/lock_dlm.c  |   15 +++--------
 fs/gfs2/ops_inode.c |   18 +------------
 fs/gfs2/quota.c     |   13 ++++++++-
 fs/gfs2/rgrp.c      |   57 +++++++++-------------------------------
 fs/gfs2/rgrp.h      |    1 +
 fs/gfs2/xattr.c     |   23 +----------------
 12 files changed, 86 insertions(+), 173 deletions(-)


