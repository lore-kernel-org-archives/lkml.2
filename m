Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1GNPPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1GNPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:15:06 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 14 Jul 2011 16:16:56 +0100
Message-ID: <1310656616.2761.33.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following three fixes,

Steve.

--------------------------------------------------------------------------------
The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: force a log flush when invalidating the rindex glock

Steven Whitehouse (2):
      GFS2: Fix race during filesystem mount
      GFS2: Resolve inode eviction and ail list interaction bug

 fs/gfs2/aops.c       |    3 +++
 fs/gfs2/glops.c      |    8 +++++---
 fs/gfs2/incore.h     |    2 ++
 fs/gfs2/log.c        |    1 +
 fs/gfs2/ops_fstype.c |    3 +++
 fs/gfs2/super.c      |   36 ++++++++++++++++++++++++++++++------
 fs/gfs2/sys.c        |    7 ++++++-
 7 files changed, 50 insertions(+), 10 deletions(-)


