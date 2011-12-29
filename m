Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1L2RbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:31:15 -0500
Received: from relay3.sgi.com ([192.48.152.1]:38885 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752204Ab1L2RbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:31:12 -0500
Date: Thu, 29 Dec 2011 11:31:39 -0600
From: Ben Myers <bpm@sgi.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] XFS update for 3.2
Message-ID: <20111229173139.GL21646@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for 3.2.  Quoting Christoph Hellwig:
"These two small fixes fix issues with periodic metadata writeback and
sync not being able [to] write file size updates to disk in some cases."
These have not gone through -next because we have 3.3 work in the
oss/master branch right now, but they merged and built cleanly on
3.2-rc7.  They have been tested thoroughly by Mark Tinguely and myself.
It is late in the cycle and I will submit them later for 3.2-stable if
you prefer.

Have a happy New Year!

Thanks,
       Ben

The following changes since commit 371de6e4e0042adf4f9b54c414154f57414ddd37:
  Keith Packard (1):
        drm/i915: Disable RC6 on Sandybridge by default

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: log the inode in ->write_inode calls for kupdate
      xfs: log all dirty inodes in xfs_fs_sync_fs

 fs/xfs/xfs_super.c |   30 +++++-------------------------
 fs/xfs/xfs_sync.c  |   36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h  |    2 ++
 3 files changed, 43 insertions(+), 25 deletions(-)
