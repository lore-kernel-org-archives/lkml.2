Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1KUTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:09:58 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:57998 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KUTJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:09:56 -0500
Date: Mon, 21 Nov 2011 14:09:17 -0500
Message-Id: <E1RSZEz-0001Zp-NV@tytso-glaptop.cam.corp.google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ext4 bugfixes for 3.2
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is a signed tag tytso-for-linus-20111120 covering this set of
changes, which are some miscellaneous bug fixes for 3.2.  Thanks!!

	       	   		      	  - Ted

The following changes since commit 5c8a0fbba543d9428a486f0d1282bbcf3cf1d95a:

  VFS: fix statfs() automounter semantics regression (2011-11-04 18:15:59 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Namjae Jeon (1):
      ext4: add blk_finish_plug in error case of writepages.

Richard Weinberger (1):
      ext4: Remove kernel_lock annotations

Theodore Ts'o (1):
      ext4: ignore journalled data options on remount if fs has no journal

Yongqiang Yang (1):
      ext4: fix up a undefined error in ext4_free_blocks in debugging code

 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |    1 +
 fs/ext4/super.c  |    6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)
