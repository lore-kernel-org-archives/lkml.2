Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1EXPXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:23:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:50139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1EXPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:23:08 -0400
Date: Tue, 24 May 2011 17:23:04 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] Ext2 & ext3 fixes for 2.6.40-rc1
Message-ID: <20110524152304.GB5390@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/fs.git for_linus

Nothing too interesting, just couple of bugs fixed.

The full shortlog is:

Eryu Guan (1):
      jbd: Fix comment to match the code in journal_start()

Jan Kara (3):
      ext3: Fix lock inversion in ext3_symlink()
      ext3: Fix fs corruption when make_indexed_dir() fails
      jbd: Fix forever sleeping process in do_get_write_access()

Robin Dong (1):
      ext2: fix error msg when mounting fs with too-large blocksize

Tao Ma (1):
      jbd/jbd2: remove obsolete summarise_journal_usage.

Ted Ts'o (1):
      jbd: fix fsync() tid wraparound bug

The diffstat is

 fs/ext2/super.c      |    3 +-
 fs/ext3/namei.c      |   80 +++++++++++++++++++++++++++++++++++++++++--------
 fs/jbd/commit.c      |   15 ++++-----
 fs/jbd/journal.c     |   16 ++++++++--
 fs/jbd/transaction.c |    3 +-
 fs/jbd2/commit.c     |    6 ----
 6 files changed, 91 insertions(+), 32 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
