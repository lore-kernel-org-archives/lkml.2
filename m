Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab2AMKED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:04:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab2AMKD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:03:57 -0500
Subject: GFS2: Pull request #2 (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 13 Jan 2012 10:04:35 +0000
Message-ID: <1326449075.2685.9.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes. All except one of these
patches is actually a bug fix rather than specifically merge window
material. That remaining patch applies on top of the DLM patches which
were merged in the current window,

Steve.

----------------------------------------------------------------------------
The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2012-01-10 18:04:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git master

Bob Peterson (1):
      GFS2: Fix a use-after-free that coverity spotted

David Teigland (3):
      GFS2: dlm based recovery coordination
      GFS2: let spectator mount do read only recovery
      GFS2: fail mount if journal recovery fails

Steven Whitehouse (1):
      GFS2: Fix nlink setting on inode creation

 fs/gfs2/glock.c             |    2 +-
 fs/gfs2/glock.h             |    7 +-
 fs/gfs2/incore.h            |   60 +++-
 fs/gfs2/inode.c             |    4 +-
 fs/gfs2/lock_dlm.c          |  993 ++++++++++++++++++++++++++++++++++++++++++-
 fs/gfs2/main.c              |   10 +
 fs/gfs2/ops_fstype.c        |   31 +-
 fs/gfs2/recovery.c          |   11 +-
 fs/gfs2/rgrp.c              |    2 +-
 fs/gfs2/sys.c               |   33 +-
 fs/gfs2/sys.h               |    2 +
 include/linux/gfs2_ondisk.h |    2 +
 12 files changed, 1108 insertions(+), 49 deletions(-)


