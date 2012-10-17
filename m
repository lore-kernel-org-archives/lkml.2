Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2JQAbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:31:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab2JQAbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:31:40 -0400
Date: Wed, 17 Oct 2012 02:31:38 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Fix regressions caused by user namespace conversions
 (ext2, ext3, quota)
Message-ID: <20121017003138.GF13227@quack.suse.cz>
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

to get three fixes of regressions caused by user namespace patches merged
recently, and minor ext3 fix and cleanup.

Top of the tree is 6c29c50. The full shortlog is:

Carlos Maiolino (2):
      ext3: fix possible non-initialized variable on htree_dirblock_to_tree()
      ext3: ext3_bread usage audit

Jan Kara (1):
      quota: Silence warning about PRJQUOTA not being handled in need_print_warning()

Zhao Hongjiang (2):
      ext2: fix return values on parse_options() failure
      ext3: fix return values on parse_options() failure

The diffstat is

 fs/ext2/super.c  |    4 ++--
 fs/ext3/namei.c  |   40 +++++++++++++++++++++-------------------
 fs/ext3/namei.h  |   19 +++++++++++++++++++
 fs/ext3/super.c  |    4 ++--
 fs/quota/dquot.c |    2 ++
 5 files changed, 46 insertions(+), 23 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
