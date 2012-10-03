Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2JCOPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:15:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38135 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2JCOPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:15:52 -0400
Message-ID: <506C488A.4@oracle.com>
Date: Wed, 03 Oct 2012 09:15:38 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net
Subject: [GIT PULL] JFS updates for 3.7
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

It's been a while, but I've got some JFS updates for you.

The following changes since commit fbcbe2b3c92ee1c930dcfcf8bb764074c100fd63:

  Merge tag 'sound-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2012-09-13 19:51:41 +0800)

are available in the git repository at:

  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.7

for you to fetch changes up to 84f4141ee3ea11035f741d4298cb6bbad1850fcf:

  jfs: Fix do_div precision in commit b40c2e66 (2012-09-18 11:27:22 -0500)

----------------------------------------------------------------
JFS TRIM support and some minor fixes

----------------------------------------------------------------
Dave Kleikamp (2):
      jfs: Remove obsolete email address
      jfs: Fix do_div precision in commit b40c2e66

Tino Reichardt (1):
      fs/jfs: TRIM support for JFS Filesystem

Wei Yongjun (1):
      JFS: use list_move instead of list_del/list_add

 Documentation/filesystems/jfs.txt |  19 ++++--
 fs/jfs/Makefile                   |   2 +-
 fs/jfs/ioctl.c                    |  43 ++++++++++++-
 fs/jfs/jfs_discard.c              | 117 +++++++++++++++++++++++++++++++++++
 fs/jfs/jfs_discard.h              |  26 ++++++++
 fs/jfs/jfs_dmap.c                 | 126 ++++++++++++++++++++++++++++++++++++--
 fs/jfs/jfs_dmap.h                 |   2 +
 fs/jfs/jfs_filsys.h               |   3 +
 fs/jfs/jfs_incore.h               |   1 +
 fs/jfs/jfs_txnmgr.c               |   9 +--
 fs/jfs/super.c                    |  71 ++++++++++++++++-----
 11 files changed, 388 insertions(+), 31 deletions(-)
 create mode 100644 fs/jfs/jfs_discard.c
 create mode 100644 fs/jfs/jfs_discard.h
