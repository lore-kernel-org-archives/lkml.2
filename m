Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2ASVij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:38:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2ASVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:38:34 -0500
Date: Thu, 19 Jan 2012 21:38:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] several vfs and fs fixes
Message-ID: <20120119213832.GA23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      qnx4: di_fname is an array, for crying out loud...
      qnx4: reduce the insane nesting in qnx4_checkroot()
      qnx4: don't leak ->BitMap on late failure exits

Kazuya Mio (1):
      wake up s_wait_unfrozen when ->freeze_fs fails

Miklos Szeredi (1):
      vfs: remove printk from set_nlink()

Diffstat:
 fs/inode.c      |    3 --
 fs/qnx4/inode.c |   62 ++++++++++++++++++++++--------------------------------
 fs/super.c      |    2 +
 3 files changed, 27 insertions(+), 40 deletions(-)
