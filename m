Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1GVMGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1GVMGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:06:36 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 22 Jul 2011 13:08:15 +0100
Message-ID: <1311336495.2804.20.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

------------------------------------------------------------------------
The following changes since commit 5dcd07b9f39ca3e9be5bcc387d193fc0674e1c81:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes (2011-07-14 10:20:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Bob Peterson (1):
      GFS2: Automatically adjust glock min hold time

Eric Sandeen (1):
      GFS2: combine duplicated block freeing routines

Steven Whitehouse (2):
      GFS2: Cache dir hash table in a contiguous buffer
      GFS2: Add S_NOSEC support

 fs/gfs2/bmap.c       |   12 +---
 fs/gfs2/dir.c        |  221 +++++++++++++++++++++++++-------------------------
 fs/gfs2/dir.h        |    1 +
 fs/gfs2/file.c       |    4 +-
 fs/gfs2/glock.c      |   39 +++++++---
 fs/gfs2/glock.h      |    6 ++
 fs/gfs2/glops.c      |    7 +-
 fs/gfs2/incore.h     |    3 +-
 fs/gfs2/main.c       |    1 +
 fs/gfs2/ops_fstype.c |    1 +
 fs/gfs2/rgrp.c       |   52 +-----------
 fs/gfs2/rgrp.h       |    4 +-
 fs/gfs2/super.c      |    2 +-
 13 files changed, 165 insertions(+), 188 deletions(-)


