Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1G0UfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:35:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59660 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754851Ab1G0UfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:35:01 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107272034.p6RKYtnq013266@stout.americas.sgi.com>
Date: Wed, 27 Jul 2011 15:34:55 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 2 for 3.1-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few more commits for XFS for Linux 3.1-rc1.	-Alex

The following changes since commit 5fd00b031530cc476240f654c078c930f1dcd6ea:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6 (2011-07-27 09:26:39 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: encapsulate a block of debug code

Christoph Hellwig (3):
      xfs: flag all buffers as metadata
      xfs: prevent against ioend livelocks in xfs_file_fsync
      xfs: optimize the negative xattr caching

 fs/xfs/linux-2.6/xfs_buf.c  |    3 +++
 fs/xfs/linux-2.6/xfs_file.c |    2 ++
 fs/xfs/linux-2.6/xfs_iops.c |    9 +++++++--
 fs/xfs/xfs_da_btree.c       |   32 +++++++++++++++++++++-----------
 4 files changed, 33 insertions(+), 13 deletions(-)
