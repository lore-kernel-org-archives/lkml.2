Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0DLTWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:22:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab0DLTWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:22:04 -0400
Date: Mon, 12 Apr 2010 21:22:12 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] ext2, ext3, and quota fixes
Message-ID: <20100412192212.GN3404@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get a few fixes:

Andrew Perepechko (1):
      quota: Fix possible dq_flags corruption

Dmitry Monakhov (2):
      ext2: symlink must be handled via filesystem specific operation
      ext3: symlink must be handled via filesystem specific operation

Jan Kara (1):
      quota: Hide warnings about writes to the filesystem before quota was turned on

The diffstat is

 fs/ext2/symlink.c |    2 ++
 fs/ext3/symlink.c |    2 ++
 fs/quota/dquot.c  |   18 ++++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
