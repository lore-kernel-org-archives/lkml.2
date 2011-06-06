Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1FFN2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:28:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46859 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1FFN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:28:16 -0400
Date: Mon, 6 Jun 2011 14:28:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs fixes
Message-ID: <20110606132814.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	More fixes for the stuff that went in during the merge window...
I've dropped the get_net_ns_by_fd fix from this queue, since davem has taken
it in net-2.6.git.  Please, pull from usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ #for-linus

Shortlog:
Al Viro (1):
      more conservative S_NOSEC handling

Sage Weil (1):
      usb: remove bad dput after dentry_unhash

Diffstat:
 drivers/usb/core/inode.c |    1 -
 fs/btrfs/super.c         |    2 +-
 fs/fuse/inode.c          |    2 ++
 fs/ocfs2/super.c         |    2 +-
 fs/super.c               |    2 +-
 include/linux/fs.h       |    3 ++-
 mm/filemap.c             |    2 +-
 7 files changed, 8 insertions(+), 6 deletions(-)
