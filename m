Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2AXOZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:25:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab2AXOZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:25:07 -0500
Date: Tue, 24 Jan 2012 15:25:00 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] Ext3 & ext2 fix, quota improvement
Message-ID: <20120124142500.GE18136@quack.suse.cz>
References: <20120120163910.GA16973@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120163910.GA16973@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 20-01-12 17:39:10, Jan Kara wrote:
>   Hello Linus,
> 
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus
> 
> The most important is an ext3 fix of corruption after power failure. The
> other two patches are just minor things...
> 
> Top of the tree is 46fe44c. The full shortlog is:
> 
> Djalal Harouni (1):
>       ext2: protect inode changes in the SETVERSION and SETFLAGS ioctls
> 
> Jan Kara (2):
>       jbd: Issue cache flush after checkpointing
>       quota: Pass information that quota is stored in system file to userspace
  Did you just forget to pull or do you disagree with some of the changes?

								Honza
> 
> The diffstat is
> 
>  fs/ext2/ioctl.c       |   22 ++++++++++++++++------
>  fs/jbd/checkpoint.c   |   27 ++++++++++++++++++++++-----
>  fs/jbd/recovery.c     |    4 ++++
>  fs/quota/dquot.c      |    8 +++++---
>  include/linux/quota.h |    6 +++++-
>  5 files changed, 52 insertions(+), 15 deletions(-)
> 
> 							Thanks
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
