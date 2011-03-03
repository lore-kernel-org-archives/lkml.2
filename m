Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab1CCGcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:32:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48539 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1CCGcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:32:14 -0500
Date: Thu, 3 Mar 2011 06:32:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] i_nlink fixes, part 1
Message-ID: <20110303063214.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ i_nlink

Shortlog:
Al Viro (8):
      sysv: i_nlink races in rename()
      ufs: i_nlink races in rename()
      minix: i_nlink races in rename()
      nilfs2: i_nlink races in rename()
      exofs: i_nlink races in rename()
      fix reiserfs mkdir() breakage
      udf: fix i_nlink limit
      hfs: fix rename() over non-empty directory

Diffstat:
 fs/exofs/namei.c    |    8 ++------
 fs/hfs/dir.c        |   50 +++++++++++++-------------------------------------
 fs/minix/namei.c    |    8 ++------
 fs/nilfs2/namei.c   |    8 +-------
 fs/reiserfs/namei.c |    2 +-
 fs/sysv/namei.c     |    8 ++------
 fs/udf/namei.c      |   11 +++++------
 fs/ufs/namei.c      |    9 ++-------
 8 files changed, 28 insertions(+), 76 deletions(-)
