Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1IBPCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:02:44 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52511 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752531Ab1IBPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:02:42 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201109021502.p82F2W3w003902@stout.americas.sgi.com>
Date: Fri, 02 Sep 2011 10:02:32 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.1-rc5
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS changes for 3.1-rc5.  The first
documents a feature that we plan to remove in 3.3.  The second fixes
a problem related to inode dirtying during unmount, and the third
fixes some other problems found in that region of code.

The last two have not been through a -next build because of the
recent kernel.org issues, but I've done testing with a local pull
into your current master branch and all looks well.

Thank you.

					-Alex

The following changes since commit 9e79e3e9dd9672b37ac9412e9a926714306551fe:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-08-30 11:28:18 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: deprecate the nodelaylog mount option
      xfs: fix xfs_mark_inode_dirty during umount
      xfs: fix ->write_inode return values

 Documentation/feature-removal-schedule.txt |    8 ++++++
 fs/xfs/xfs_iops.c                          |   14 ++++++++--
 fs/xfs/xfs_super.c                         |   36 ++++++++-------------------
 3 files changed, 30 insertions(+), 28 deletions(-)
