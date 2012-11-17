Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2KQQqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 11:46:09 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55986 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930Ab2KQQqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 11:46:07 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.7-rc7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20121117164602.EFAF74266DC@whiskey.americas.sgi.com>
Date: Sat, 17 Nov 2012 10:46:02 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these 3 bug fixes for XFS.  This includes a fix for attribute
   corruption, a fix for error handling in xfs_vm_writepage, and a fix for
   reference counts on xfs_bufs.

Thanks,
	Ben

The following changes since commit 6ce377afd1755eae5c93410ca9a1121dfead7b87:

  xfs: fix reading of wrapped log data (2012-11-08 11:10:51 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc7

for you to fetch changes up to d69043c42d8c6414fa28ad18d99973aa6c1c2e24:

  xfs: drop buffer io reference when a bad bio is built (2012-11-17 09:36:57 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.7-rc7

- fix attr tree double split corruption
- fix broken error handling in xfs_vm_writepage
- drop buffer io reference when a bad bio is built

----------------------------------------------------------------
Dave Chinner (3):
      xfs: fix attr tree double split corruption
      xfs: fix broken error handling in xfs_vm_writepage
      xfs: drop buffer io reference when a bad bio is built

 fs/xfs/xfs_aops.c      | 54 ++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_attr_leaf.c | 20 +++++++++++++++++--
 fs/xfs/xfs_buf.c       | 14 +++++++++++--
 3 files changed, 69 insertions(+), 19 deletions(-)
