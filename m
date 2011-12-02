Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab1LBR2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:28:25 -0500
Received: from relay3.sgi.com ([192.48.152.1]:60188 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751330Ab1LBR2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:28:24 -0500
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20111202172843.CE9DE426DA7@whiskey.americas.sgi.com>
Date: Fri,  2 Dec 2011 11:28:43 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [GIT PULL] XFS update for 3.2-rc5

Linus, please pull the following bug fixes for XFS for 3.2-rc5.

fa8b18e fixes memory corruption if the on-disk ACL is corrupted,
4dd2cb4 fixes a delay in inode reclaim, and
4c393a6 fixes a reproducible crash when operating on the attribute fork.

Thanks,
	Ben



The following changes since commit 5983fe2b29df5885880d7fa3b91aca306c7564ef:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: validate acl count
      xfs: force buffer writeback before blocking on the ilock in inode reclaim
      xfs: fix attr2 vs large data fork assert

 fs/xfs/xfs_acl.c       |    2 +
 fs/xfs/xfs_attr_leaf.c |   64 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_inode.c     |   21 +++++++++++++++
 fs/xfs/xfs_inode.h     |    1 +
 fs/xfs/xfs_sync.c      |   11 ++++++++
 5 files changed, 74 insertions(+), 25 deletions(-)
