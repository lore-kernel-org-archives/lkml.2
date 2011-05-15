Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab1EOOrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:47:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28662 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1EOOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:47:41 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs updates
Date: Sun, 15 May 2011 10:47:23 -0400
Message-Id: <1305470325-sup-6477@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DCFE78A.00E1:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everyone,

The master branch of the btrfs unstable tree has a few more fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

These include small fixes in the new per-file flags, an oops in
the btrfs acl code and ENOSPC fixes for mixed block groups (used in very
small filesystems).

Li Zefan (3) commits (+15/-10):
    Btrfs: fix FS_IOC_SETFLAGS ioctl (+2/-0)
    Btrfs: fix FS_IOC_GETFLAGS ioctl (+7/-0)
    fs: remove FS_COW_FL (+6/-10)

Daniel J Blueman (1) commits (+3/-2):
    Prevent oopsing in posix_acl_valid()

liubo (1) commits (+26/-11):
    Btrfs: fix easily get into ENOSPC in mixed case

Total: (5) commits (+44/-23)

 fs/btrfs/acl.c         |    5 +++--
 fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++++++++-----------
 fs/btrfs/ioctl.c       |   24 +++++++++++++++---------
 include/linux/fs.h     |    1 -
 4 files changed, 44 insertions(+), 23 deletions(-)
