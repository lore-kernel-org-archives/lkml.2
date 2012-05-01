Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2EAPR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:17:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:17:57 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 0/5] overlayfs v3.4-rc5 updates
Date: Tue,  1 May 2012 16:17:50 +0100
Message-Id: <1335885475-11990-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been playing with getting overlayfs to work for v3.4, following
this email are the patches I am using on top of the stock overlayfs.v12
branch on the v3.4-rc5 base.  The first two are yet another revamp of the
security permissions patch which I posted a few times (hopefully fixing
your remaining comments).  The other three are porting issues for the
v3.2->v3.4 base.

These are also available as below:

  git://git.kernel.org/pub/scm/linux/kernel/git/apw/overlayfs.git overlayfs.v12apw1

Thanks to Sedat Dilek for all their testing feedback and Jordi Pojol for
his test scripts.

Please consider.

-apw

Andy Whitcroft (5):
  inode_only_permission: export inode level permissions checks
  overlayfs: switch to use inode_only_permissions
  overlayfs: follow header cleanup
  overlayfs: switch from d_alloc_root() to d_make_root()
  overlayfs: update touch_atime() usage

 fs/namei.c             |   48 +++++++++++++++++++++++++++++++-----------------
 fs/overlayfs/copy_up.c |    1 +
 fs/overlayfs/dir.c     |    1 +
 fs/overlayfs/inode.c   |   14 ++------------
 fs/overlayfs/readdir.c |    1 +
 fs/overlayfs/super.c   |   16 ++++++++--------
 include/linux/fs.h     |    1 +
 7 files changed, 45 insertions(+), 37 deletions(-)

-- 
1.7.9.5

