Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0ERIfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab0ERIfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:35:00 -0400
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 18 May 2010 09:38:55 +0100
Message-ID: <1274171935.2474.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches for GFS2,

Steve.

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (1):
      GFS2: Fix writing to non-page aligned gfs2_quota structures

Andrea Gelmini (1):
      GFS2: docs update

Benjamin Marzinski (1):
      GFS2: Various gfs2_logd improvements

Bob Peterson (3):
      GFS2: glock livelock
      GFS2: Eliminate useless err variable
      GFS2: stuck in inode wait, no glocks stuck

Christoph Hellwig (1):
      GFS2: fix quota state reporting

Steven Whitehouse (4):
      GFS2: Remove space from slab cache name
      GFS2: Clean up stuffed file copying
      GFS2: Add some useful messages
      GFS2: Fix typo

 Documentation/filesystems/gfs2.txt |   12 ++--
 fs/gfs2/aops.c                     |    8 +-
 fs/gfs2/bmap.c                     |   17 +++--
 fs/gfs2/dir.c                      |    2 +-
 fs/gfs2/export.c                   |    2 +-
 fs/gfs2/glock.c                    |    3 +
 fs/gfs2/incore.h                   |   11 ++-
 fs/gfs2/inode.c                    |  101 +++++++++++++++++++++--
 fs/gfs2/inode.h                    |    5 +-
 fs/gfs2/log.c                      |  158 ++++++++++++++++++++----------------
 fs/gfs2/log.h                      |    1 -
 fs/gfs2/lops.c                     |    2 +
 fs/gfs2/main.c                     |    2 +-
 fs/gfs2/meta_io.c                  |    5 +-
 fs/gfs2/ops_fstype.c               |   19 +++--
 fs/gfs2/quota.c                    |  102 +++++++++++++++++-------
 fs/gfs2/rgrp.c                     |   68 +++++++++-------
 fs/gfs2/super.c                    |   11 ++-
 fs/gfs2/sys.c                      |    6 +-
 fs/gfs2/trans.c                    |   18 ++++
 20 files changed, 368 insertions(+), 185 deletions(-)


