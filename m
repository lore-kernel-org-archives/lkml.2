Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0DTVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:39:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:40114 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0DTVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:39:33 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1O4LAG-0003NN-0A@closure.thunk.org>
Date: Tue, 20 Apr 2010 17:39:28 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have some fixes for some data corruption bugs that should really get
pulled into the 2.6.34 kernel, so I'd appreciate it if you could pull
from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks,

						- Ted

 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    3 ++-
 fs/ext4/mballoc.c |   21 +++++++++++----------
 3 files changed, 14 insertions(+), 11 deletions(-)

Curt Wohlgemuth (2):
      ext4: Fix possible lost inode write in no journal mode
      ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()

Theodore Ts'o (1):
      ext4: Issue the discard operation *before* releasing the blocks to be reused



