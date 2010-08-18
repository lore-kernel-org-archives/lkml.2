Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0HRQwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:52:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0HRQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:52:39 -0400
Date: Wed, 18 Aug 2010 12:52:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs for rc2, part 1
Message-ID: <20100818165235.GA24783@infradead.org>
References: <20100818153528.GO31363@ZenIV.linux.org.uk>
 <AANLkTi=BZ9bvP0LE_SYAvfAPA1PN-E0UQ3-Oo09Qkib3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=BZ9bvP0LE_SYAvfAPA1PN-E0UQ3-Oo09Qkib3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 09:44:34AM -0700, Linus Torvalds wrote:
> On Wed, Aug 18, 2010 at 8:35 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Jan Kara (1):
> > ? ? ?vfs: update ctime when changing the file's permission by setfacl
> 
> What dirties the inode for this case? It seems to just set i_ctime
> directly, how does it actually get written back to disk?
> 
> Or is this purely a tmpfs/shmfs issue? Maybe a comment on that would
> have been good.

Yes, that code currently is just used for in-memory filesystems. Both
the generic_acl name for the file and the vfs: prefix for the patch
are rather confusing.

