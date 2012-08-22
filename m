Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2HVWFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:05:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab2HVWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:05:16 -0400
Date: Thu, 23 Aug 2012 00:05:14 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Some UDF, ext3 & reiserfs fixes for 3.5-rc4
Message-ID: <20120822220514.GA12395@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get a couple of fixes (udf, reiserfs, ext3) that accumulated over my
vacation.

Top of the tree is 68766a2. The full shortlog is:

Ashish Sangwan (1):
      UDF: During mount free lvid_bh before rescanning with different blocksize

Ian Abbott (1):
      udf: fix udf_setsize() for file data in ICB

Jan Kara (1):
      jbd: don't write superblock when unmounting an ro filesystem

Jeff Liu (1):
      quota: Move down dqptr_sem read after initializing default warn[] type at __dquot_alloc_space().

Jeff Mahoney (1):
      reiserfs: fix deadlocks with quotas

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

The diffstat is

 fs/jbd/journal.c     |    5 +++++
 fs/quota/dquot.c     |    2 +-
 fs/reiserfs/bitmap.c |    2 --
 fs/reiserfs/inode.c  |    2 +-
 fs/udf/inode.c       |    5 ++++-
 fs/udf/super.c       |    7 ++++++-
 6 files changed, 17 insertions(+), 6 deletions(-)

							Thanks
								Honza
