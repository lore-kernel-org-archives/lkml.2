Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2KZLfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:35:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2KZLfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:35:05 -0500
Date: Mon, 26 Nov 2012 12:35:03 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL] ext3 regression fix (deadlock)
Message-ID: <20121126113503.GB4837@quack.suse.cz>
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

to get a fix of an ext3 regression introduced during 3.7 merge window. It
leads to deadlock if you stress the filesystem in the right way (luckily
only if blocksize < pagesize).

Top of the tree is 25389bb. The full shortlog is:

Jan Kara (1):
      jbd: Fix lock ordering bug in journal_unmap_buffer()

The diffstat is

 fs/jbd/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

							Thanks
								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
