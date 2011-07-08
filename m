Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1GHOec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:34:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33513 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959Ab1GHOeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:34:31 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107081434.p68EYQcs020701@stout.americas.sgi.com>
Date: Fri, 08 Jul 2011 09:34:26 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.0-rc7
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS fix in for 3.0-rc7 (or final).

Previously, a dubious trick was used to avoid a race involving
inodes in the active item list.  This fix is pretty simple, and the
result is a much cleaner and more direct (and reliable) solution to
the problem.

It looks like I missed the last -next build for a while.  But I have
done a merge of my branch with your current master branch (shown
below).  The result has no conflicts and builds and tests just fine.

Thank you.

					-Alex

The following changes since commit f1bb20a8365f6753e0f7b6e94981ca2b662bae13:

  Merge branch 'for-30-rc5/all-i2c' of git://git.fluff.org/bjdooks/linux (2011-07-07 16:29:29 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: unpin stale inodes directly in IOP_COMMITTED

 fs/xfs/xfs_inode_item.c |   14 ++++++++------
 fs/xfs/xfs_trans.c      |    4 ++--
 2 files changed, 10 insertions(+), 8 deletions(-)
