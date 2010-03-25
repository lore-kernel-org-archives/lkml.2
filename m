Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0CYC6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 22:58:36 -0400
Received: from THUNK.ORG ([69.25.196.29]:56409 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0CYC6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 22:58:34 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Nucdy-0007fD-U4@closure.thunk.org>
Date: Wed, 24 Mar 2010 22:17:58 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: root@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following regression/urgent bug fixes for ext4 and jbd2.

Thanks,

                                                - Ted

Eric Sandeen (1):
      ext4: Fixed inode allocator to correctly track a flex_bg's used_dirs

Jan Kara (2):
      ext4: Fix estimate of # of blocks needed to write indirect-mapped files
      ext4: Don't use delayed allocation by default when used instead of ext3

Theodore Ts'o (1):
      ext4: Fix spelling of CONTIG_FS_EXT3 to CONFIG_FS_EXT3

 fs/ext4/ialloc.c |    4 ++--
 fs/ext4/inode.c  |    4 ++--
 fs/ext4/super.c  |   29 ++++++++++++++++++-----------
 3 files changed, 22 insertions(+), 15 deletions(-)
