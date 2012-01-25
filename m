Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2AYUZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:25:22 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48260 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301Ab2AYUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:25:21 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.3-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120125202519.907DB426DA7@whiskey.americas.sgi.com>
Date: Wed, 25 Jan 2012 14:25:19 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull in the following bugfix for xfs.  We forgot to drop a lock on
   error in xfs_readlink.  It hasn't been through -next yet, but there is no
   -next tree tomorrow.  The fix is clear so I'm sending this request today.

Thanks,
	Ben

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:
  Linus Torvalds (1):
        Linux 3.3-rc1

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git for-linus

Jan Kara (1):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()

 fs/xfs/xfs_vnodeops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
