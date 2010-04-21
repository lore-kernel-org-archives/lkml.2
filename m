Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0DUMm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:42:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58432 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0DUMm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:42:26 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20100421124223.1E22E4CAC45@norville.austin.ibm.com>
Date: Wed, 21 Apr 2010 07:42:23 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/inode.c     |    2 +-
 fs/jfs/jfs_dmap.c  |   16 ++++++++--------
 fs/jfs/jfs_dmap.h  |    6 +++---
 fs/jfs/jfs_inode.h |    1 +
 fs/jfs/namei.c     |    4 ++--
 fs/jfs/resize.c    |    6 +++++-
 fs/jfs/symlink.c   |   14 +++++++++++++-
 7 files changed, 33 insertions(+), 16 deletions(-)

through these ChangeSets:

commit c7f2e1f0ac142a657a1de00d404e1c8345b20598
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Fri Apr 16 08:05:50 2010 -0500

    jfs: add jfs specific ->setattr call
    
    generic setattr not longer responsible for quota transfer.
    use jfs_setattr for all jfs's inodes.
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 2b0b39517d1af5294128dbc2fd7ed39c8effa540
Author: Bill Pemberton <wfp5p@virginia.edu>
Date:   Fri Apr 16 08:01:20 2010 -0500

    jfs: fix diAllocExt error in resizing filesystem
    
    Resizing the filesystem would result in an diAllocExt error in some
    instances because changes in bmp->db_agsize would not get noticed if
    goto extendBmap was called.
    
    Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Cc: jfs-discussion@lists.sourceforge.net
    Cc: linux-kernel@vger.kernel.org

commit d7eecb483cc29e929bbc5515b8def830d7fc6ad2
Author: Daniel Mack <daniel@caiaq.de>
Date:   Thu Jan 28 16:13:01 2010 +0800

    jfs_dmap.[ch]: trivial typo fix: s/heigth/height/g
    
    Signed-off-by: Daniel Mack <daniel@caiaq.de>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Cc: Jiri Kosina <trivial@kernel.org>
    Cc: André Goddard Rosa <andre.goddard@gmail.com>
    Cc: jfs-discussion@lists.sourceforge.net
