Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2ISVfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:35:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40552 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059Ab2ISVfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:35:47 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.6-rc7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120919213542.0E11F426BF4@whiskey.americas.sgi.com>
Date: Wed, 19 Sep 2012 16:35:42 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these 2 bugfixes for XFS.  There is a fix for crashes on unmount
   and a fix for a race when discarding xfs_bufs.

Thanks,
	Ben

The following changes since commit a672e1be30d5bc848cd0067c55ed29b2015b7c17:

  xfs: check for possible overflow in xfs_ioc_trim (2012-08-23 14:48:44 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.6-rc7

for you to fetch changes up to 0ba6e5368c302819da7aff537e0d7eff2616c6a6:

  xfs: stop the sync worker before xfs_unmountfs (2012-09-18 16:51:26 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.6-rc7

- fix a regression related to xfs_sync_worker racing with unmount.
- fix a race while discarding xfs buffers.

----------------------------------------------------------------
Ben Myers (1):
      xfs: stop the sync worker before xfs_unmountfs

Carlos Maiolino (1):
      xfs: fix race while discarding buffers [V4]

 fs/xfs/xfs_buf.c   |  5 ++++-
 fs/xfs/xfs_buf.h   | 41 ++++++++++++++++++++++++-----------------
 fs/xfs/xfs_super.c |  1 +
 3 files changed, 29 insertions(+), 18 deletions(-)
