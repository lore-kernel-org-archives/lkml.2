Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1DSJKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:10:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1DSJKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:10:45 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 19 Apr 2011 10:13:11 +0100
Message-ID: <1303204391.2702.9.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following four GFS2 fixes,

Steve.

--------------------------------------------------------------------------------------

The following changes since commit a1b49cb7e2a7961ec3aa8b64860bf480d4ec9077:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-04-17 17:37:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: directly write blocks past i_size

Bob Peterson (2):
      GFS2: write_end error path fails to unlock transaction lock
      GFS2: filesystem hang caused by incorrect lock order

Steven Whitehouse (1):
      GFS2: Don't try to deallocate unlinked inodes when mounted ro

 fs/gfs2/aops.c       |    2 +-
 fs/gfs2/dir.c        |    2 +-
 fs/gfs2/file.c       |   58 +++++++++++++++++++++++++++++++++++++++++--------
 fs/gfs2/glops.c      |    4 +++
 fs/gfs2/inode.c      |   56 +++++++++++++++++++++++++++++++++++-------------
 fs/gfs2/inode.h      |    3 +-
 fs/gfs2/ops_fstype.c |    2 +-
 fs/gfs2/rgrp.c       |    4 +-
 fs/gfs2/super.c      |   14 +++++++++--
 9 files changed, 111 insertions(+), 34 deletions(-)


