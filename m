Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2CJVa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:30:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2CJVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:30:56 -0500
Date: Sat, 10 Mar 2012 21:30:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20120310213050.GD23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A bunch of assorted fixes; Jan's freezing stuff still _not_
in there and neither is mm fun ;-/  Please, pull from usual place -
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Jan Kara (2):
      udf: Fix deadlock in udf_release_file()
      vfs: Fix missed wakeup in I_NEW handling

Miklos Szeredi (2):
      vfs: fix double put after complete_walk()
      vfs: fix return value from do_last()

Tyler Hicks (1):
      vfs: Correctly set the dir i_mutex lockdep class

Diffstat:
 fs/inode.c                |   25 +++++++++++++++++++++++--
 fs/namei.c                |    4 ++--
 fs/udf/file.c             |    2 --
 include/linux/writeback.h |    5 -----
 4 files changed, 25 insertions(+), 11 deletions(-)
