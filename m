Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0LBQnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:43:12 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36980 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932093Ab0LBQnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:43:08 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201012021643.oB2Gh3JL006178@stout.americas.sgi.com>
Date: Thu, 02 Dec 2010 10:43:03 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.37-rc5
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following five XFS bug fixes for 2.6.37.

					-Alex

The following changes since commit 22a5b566c8c442b0b35b3b106795e2f2b3578096:

  Merge branch 'for_linus' of git://github.com/at91linux/linux-2.6-at91 (2010-11-30 17:57:57 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (5):
      xfs: fix failed write truncation handling.
      xfs: push stale, pinned buffers on trylock failures
      xfs: delayed alloc blocks beyond EOF are valid after writeback
      xfs: avoid moving stale inodes in the AIL
      xfs: only run xfs_error_test if error injection is active

 fs/xfs/linux-2.6/xfs_aops.c |   94 ++++++++++++++++++------------------------
 fs/xfs/linux-2.6/xfs_buf.c  |   35 +++++++---------
 fs/xfs/xfs_bmap.c           |   85 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap.h           |    5 ++
 fs/xfs/xfs_dfrag.c          |   13 ++++++
 fs/xfs/xfs_error.c          |    3 +
 fs/xfs/xfs_error.h          |    5 +-
 fs/xfs/xfs_inode_item.c     |   31 +++++++++++---
 8 files changed, 188 insertions(+), 83 deletions(-)
