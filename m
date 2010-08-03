Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0HCJAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0HCJAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:00:48 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 03 Aug 2010 10:06:07 +0100
Message-ID: <1280826367.2498.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches,

Steve.

---------------------------------------------------------------------------------
The following changes since commit 540ad6b62b3a188a53b51cac81d8a60d40e29fbd:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb (2010-07-28 20:01:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (1):
      GFS2: Fix typo in stuffed file data copy handling

Bob Peterson (1):
      GFS2: Simplify gfs2_write_alloc_required

David Rientjes (1):
      GFS2: remove dependency on __GFP_NOFAIL

Steven Whitehouse (5):
      GFS2: Use nobh_writepage
      GFS2: Wait for journal id on mount if not specified on mount command line
      GFS2: Make "try" lock not try quite so hard
      Revert "GFS2: recovery stuck on transaction lock"
      GFS2: Fix recovery stuck bug (try #2)

 fs/gfs2/aops.c       |    9 +---
 fs/gfs2/bmap.c       |   17 +++-----
 fs/gfs2/bmap.h       |    2 +-
 fs/gfs2/dir.c        |   11 ++++-
 fs/gfs2/file.c       |    4 +-
 fs/gfs2/glock.c      |  105 ++++++++++++++++++++++++++++++-------------------
 fs/gfs2/incore.h     |    1 +
 fs/gfs2/ops_fstype.c |   27 ++++++++++++-
 fs/gfs2/quota.c      |   15 +------
 fs/gfs2/super.c      |    9 +---
 fs/gfs2/sys.c        |   57 +++++++++++++++++++++++++-
 11 files changed, 169 insertions(+), 88 deletions(-)


