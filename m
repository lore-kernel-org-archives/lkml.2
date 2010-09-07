Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0IGOvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:51:37 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48022 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757093Ab0IGOva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:51:30 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009071451.o87EpPVc014171@stout.americas.sgi.com>
Date: Tue, 07 Sep 2010 09:51:24 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.36-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following four XFS changes for 2.6.36.  Three
are bug fixes, one makes two simple changes to reduce the effect of
some hot spots on large systems.  Thanks.

					-Alex

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch '2.6.36-xfs-misc' of git://git.kernel.org/.../dgc/xfsdev

Arkadiusz Mi?kiewicz (1):
      xfs: Disallow 32bit project quota id

Dave Chinner (2):
      xfs: improve buffer cache hash scalability
      xfs: prevent 32bit overflow in space reservation

Tao Ma (1):
      xfs: Make fiemap work with sparse files

 fs/xfs/linux-2.6/xfs_buf.c   |    8 +-------
 fs/xfs/linux-2.6/xfs_buf.h   |    1 -
 fs/xfs/linux-2.6/xfs_ioctl.c |    7 +++++++
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/xfs_bmap.c            |   14 +++++++++++++-
 fs/xfs/xfs_fs.h              |    4 +++-
 fs/xfs/xfs_vnodeops.c        |   13 ++++++++++---
 7 files changed, 35 insertions(+), 14 deletions(-)
