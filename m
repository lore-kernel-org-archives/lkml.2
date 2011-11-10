Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1KJWFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:05:48 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44354 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754395Ab1KJWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:05:47 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201111102205.pAAM5e4f019587@stout.americas.sgi.com>
Date: Thu, 10 Nov 2011 16:05:40 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.2-rc2
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following changes for XFS for 3.2-rc2.
The first two address some security concerns, the last one is
a bug fix.  Thanks.

					-Alex

The following changes since commit 5e442a493fc59fa536c76db1fff5b49ca36a88c5:

  Revert "proc: fix races against execve() of /proc/PID/fd**" (2011-11-09 18:16:00 -0500)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Christoph Hellwig (2):
      xfs: constify xfs_item_ops
      xfs: fix force shutdown handling in xfs_end_io

 fs/xfs/xfs_aops.c         |    2 +-
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dquot_item.c   |    6 +++---
 fs/xfs/xfs_extfree_item.c |    4 ++--
 fs/xfs/xfs_inode_item.c   |    2 +-
 fs/xfs/xfs_log.c          |    2 +-
 fs/xfs/xfs_log.h          |    2 +-
 fs/xfs/xfs_trans.h        |    6 +++---
 fs/xfs/xfs_vnodeops.c     |   14 ++++++++++----
 9 files changed, 23 insertions(+), 17 deletions(-)
